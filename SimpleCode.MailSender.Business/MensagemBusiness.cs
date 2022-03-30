using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class MensagemBusiness
	{
		private MensagemData data;

		public MensagemBusiness(IDataConfig config)
		{
			data = new MensagemData(config);
		}

		public IList<MensagemInfo> Listar()
		{
			return data.Listar();
		}

        public IList<MensagemInfo> Listar(int codigoAmbiente)
        {
            return data.Listar(codigoAmbiente);
        }

		public MensagemInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(MensagemInfo mensagem)
		{
			data.Inserir(mensagem);
		}

		public void Atualizar(MensagemInfo mensagem)
		{
			data.Atualizar(mensagem);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

	}
}
