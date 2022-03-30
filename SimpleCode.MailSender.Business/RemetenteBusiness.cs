using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class RemetenteBusiness
	{
		private RemetenteData data;

		public RemetenteBusiness(IDataConfig config)
		{
			data = new RemetenteData(config);
		}

        public IList<RemetenteInfo> Listar(int codigoAmbiente)
		{
			return data.Listar(codigoAmbiente);
		}

		public RemetenteInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(RemetenteInfo remetente)
		{
			data.Inserir(remetente);
		}

		public void Atualizar(RemetenteInfo remetente)
		{
			data.Atualizar(remetente);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}
	}
}
