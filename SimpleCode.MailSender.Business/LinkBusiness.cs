using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Transactions;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
	public class LinkBusiness
	{
        private IDataConfig config;
		private LinkData data;

		public LinkBusiness(IDataConfig config)
		{
            this.config = config;
			data = new LinkData(config);
		}

		public IList<LinkInfo> Listar(int codigoMensagem)
		{
			return data.Listar(codigoMensagem);
		}

		public LinkInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(LinkInfo link)
		{
			data.Inserir(link);
		}

		public void Atualizar(LinkInfo link)
		{
			data.Atualizar(link);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

        public IList<LinkInfo> BuscarLinks(MensagemInfo mensagem)
        {
            Regex regex = new Regex(@"http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?");
            MatchCollection matches = regex.Matches(mensagem.HTML);
            IList<LinkInfo> links = new List<LinkInfo>();
            foreach (Match match in matches)
            {
                LinkInfo link = new LinkInfo()
                {
                    Endereco = match.Value
                };
                links.Add(link);
            }
            return links;
        }

        public void Inserir(IList<LinkInfo> links, MensagemInfo mensagem)
        {     
            LinkParametroRastreamentoBusiness parametroBusiness = new LinkParametroRastreamentoBusiness(config);
            try
            {
                IList<LinkInfo> linksExistentes = Listar(mensagem.Codigo);
                using (TransactionScope scope = new TransactionScope())
                {
                    if(linksExistentes.Count > 0)
                        foreach (LinkInfo existente in linksExistentes)
                        {
                            parametroBusiness.Excluir(existente.Codigo);
                            Excluir(existente.Codigo);
                        }
                    int i;
                    foreach (LinkInfo link in links)
                    {
                        if (link.ParametrosRastreamento.Count > 0)
                        {
                            i = 0;
                            link.CodigoMensagem = mensagem.Codigo;
                            Inserir(link);
                            foreach (LinkParametroRastreamentoInfo parametro in link.ParametrosRastreamento)
                            {
                                parametro.CodigoLink = link.Codigo;
                                parametroBusiness.Inserir(parametro);
                                i++;
                            }
                        }
                    }
                    scope.Complete();
                }
            }
            catch(Exception ex)
            {
                throw ex;
            }
        }

        public string AplicarTrackeamento(int codigoMensagem, string html)
        {
            // TODO: revisar
            IList<LinkInfo> links = Listar(codigoMensagem);
            if(links.Count > 0)
            {
                int i;
                string novoLink, s;
                foreach (LinkInfo link in links)
                {
                    i = 0;
                    novoLink = link.Endereco;
                    foreach (LinkParametroRastreamentoInfo parametro in link.ParametrosRastreamento)
                    {
                        s = !novoLink.Contains("?") && i == 0 ? "?" : "&";
                        novoLink += string.Concat(s, parametro.Nome, "=", parametro.Valor);
                        i++;
                    }
                    html = html.Replace(link.Endereco, novoLink);
                }
            }
            return html;
        }
	}
}
