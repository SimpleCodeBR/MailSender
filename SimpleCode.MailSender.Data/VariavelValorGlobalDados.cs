using System;
using System.Collections.Generic;
using System.Data;
using SimpleCode.MailSender.Model;
using Dapper;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
	public class VariavelValorGlobalDados : DataBase
	{
		public VariavelValorGlobalDados(IDataConfig config) : base(config)
		{
		}

		public void Inserir(VariavelValorGlobalInfo variavelValorGlobal)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", variavelValorGlobal.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(variavelValorGlobal);
				conn.Execute("email.VariavelValorGlobalInserir", parameters, commandType: CommandType.StoredProcedure);
				variavelValorGlobal.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(VariavelValorGlobalInfo variavelValorGlobal)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.VariavelValorGlobalAtualizar", variavelValorGlobal, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public IList<VariavelValorGlobalInfo> Listar(int codigoAmbiente)
		{
			IList<VariavelValorGlobalInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<VariavelValorGlobalInfo>("email.VariavelValorGlobalListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.VariavelValorGlobalExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}