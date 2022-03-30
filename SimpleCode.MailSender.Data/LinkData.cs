using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class LinkData : DataBase
	{
		public LinkData(IDataConfig config) : base(config)
		{			
		}

		public IList<LinkInfo> Listar(int codigoMensagem)
		{
			IList<LinkInfo> linkLista;

			using (var conn = GetSqlConnection())
            {
				linkLista = conn.Query<LinkInfo>("email.LinkListar", new { CodigoMensagem = codigoMensagem }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return linkLista;
		}

		public LinkInfo Consultar(int codigo)
		{
			LinkInfo link;

			using (var conn = GetSqlConnection())
			{
				link = conn.Query<LinkInfo>("email.LinkListar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			return link;
		}

		public void Inserir(LinkInfo link)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", link.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(link);
				conn.Execute("email.LinkInserir", parameters, commandType: CommandType.StoredProcedure);
				link.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(LinkInfo link)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.LinkAtualizar", link, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.LinkExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}
