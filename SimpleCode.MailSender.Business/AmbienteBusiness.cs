using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class AmbienteBusiness
	{
		private AmbienteData data;

		public AmbienteBusiness(IDataConfig config)
		{
			data = new AmbienteData(config);
		}

		public IList<AmbienteInfo> Listar()
		{
			return data.Listar();
		}

		public AmbienteInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(AmbienteInfo ambiente)
		{
			data.Inserir(ambiente);
		}

		public void Atualizar(AmbienteInfo ambiente)
		{
			data.Atualizar(ambiente);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

	}
}
