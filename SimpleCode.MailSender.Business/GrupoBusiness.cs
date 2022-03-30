using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class GrupoBusiness
	{
		private GrupoData data;

		public GrupoBusiness(IDataConfig config)
		{
			data = new GrupoData(config);
		}

		public IList<GrupoInfo> Listar()
		{
			return data.Listar();
		}

		public GrupoInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(GrupoInfo grupo)
		{
			data.Inserir(grupo);
		}

		public void Atualizar(GrupoInfo grupo)
		{
			data.Atualizar(grupo);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

        public IList<GrupoInfo> ListarPorCampanha(int codigoCampanha)
        {
            return data.ListarPorCampanha(codigoCampanha);
        }

        public IList<GrupoInfo> ListarPorAmbiente(int codigoAmbiente)
        {
            return data.ListarPorAmbiente(codigoAmbiente);
        }

        public IList<GrupoInfo> ListarPorContato(int codigoContato)
        {
            return data.ListarPorContato(codigoContato);
        }

        public void AssociarCampanha(int codigoCampanha, int codigoGrupo)
        {
            data.AssociarCampanha(codigoCampanha, codigoGrupo);
        }

        public void RemoverCampanha(int codigoCampanha, int codigoGrupo)
        {
            data.RemoverCampanha(codigoCampanha, codigoGrupo);
        }
	}
}