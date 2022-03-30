using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class AmbienteData : DataBase
	{
		public AmbienteData(IDataConfig config) : base(config) 
		{			
		}

		public IList<AmbienteInfo> Listar()
		{
			IList<AmbienteInfo> ambienteLista;

			using (IDbConnection conn = GetSqlConnection())
            {
				ambienteLista = conn.Query<AmbienteInfo>("config.AmbienteListar", commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return ambienteLista;

		}

		public AmbienteInfo Consultar(int codigo)
		{
			AmbienteInfo ambiente;

			using (IDbConnection conn = GetSqlConnection())
			{
				ambiente = conn.Query<AmbienteInfo>("config.AmbienteConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			return ambiente ?? new AmbienteInfo();
		}

		public void Inserir(AmbienteInfo ambiente)
		{
			using (IDbConnection conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", ambiente.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(ambiente);
				conn.Execute("config.AmbienteInserir", parameters, commandType: CommandType.StoredProcedure);
				ambiente.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}		
	}
}
