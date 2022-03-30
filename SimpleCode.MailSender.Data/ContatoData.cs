using Dapper;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class ContatoData : DataBase
	{
		public ContatoData(IDataConfig config) : base(config)
		{			
		}

		public IList<ContatoInfo> Listar(int codigoAmbiente)
		{
            IList<ContatoInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<ContatoInfo>("email.ContatoListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return lista;
		}

        public IList<ContatoInfo> Buscar(int codigoAmbiente, bool ativo, string nome, string apelido, string email)
        {
            bool? somenteAtivos;
            if(ativo)
                somenteAtivos = true;
            else
                somenteAtivos = null;            
            
            nome = string.IsNullOrEmpty(nome) ? "\"\"" : string.Concat("\"", nome.Trim(),"\"");
            email = string.IsNullOrEmpty(email) ? "\"\"" : string.Concat("\"", email.Trim(), "\"");
            apelido = string.IsNullOrEmpty(apelido) ? "\"\"" : string.Concat("\"", apelido.Trim(), "\"");

            IList<ContatoInfo> lista;
            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<ContatoInfo>("email.ContatoBuscar", new { nome = nome, email = email, apelido = apelido, ativo = somenteAtivos, codigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
            }
            return lista;
        } 

		public ContatoInfo Consultar(int codigo)
		{
            ContatoInfo contato;

            using (var conn = GetSqlConnection())
            {
                contato = conn.Query<ContatoInfo>("email.ContatoConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
                conn.Close();
            }

            return contato ?? new ContatoInfo();
		}

		public void Inserir(ContatoInfo contato)
		{
            using (var conn = GetSqlConnection())
            {
                var parameters = new DynamicParameters();
                parameters.Add("Codigo", contato.Codigo, direction: ParameterDirection.Output);
                parameters.AddDynamicParams(contato);
                conn.Execute("email.ContatoInserir", parameters, commandType: CommandType.StoredProcedure);
                contato.Codigo = parameters.Get<int>("Codigo");
                conn.Close();
            }
		}

		public void Atualizar(ContatoInfo contato)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.ContatoAtualizar", contato, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

		public void Excluir(int codigo)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.ContatoExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

        public IList<ContatoInfo> ListarPorGrupo(int codigoGrupo)
        {
            IList<ContatoInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<ContatoInfo>("email.ContatoListarPorGrupo", new { CodigoGrupo = codigoGrupo }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return lista;
        }

        public void AssociarGrupo(int codigoGrupo, int codigoContato)
        {
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.GrupoContatoInserir", new { CodigoGrupo = codigoGrupo, CodigoContato = codigoContato }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }

        public void RemoverGrupo(int codigoGrupo, int codigoContato)
        {
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.GrupoContatoExcluir", new { CodigoGrupo = codigoGrupo, CodigoContato = codigoContato }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }

        public void CancelarRecebimento(int codigoContato, int codigoCampanha)
        {
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.ContatoRemocaoInserir", new { CodigoContato = codigoContato, CodigoCampanha = codigoCampanha, Remocao = DateTime.Now }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }

        public DateTime VerificarCancelamento(int codigoContato, int codigoCampanha)
        {
            DateTime remocao;

            using (var conn = GetSqlConnection())
            {
                remocao = conn.Query<DateTime>("email.ContatoRemocaoListar", new { CodigoContato = codigoContato, CodigoCampanha = codigoCampanha }, commandType: CommandType.StoredProcedure).FirstOrDefault();
                conn.Close();
            }

            return remocao;
        }
	}
}