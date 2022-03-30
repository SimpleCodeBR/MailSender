using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class ContatoBusiness
	{
		private ContatoData data;

		public ContatoBusiness(IDataConfig config)
		{
			data = new ContatoData(config);
		}

		public IList<ContatoInfo> Listar(int codigoAmbiente)
		{
			return data.Listar(codigoAmbiente);
		}

        public IList<ContatoInfo> Buscar(int codigoAmbiente, bool ativo, string nome, string apelido, string email)
        {
            return data.Buscar(codigoAmbiente, ativo, nome, apelido, email);
        }

		public ContatoInfo Consultar(int codigo)
		{
			return data.Consultar(codigo);
		}

		public void Inserir(ContatoInfo contato)
		{
			data.Inserir(contato);
		}

		public void Atualizar(ContatoInfo contato)
		{
			data.Atualizar(contato);
		}

		public void Excluir(int codigo)
		{
			data.Excluir(codigo);
		}

        public IList<ContatoInfo> ListarPorGrupo(int codigoGrupo)
        {
            return data.ListarPorGrupo(codigoGrupo);
        }

        public void AssociarGrupo(int codigoGrupo, int codigoContato)
        {
            data.AssociarGrupo(codigoGrupo, codigoContato);
        }

        public void RemoverGrupo(int codigoGrupo, int codigoContato)
        {
            data.RemoverGrupo(codigoGrupo, codigoContato);
        }

        public void CancelarRecebimento(int codigoContato, int codigoCampanha)
        {
            data.CancelarRecebimento(codigoContato, codigoCampanha);
        }

        public DateTime VerificarCancelamento(int codigoContato, int codigoCampanha)
        {
            return data.VerificarCancelamento(codigoContato, codigoCampanha);
        }
 	}
}