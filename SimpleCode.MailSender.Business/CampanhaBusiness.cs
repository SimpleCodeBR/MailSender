using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class CampanhaBusiness
	{
		private CampanhaData data;

		public CampanhaBusiness(IDataConfig config)
		{
			data = new CampanhaData(config);
		}

		public IList<CampanhaInfo> Listar(int codigoAmbiente)
		{
			return data.Listar(codigoAmbiente);
		}

        public IList<CampanhaInfo> ListarPorServidor(int codigoServidor)
        {
            return data.Listar(codigoServidor);
        }

        public IList<CampanhaInfo> ListarPorRemetente(int codigoRemetente)
        {
            return data.Listar(codigoRemetente);
        }

		public CampanhaInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(CampanhaInfo campanha)
		{
			data.Inserir(campanha);
		}

		public void Atualizar(CampanhaInfo campanha)
		{
			data.Atualizar(campanha);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

	}
}
