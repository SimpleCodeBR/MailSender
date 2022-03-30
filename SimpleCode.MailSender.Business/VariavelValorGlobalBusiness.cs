using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;

namespace SimpleCode.MailSender.Business
{
    public class VariavelValorGlobalBusiness
	{
		private VariavelValorGlobalDados dados;

		public VariavelValorGlobalBusiness(IDataConfig config)
		{
			dados = new VariavelValorGlobalDados(config);
		}

		public void Inserir(VariavelValorGlobalInfo variavelValorGlobal)
		{
			dados.Inserir(variavelValorGlobal);
		}

		public void Atualizar(VariavelValorGlobalInfo variavelValorGlobal)
		{
			dados.Atualizar(variavelValorGlobal);
		}

		public IList<VariavelValorGlobalInfo> Listar(int codigoAmbiente)
		{
			return dados.Listar(codigoAmbiente);
		}

		public void Excluir(int codigo)
		{
			dados.Excluir(codigo);
		}
	}
}