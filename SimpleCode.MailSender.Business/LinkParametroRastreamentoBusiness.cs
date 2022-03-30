using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
    public class LinkParametroRastreamentoBusiness
	{
		private LinkParametroRastreamentoData data;

		public LinkParametroRastreamentoBusiness(IDataConfig config)
		{
			data = new LinkParametroRastreamentoData(config);
		}

		public void Inserir(LinkParametroRastreamentoInfo linkParametroRastreamento)
		{
			data.Inserir(linkParametroRastreamento);
		}

        public void Excluir(int codigoLink)
        {
            data.Excluir(codigoLink);
        }
	}
}
