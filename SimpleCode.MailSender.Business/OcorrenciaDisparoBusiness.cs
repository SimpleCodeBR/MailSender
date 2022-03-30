using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class OcorrenciaDisparoBusiness
	{
		private OcorrenciaDisparoData data;
        private IDataConfig config;

		public OcorrenciaDisparoBusiness(IDataConfig config)
		{
			this.data = new OcorrenciaDisparoData(config);
            this.config = config;
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

        public void PreencherDetalhes(OcorrenciaDisparoInfo ocorrenciaDisparo)
        {
            var homolog = new HomologacaoInfo();
            try
            {                
                homolog.Habilitada = config.HomologMode;
                homolog.Email = config.HomologEmail;
            }
            catch
            {
                homolog.Habilitada = false;
            }

            data.PreencherDetalhes(ocorrenciaDisparo, homolog);
        }
	}
}
