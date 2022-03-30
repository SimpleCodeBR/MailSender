using Dapper;
using SimpleCode.MailSender.Model;
using System.Data;

namespace SimpleCode.MailSender.Data
{
	public class AlertaData : DataBase
	{
		public AlertaData(IDataConfig config) : base(config)
		{			
		}

		public void Inserir(AlertaInfo alerta)
		{
			using (IDbConnection conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", alerta.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(alerta);
				conn.Execute("email.AlertaInserir", parameters, commandType: CommandType.StoredProcedure);
				alerta.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}
	}
}