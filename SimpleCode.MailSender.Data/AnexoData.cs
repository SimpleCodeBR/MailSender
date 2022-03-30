using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class AnexoData : DataBase
	{
		public AnexoData(IDataConfig config) : base(config)
		{			
		}

		public void Inserir(AnexoInfo anexo)
		{
			using (IDbConnection conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", anexo.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(anexo);
				conn.Execute("email.AnexoInserir", parameters, commandType: CommandType.StoredProcedure);
				anexo.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(AnexoInfo anexo)
		{
			using (IDbConnection conn = GetSqlConnection())
            {
				conn.Execute("email.AnexoAtualizar", anexo, commandType: CommandType.StoredProcedure);
				conn.Close();
            }
		}

		public IList<AnexoInfo> Listar(int codigoDisparo, int codigoContato)
		{
			IList<AnexoInfo> list;

			using (IDbConnection conn = GetSqlConnection())
            {
				list = conn.Query<AnexoInfo>("email.AnexoListar", new { CodigoDisparo = codigoDisparo, CodigoContato = codigoContato }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
			}

			return list;
		}

		public AnexoInfo Consultar(int codigo)
		{
			AnexoInfo anexo;

			using (IDbConnection conn = GetSqlConnection())
			{
				anexo = conn.Query<AnexoInfo>("email.AnexoConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			return anexo ?? new AnexoInfo();
		}

		public void Excluir(int codigo)
		{
			using (IDbConnection conn = GetSqlConnection())
			{
				conn.Execute("email.AnexoExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}