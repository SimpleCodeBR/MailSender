using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class LinkParametroRastreamentoData : DataBase
	{
		public LinkParametroRastreamentoData(IDataConfig config) : base(config)
		{			
		}

		public IList<LinkParametroRastreamentoInfo> Consultar(int codigoLink)
		{
			IList<LinkParametroRastreamentoInfo> parametros;

			using (var conn = GetSqlConnection())
            {
				parametros = conn.Query<LinkParametroRastreamentoInfo>("email.LinkParametroRastreamentoConsultar", new { CodigoLink = codigoLink }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return parametros;
		}

		public void Inserir(LinkParametroRastreamentoInfo linkParametroRastreamento)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.LinkParametroRastreamentoInserir", linkParametroRastreamento, commandType: CommandType.StoredProcedure);
				conn.Close();
            }
		}

        public void Excluir(int codigoLink)
        {
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.LinkParametroRastreamentoExcluir", new { CodigoLink = codigoLink }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
        }
	}
}
