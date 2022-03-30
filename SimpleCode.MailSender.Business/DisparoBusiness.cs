using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;

namespace SimpleCode.MailSender.Business
{
    public class DisparoBusiness
    {
        private IDataConfig config;
        private DisparoData data;

        public DisparoBusiness(IDataConfig config)
        {
            data = new DisparoData(config);
            this.config = config;
        }

        public IList<DisparoInfo> Listar(int codigoAmbiente)
        {
            return data.Listar(codigoAmbiente, true);
        }

        public IList<DisparoInfo> ListarSemMensagem(int codigoAmbiente)
        {
            return data.Listar(codigoAmbiente, false);
        }

        public IList<DisparoInfo> ListarPorMensagem(int codigoMensagem)
        {
            return data.ListarPorMensagem(codigoMensagem);
        }

        public DisparoInfo Consultar(int codigo)
        {
            return data.Consultar(codigo);
        }

        public void Inserir(DisparoInfo disparo)
        {       
            data.Inserir(disparo);

            foreach (DestinatarioInfo destinatario in disparo.Destinatarios)
            {
                destinatario.CodigoDisparo = disparo.Codigo;
                InserirDestinatario(destinatario);
            }

            GerarOcorrencias(disparo.Codigo);         
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, string emailDestinatario, params string[] variaveis)
        {
            ContatoBusiness contatoBusiness = new ContatoBusiness(config);
            ContatoInfo contato = contatoBusiness.Buscar(codigoAmbiente, true, string.Empty, string.Empty, emailDestinatario).FirstOrDefault();

            if (contato == null || contato.Codigo <= 0)
            {
                contato = new ContatoInfo()
                {
                    Apelido = emailDestinatario,
                    CodigoAmbiente = codigoAmbiente,
                    Criacao = DateTime.Now,
                    Email = emailDestinatario,
                    Ativo = true,
                    Nome = emailDestinatario
                };

                contatoBusiness.Inserir(contato);
            }

            Inserir(codigoAmbiente, codigoMensagem, contato.Codigo, TipoDestinatario.Contato, variaveis);
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, params string[] variaveis)
        {
            Inserir(codigoAmbiente, codigoMensagem, codigoDestinatario, tipo, new StringCollection(), variaveis);
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, IList<int> copias, params string[] variaveis)
        {
            Inserir(codigoAmbiente, codigoMensagem, codigoDestinatario, tipo, copias, new StringCollection(), variaveis);
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, StringCollection anexos, params string[] variaveis)
        {
            Inserir(codigoAmbiente, codigoMensagem, codigoDestinatario, tipo, new List<int>(), anexos, variaveis);
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, IList<int> copias, StringCollection anexos, params string[] variaveis)
        {
            Inserir(codigoAmbiente, codigoMensagem, codigoDestinatario, tipo, copias, anexos, new Dictionary<string, string>(), variaveis);
        }

        public void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, IList<int> copias, StringCollection anexos, Dictionary<string, string> variaveis)
        {
            Inserir(codigoAmbiente, codigoMensagem, codigoDestinatario, tipo, copias, anexos, variaveis, new string[0]);
        }

        private void Inserir(int codigoAmbiente, int codigoMensagem, int codigoDestinatario, TipoDestinatario tipo, IList<int> copias, StringCollection anexos, Dictionary<string, string> variaveis1, params string[] variaveis2)
        {
            var mensagem = new MensagemBusiness(config).Consultar(codigoMensagem);
            var variaveisDicTratado = new Dictionary<string, string>(StringComparer.InvariantCultureIgnoreCase);

            foreach (var v in variaveis1)
            {
                variaveisDicTratado[v.Key.Trim()] = v.Value;
            }

            if (variaveis2.Length > 0 && mensagem.Variaveis.Count > 0 && mensagem.Variaveis.Count > variaveis2.Length)
            {
                throw new ArgumentException("A quantidade de vari�veis esperada para esta mensagem � maior que a quantidade de valores informados.");
            }

            var variavelData = new VariavelData(config);
            var anexoBzz = new AnexoBusiness(config);
            var codigosContatos = new List<int>();
            var codigoRemetente = new RemetenteBusiness(config).Listar(codigoAmbiente).First().Codigo;

            if (anexos.Count > 0)
            {
                if (tipo == TipoDestinatario.Contato)
                    codigosContatos.Add(codigoDestinatario);
                else if (tipo == TipoDestinatario.Grupo)
                {
                    var contatos = new ContatoBusiness(config).ListarPorGrupo(codigoDestinatario);
                    foreach (var contato in contatos)
                    {
                        codigosContatos.Add(contato.Codigo);
                    }
                }
            }

            //using (TransactionScope scope = new TransactionScope())
            //{
            DisparoInfo disparo = new DisparoInfo()
            {
                Ativo = true,
                CodigoAmbiente = codigoAmbiente,
                CodigoMensagem = codigoMensagem,
                CodigoRemetente = codigoRemetente,
                Criacao = DateTime.Now,
                StatusDisparo = StatusDisparo.NaoIniciado
            };

            DestinatarioInfo destinatario = new DestinatarioInfo()
            {
                Codigo = codigoDestinatario,
                Tipo = tipo
            };

            disparo.Destinatarios.Add(destinatario);
            Inserir(disparo);

            for (int i = 0; i < mensagem.Variaveis.Count; i++)
            {
                var valor = string.Empty;
                if (variaveis2.Length > 0)
                {
                    if (i >= variaveis2.Length)
                    {
                        var alerta = new AlertaInfo(string.Concat("Valor da variável ", mensagem.Variaveis[i].Nome, " não fornecido."), TipoAlerta.Alerta);
                        new AlertaBusiness(config).Inserir(alerta);
                    }
                        
                    else
                        valor = variaveis2[i];
                }
                else
                {
                    if (variaveisDicTratado.ContainsKey(mensagem.Variaveis[i].Nome))
                        valor = variaveisDicTratado[mensagem.Variaveis[i].Nome];
                    else
                    {
                        var conteudo = string.Empty;

                        foreach (var var in variaveisDicTratado)
                        {
                            conteudo = string.Concat(conteudo, "Chave: \"" + var.Key + "\" Valor: \"" + var.Value + "\"|");
                        }                       

                        var alerta = new AlertaInfo(string.Concat("Valor da variável ", mensagem.Variaveis[i].Nome, " não fornecido."), TipoAlerta.Erro, new ApplicationException("Valor do dicionário: " + conteudo));
                        new AlertaBusiness(config).Inserir(alerta);
                    }

                }

                VariavelValorInfo v = new VariavelValorInfo()
                {
                    CodigoContato = codigoDestinatario,
                    CodigoDisparo = disparo.Codigo,
                    CodigoVariavel = mensagem.Variaveis[i].Codigo,
                    Valor = valor
                };
                variavelData.Inserir(v);
            }

            foreach (var copia in copias)
            {
                data.InserirDestinatarioCopia(disparo.Codigo, copia);
            }

            foreach (var anexo in anexos)
            {
                if (File.Exists(anexo))
                {
                    foreach (var codigoContato in codigosContatos)
                    {
                        var anexoInfo = new AnexoInfo
                        {
                            Arquivo = anexo,
                            CodigoContato = codigoContato,
                            CodigoDisparo = disparo.Codigo
                        };
                        anexoBzz.Inserir(anexoInfo);
                    }
                }
                else
                {
                    var alerta = new AlertaInfo(string.Concat("Anexo inexistente: ", anexo, " [mensagem ", codigoMensagem, " / contato ", codigoDestinatario, "]"), TipoAlerta.Erro);
                    new AlertaBusiness(config).Inserir(alerta);
                }
            }

            //scope.Complete();
            //}
        }

        public void Atualizar(DisparoInfo disparo)
        {
            data.Atualizar(disparo);
        }

        public void Excluir(int codigo)
        {
            data.Excluir(codigo);
        }

        public void InserirDestinatario(DestinatarioInfo destinario)
        {
            if (destinario.Tipo == TipoDestinatario.Contato)
            {
                data.InserirDestinatario(destinario.CodigoDisparo, null, destinario.Codigo);
            }
            else if (destinario.Tipo == TipoDestinatario.Grupo)
            {
                data.InserirDestinatario(destinario.CodigoDisparo, destinario.Codigo, null);
            }
        }

        private void GerarOcorrencias(object codigoDisparo)
        {
            data.GerarOcorrencias(Convert.ToInt32(codigoDisparo));            
        }
    }
}