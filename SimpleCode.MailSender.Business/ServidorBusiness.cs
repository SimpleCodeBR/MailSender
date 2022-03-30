using System;
using System.Collections.Generic;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
	public class ServidorBusiness
	{
		private IDataConfig config;
		private ServidorData data;

		public ServidorBusiness(IDataConfig config)
		{
			data = new ServidorData(config);
			this.config = config;
		}

		public IList<ServidorInfo> Listar(int codigoAmbiente)
		{
			return data.Listar(codigoAmbiente);
		}

        public Dictionary<int, LinkedListNode<SmtpCredentialInfo>> ListarCredenciais()
        {
            Dictionary<int, LinkedListNode<SmtpCredentialInfo>> itens = new Dictionary<int, LinkedListNode<SmtpCredentialInfo>>();
            IList<AmbienteInfo> ambientes = new AmbienteBusiness(config).Listar();

            foreach (var ambiente in ambientes)
            {
                LinkedList<SmtpCredentialInfo> credenciais = data.ListarCredenciais(ambiente.Codigo);

                itens.Add(ambiente.Codigo, credenciais.First);
            }

            return itens;
        }

		public ServidorInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(ServidorInfo servidor)
		{
			data.Inserir(servidor);
		}

		public void Atualizar(ServidorInfo servidor)
		{
			data.Atualizar(servidor);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

	}
}
