using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class OcorrenciaDisparoBusiness
	{
		private OcorrenciaDisparoData data;

		public OcorrenciaDisparoBusiness(IDataConfig config)
		{
			data = new OcorrenciaDisparoData(config);
		}

		public Queue<OcorrenciaDisparoInfo> Listar(int quantidade)
		{
			return data.Listar(quantidade);
		}

        public IList<OcorrenciaDisparoInfo> ListarPorDisparo(int codigoDisparo)
        {
            return data.ListarPorDisparo(codigoDisparo);
        }
        
        public OcorrenciaDisparoInfo Consultar(int codigoDisparo, int codigoContato)
        {
            return data.Consultar(codigoDisparo, codigoContato);
        }

		public void Inserir(OcorrenciaDisparoInfo ocorrenciaDisparo)
		{
			data.Inserir(ocorrenciaDisparo);
		}

        public void InserirSnapshot(OcorrenciaDisparoInfo ocorrenciaDisparo)
        {
            data.InserirSnapshot(ocorrenciaDisparo);
        }

        public void AtualizarEnvio(OcorrenciaDisparoInfo ocorrenciaDisparo)
		{
			data.AtualizarEnvio(ocorrenciaDisparo);
		}

        public void AtualizarVisitas(OcorrenciaDisparoInfo ocorrenciaDisparo)
        {
            data.AtualizarVisitas(ocorrenciaDisparo);
        }

        public void PreencherDetalhes(OcorrenciaDisparoInfo ocorrenciaDisparo)
        {
            var homolog = new HomologacaoInfo();
            try
            {
                // TODO
                // homolog.Habilitada = bool.Parse(ConfigurationManager.AppSettings["HomologMode"]);
                // homolog.Email = ConfigurationManager.AppSettings["HomologEmail"];
            }
            catch
            {
                homolog.Habilitada = false;
            }

            data.PreencherDetalhes(ocorrenciaDisparo, homolog);
        }
	}
}
