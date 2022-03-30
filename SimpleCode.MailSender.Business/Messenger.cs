using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.IO;
using System.Net.Mail;
using System.Net.Mime;
using System.Text;
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
                
                message.Tentativas++;
                message.UltimaAlteracao = DateTime.Now;

                try
                {
                    AlertaInfo alerta = new AlertaInfo(string.Concat("Enviando ", detalheEnvio, " via ", message.Smtp.Host, "..."), TipoAlerta.Alerta);
                    alerta.Salvar();
                    
                    // Preenche remetente, destinatário, subject e body
                    ocorrenciaDisparoBusiness.PreencherDetalhes(message);
                    
                    // Customiza as variáveis
                    string assunto, corpo;
                    SubstituirVariaveis(message, out assunto, out corpo);
                    message.Subject = assunto;
                    message.Body = corpo;
                    
                    // Aplica o trackeamento
                    message.Body = new LinkBusiness(config).AplicarTrackeamento(message.Mensagem.Codigo, message.Body);
                    
                    /*
                    // Aplica link para visualização alternativa
                    message.Body = AdicionarLinkAlternativo(message);
                    
                    // Adiciona opção para remoção, se houver campanha
                    if (message.Mensagem.Campanha.Codigo > 0)
                        message.Body = AdicionarLinkRemocao(message);
                    */
                    
                    // Aplica referência para contabilizar visitas
                    message.Body = AdicionarContadorVisitas(message);

                    // Inclui os anexos
                    foreach (var anexo in message.Anexos)
                    {
                        var attachment = new Attachment(anexo.Arquivo);
                        attachment.ContentId = Path.GetFileNameWithoutExtension(anexo.Arquivo);
                        message.Attachments.Add(attachment);
                    }

                    // TODO
                    // var emailNaoEnviar = ConfigurationManager.AppSettings["EmailNaoEnviar"];
                    var emailNaoEnviar = string.Empty;

                    // Envia a mensagem
                    message.IsBodyHtml = true;
                    if (string.IsNullOrEmpty(emailNaoEnviar) || !emailNaoEnviar.ToLower().Equals(message.To[0].Address.ToLower()))
                        message.Send();
                    alerta = new AlertaInfo(string.Concat("Ocorrência ", detalheEnvio, " enviada!"), TipoAlerta.Alerta);
                    alerta.Salvar();
                    
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
                        alerta.Salvar();
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
                    alerta.Salvar();
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

        public string AdicionarContadorVisitas(OcorrenciaDisparoInfo message)
        {
            // TODO: remover

            throw new NotImplementedException();

            /*
            StringBuilder sb = new StringBuilder();
            sb.Append("<img src=\"").
                Append(ConfigurationManager.AppSettings["OnlineViewUrl"]).Append("visitas.aspx").
                Append("?d=").Append(message.CodigoDisparo).Append("&c=").Append(message.CodigoContato);
            sb.Append("\" height=\"0\" width=\"0\" border=\"0\">" + Environment.NewLine);
            sb.Append("</body>" + Environment.NewLine);
            return message.Body.Replace("</body>", sb.ToString());
            */
        }

        private string AdicionarLinkAlternativo(OcorrenciaDisparoInfo message)
        {
            // TODO: remover 

            throw new NotImplementedException();

            /*
            StringBuilder sb = new StringBuilder();
            sb.Append("<body>" + Environment.NewLine);
            sb.Append("<center>" + Environment.NewLine);
            sb.Append("<span style=\"font-family: Arial; font-size: 11px;\"><a href=\"");
            sb.Append(ConfigurationManager.AppSettings["OnlineViewUrl"]).Append("render.aspx").Append("?d=").Append(message.CodigoDisparo).
                Append("&c=").Append(message.CodigoContato);
            sb.Append("\">Problemas para visualizar a mensagem? Acesse este link.</a>" + Environment.NewLine);
            sb.Append("</span>" + Environment.NewLine);
            sb.Append("</center><br />" + Environment.NewLine);

            return message.Body.Replace("<body>", sb.ToString());
            */
        }

        private string AdicionarLinkRemocao(OcorrenciaDisparoInfo message)
        {
            // TODO

            throw new NotImplementedException();

            /*
            StringBuilder sb = new StringBuilder();
            sb.Append("<br><br><center>" + Environment.NewLine);
            sb.Append("<span style=\"font-family: Arial; font-size: 11px;\"><a href=\"");
            sb.Append(ConfigurationManager.AppSettings["OnlineViewUrl"]).Append("remover.aspx").Append("?ca=").Append(message.Mensagem.Campanha.Codigo).
                Append("&co=").Append(message.CodigoContato);
            sb.Append("\">").Append(message.Mensagem.Campanha.Nome);
            sb.Append(" respeita a sua privacidade e é contra o spam na rede. Caso você não queira mais receber nossos e-mails de novidades, remova aqui.</a>" + Environment.NewLine);
            sb.Append("</span>" + Environment.NewLine);
            sb.Append("</center><br />" + Environment.NewLine);
            sb.Append("</body>" + Environment.NewLine);

            return message.Body.Replace("</body>", sb.ToString());
            */
        }
    }
}