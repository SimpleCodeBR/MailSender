using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class VisitaLinkData : DataBase
	{
		public VisitaLinkData(IDataConfig config) : base(config)
		{
		}

		public IList<VisitaLinkInfo> Listar()
		{
			IList<VisitaLinkInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<VisitaLinkInfo>("email.VisitaLinkListar", commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}

		public VisitaLinkInfo Consultar(int codigoDisparo)
		{
			VisitaLinkInfo visita;

			using (var conn = GetSqlConnection())
			{
				visita = conn.QueryFirstOrDefault<VisitaLinkInfo>("email.VisitaLinkListar", commandType: CommandType.StoredProcedure);
				conn.Close();
			}

			return visita ?? new VisitaLinkInfo();
		}

		public void Inserir(VisitaLinkInfo visitaLink)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.VisitaLinkInserir", visitaLink, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Atualizar(VisitaLinkInfo visitaLink)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.VisitaLinkAtualizar", visitaLink, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Excluir(int codigoDisparo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.VisitaLinkExcluir", new { CodigoDisparo = codigoDisparo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}
