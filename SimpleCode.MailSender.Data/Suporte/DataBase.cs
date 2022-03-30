using System.Data;
using System.Data.SqlClient;

namespace SimpleCode.MailSender.Data
{
	public abstract class DataBase
	{
		private string connectionString; 
		public DataBase(IDataConfig config)
		{
			this.connectionString = config.SqlConnectionString;
		}

		public IDbConnection GetSqlConnection()
		{
			return new SqlConnection(connectionString);
		}
	}
}
