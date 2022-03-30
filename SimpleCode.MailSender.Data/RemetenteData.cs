using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class RemetenteData : DataBase
	{
		public RemetenteData(IDataConfig config) : base(config)
		{			
		}

		public IList<RemetenteInfo> Listar(int codigoAmbiente)
		{
			IList<RemetenteInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<RemetenteInfo>("email.RemetenteListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}

		public RemetenteInfo Consultar(int codigo)
		{
			RemetenteInfo remetente;

			using (var conn = GetSqlConnection())
            {
				remetente = conn.Query<RemetenteInfo>("email.RemetenteConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
            }

			return remetente;
		}

		public void Inserir(RemetenteInfo remetente)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", remetente.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(remetente);
				conn.Execute("email.RemetenteInserir", parameters, commandType: CommandType.StoredProcedure);
				remetente.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(RemetenteInfo remetente)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.RemetenteAtualizar", remetente, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.RemetenteExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}		
	}
}