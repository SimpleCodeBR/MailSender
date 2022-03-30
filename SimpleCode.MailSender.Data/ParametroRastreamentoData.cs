using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class ParametroRastreamentoData : DataBase
	{
		public ParametroRastreamentoData(IDataConfig config) : base(config)
		{			
		}

		public IList<ParametroRastreamentoInfo> Listar()
		{
			IList<ParametroRastreamentoInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<ParametroRastreamentoInfo>("email.ParametroRastreamentoListar", commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}
	}
}
