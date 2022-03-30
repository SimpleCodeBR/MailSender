using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Mail;
using System.Threading;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
    public class Messenger
    {
        private ManualResetEvent reset;
        private IDataConfig config;

        public Messenger(ManualResetEvent reset, IDataConfig config)
        {
            this.reset = reset;
            this.config = config;
        }

        public void Send(object obj)
        {
            OcorrenciaDisparoInfo ocorrencia = obj as OcorrenciaDisparoInfo;
            if (ocorrencia != null)
            {
                Send(obj as OcorrenciaDisparoInfo);
                reset.Set();
            }
        }

        private void Send(OcorrenciaDisparoInfo message)
        {
            if (message != null)
            {
                var detalheEnvio = string.Concat("[disparo ", message.CodigoDisparo, " - contato ", message.CodigoContato, "]");
                var ocorrenciaDisparoBusiness = new OcorrenciaDisparoBusiness(config);
                var alertaBusiness = new AlertaBusiness(config);
                
                message.Tentativas++;
                message.UltimaAlteracao = DateTime.Now;

                try
                {
                    AlertaInfo alerta = new AlertaInfo(string.Concat("Enviando ", detalheEnvio, " via ", message.Smtp.Host, "..."), TipoAlerta.Alerta);
                    alertaBusiness.Inserir(alerta);

                    // Preenche remetente, destinatário, subject e body
                    ocorrenciaDisparoBusiness.PreencherDetalhes(message);
                    
                    // Customiza as variáveis
                    string assunto, corpo;
                    SubstituirVariaveis(message, out assunto, out corpo);
                    message.Subject = assunto;
                    message.Body = corpo;
                    
                    // Inclui os anexos
                    foreach (var anexo in message.Anexos)
                    {
                        var attachment = new Attachment(anexo.Arquivo);
                        attachment.ContentId = Path.GetFileNameWithoutExtension(anexo.Arquivo);
                        message.Attachments.Add(attachment);
                    }
                    
                    var emailNaoEnviar = config.EmailNaoEnviar;                    

                    // Envia a mensagem
                    message.IsBodyHtml = true;
                    if (string.IsNullOrEmpty(emailNaoEnviar) || !emailNaoEnviar.ToLower().Equals(message.To[0].Address.ToLower()))
                        message.Send();
                    alerta = new AlertaInfo(string.Concat("Ocorrência ", detalheEnvio, " enviada!"), TipoAlerta.Alerta);
                    alertaBusiness.Inserir(alerta);

                    // Atualiza o status
                    message.StatusDisparo = StatusDisparo.Enviado;
                    message.Enviado = true;
                    ocorrenciaDisparoBusiness.AtualizarEnvio(message);

                    // Grava snapshot
                    try
                    {
                        ocorrenciaDisparoBusiness.InserirSnapshot(message);
                    }
                    catch (Exception ex)
                    {
                        alerta = new AlertaInfo(string.Concat("Erro ao gravar snapshot ", detalheEnvio), TipoAlerta.Erro, ex);
                        alertaBusiness.Inserir(alerta);
                    }
                }
                catch (Exception ex)
                {
                    if (message.Tentativas <= 0) message.Tentativas = 0;
                    message.Tentativas++;
                    message.UltimaAlteracao = DateTime.Now;
                    message.StatusDisparo = StatusDisparo.NaoIniciado;
                    ocorrenciaDisparoBusiness.AtualizarEnvio(message);
                    AlertaInfo alerta = new AlertaInfo(string.Concat("Erro ao enviar ocorrência ", detalheEnvio), TipoAlerta.Erro, ex);
                    alertaBusiness.Inserir(alerta);
                }
            }
        }

        public void SubstituirVariaveis(OcorrenciaDisparoInfo message, out string assunto, out string corpo)
        {
            assunto = message.Subject
                .Replace("$$$nome$$$", message.To[0].DisplayName)
                .Replace("$$$email$$$", message.To[0].Address);
            corpo = message.Body
                .Replace("$$$nome$$$", message.To[0].DisplayName)
                .Replace("$$$email$$$", message.To[0].Address);

            IList<KeyValuePair<string, string>> valores = new VariavelBusiness(config).BuscarValores(message.CodigoDisparo,
                                                                                               message.CodigoContato);

            var valoresGlobais = new VariavelValorGlobalBusiness(config).Listar(message.CodigoAmbiente);

            if (valoresGlobais.Count > 0)
            {
                foreach  (var valorGlobal in valoresGlobais)
				{
                    var incluir = true;

                    foreach (var valor in valores)
					{
                        if (valor.Key.ToLower().Equals(valorGlobal.Chave.ToLower()))
						{
                            incluir = false;
                            break;
                        }                            
					}

                    if (incluir)
                        valores.Add(new KeyValuePair<string, string>(valorGlobal.Chave, valorGlobal.Valor));
				}
            }

            if (valores.Count > 0)
            {
                foreach (KeyValuePair<string, string> pair in valores)
                {
                    corpo = corpo.Replace(pair.Key, pair.Value);
                    assunto = assunto.Replace(pair.Key, pair.Value);
                }
            }           
        }        
    }
}