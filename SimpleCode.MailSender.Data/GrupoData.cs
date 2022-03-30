using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class GrupoData : DataBase
	{
		public GrupoData(IDataConfig config) : base(config)
		{
		}

		public IList<GrupoInfo> Listar()
		{
            IList<GrupoInfo> grupoLista;

            using (var conn = GetSqlConnection())
            {
                grupoLista = conn.Query<GrupoInfo>("email.GrupoListar", commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return grupoLista;
		}

		public GrupoInfo Consultar(int codigo)
		{
            GrupoInfo grupo;

            using (var conn = GetSqlConnection())
            {
                grupo = conn.Query<GrupoInfo>("email.GrupoConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
                conn.Close();
            }

            return grupo ?? new GrupoInfo();
		}

		public void Inserir(GrupoInfo grupo)
		{
            using (var conn = GetSqlConnection())
            {
                var parameters = new DynamicParameters();
                parameters.Add("Codigo", grupo.Codigo, direction: ParameterDirection.Output);
                parameters.AddDynamicParams(grupo);
                conn.Execute("email.GrupoInserir", parameters, commandType: CommandType.StoredProcedure);
                grupo.Codigo = parameters.Get<int>("Codigo");
                conn.Close();
            }
		}

		public void Atualizar(GrupoInfo grupo)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.GrupoAtualizar", grupo, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

		public void Excluir(int codigo)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.GrupoExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

        public IList<GrupoInfo> ListarPorCampanha(int codigoCampanha)
        {
            IList<GrupoInfo> grupoLista;

            using (var conn = GetSqlConnection())
            {
                grupoLista = conn.Query<GrupoInfo>("email.GrupoListarPorCampanha", new { CodigoCampanha = codigoCampanha }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return grupoLista;
        }

        public IList<GrupoInfo> ListarPorAmbiente(int codigoAmbiente)
        {
            IList<GrupoInfo> grupoLista;

            using (var conn = GetSqlConnection())
            {
                grupoLista = conn.Query<GrupoInfo>("email.GrupoListarPorAmbiente", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return grupoLista;
        }

        public IList<GrupoInfo> ListarPorContato(int codigoContato)
        {
            IList<GrupoInfo> grupoLista;

            using (var conn = GetSqlConnection())
            {
                grupoLista = conn.Query<GrupoInfo>("email.GrupoListarPorContato", new { CodigoContato = codigoContato }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return grupoLista;
        }

        public void AssociarCampanha(int codigoCampanha, int codigoGrupo)
        {
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.CampanhaGrupoInserir", new { CodigoCampanha = codigoCampanha, CodigoGrupo = codigoGrupo }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }

        public void RemoverCampanha(int codigoCampanha, int codigoGrupo)
        {
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.CampanhaGrupoExcluir", new { CodigoCampanha = codigoCampanha, CodigoGrupo = codigoGrupo }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }		
	}
}