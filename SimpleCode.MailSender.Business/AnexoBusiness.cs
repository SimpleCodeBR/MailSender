using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class AnexoBusiness
	{
		private AnexoData dados;

		public AnexoBusiness(IDataConfig config)
		{
		    dados = new AnexoData(config);
		}

		public void Inserir(AnexoInfo anexo)
		{
			dados.Inserir(anexo);
		}

		public void Atualizar(AnexoInfo anexo)
		{
			dados.Atualizar(anexo);
		}

        public IList<AnexoInfo> Listar(int codigoDisparo, int codigoContato)
		{
			return dados.Listar(codigoDisparo, codigoContato);
		}

		public AnexoInfo Consultar(int codigo)
		{
			return dados.Consultar(codigo);
		}

		public void Excluir(int codigo)
		{
			dados.Excluir(codigo);
		}
	}
}