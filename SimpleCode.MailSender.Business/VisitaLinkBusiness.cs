using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class VisitaLinkBusiness
	{
		private VisitaLinkData data;

		public VisitaLinkBusiness(IDataConfig config)
		{
			data = new VisitaLinkData(config);
		}

		public IList<VisitaLinkInfo> Listar()
		{
			return data.Listar();
		}

		public VisitaLinkInfo Consultar(int codigoDisparo)
		{
			return data.Consultar(codigoDisparo);
		}

		public void Inserir(VisitaLinkInfo visitaLink)
		{
			data.Inserir(visitaLink);
		}

		public void Atualizar(VisitaLinkInfo visitaLink)
		{
			data.Atualizar(visitaLink);
		}

		public void Excluir(int codigoDisparo)
		{
			data.Excluir(codigoDisparo);
		}

	}
}
