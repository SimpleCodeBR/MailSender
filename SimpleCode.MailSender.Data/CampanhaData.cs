using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class CampanhaData : DataBase
	{
		public CampanhaData(IDataConfig config) : base(config)
		{			
		}

		public IList<CampanhaInfo> Listar(int codigoAmbiente)
		{
			IList<CampanhaInfo> lista;

			using (IDbConnection conn = GetSqlConnection())
            {
				lista = conn.Query<CampanhaInfo>("email.CampanhaListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}

		public CampanhaInfo Consultar(int codigo)
		{
			CampanhaInfo campanha;

			using (IDbConnection conn = GetSqlConnection())
			{
				campanha = conn.Query<CampanhaInfo>("email.CampanhaConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			return campanha ?? new CampanhaInfo();
		}

		public void Inserir(CampanhaInfo campanha)
		{
			using (IDbConnection conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", campanha.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(campanha);
				conn.Execute("email.CampanhaInserir", parameters, commandType: CommandType.StoredProcedure);
				campanha.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(CampanhaInfo campanha)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.CampanhaAtualizar", campanha, commandType: CommandType.StoredProcedure);
				conn.Close();
            }
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.CampanhaExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

        public IList<CampanhaInfo> ListarPorServidor(int codigoServidor)
        {
			IList<CampanhaInfo> lista;

			using (IDbConnection conn = GetSqlConnection())
			{
				lista = conn.Query<CampanhaInfo>("email.CampanhaListarPorServidor", new { CodigoServidor = codigoServidor }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
			}

			return lista;
        }

        public IList<CampanhaInfo> ListarPorRemetente(int codigoRemetente)
        {
			IList<CampanhaInfo> lista;

			using (IDbConnection conn = GetSqlConnection())
			{
				lista = conn.Query<CampanhaInfo>("email.CampanhaListarPorRemetente", new { CodigoRemetente = codigoRemetente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
			}

			return lista;
        }
	}
}
