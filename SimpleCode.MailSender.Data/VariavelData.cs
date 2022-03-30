using Dapper;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class VariavelData : DataBase
	{
		public VariavelData(IDataConfig config) : base(config) 
		{			
		}

		public IList<VariavelInfo> Listar(int codigoDisparo)
		{
            IList<VariavelInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<VariavelInfo>("email.VariavelListar", new { CodigoDisparo = codigoDisparo }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return lista;
		}

        public IList<VariavelInfo> ListarPorMensagem(int codigoMensagem)
        {
            IList<VariavelInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<VariavelInfo>("email.VariavelListarPorMensagem", new { CodigoMensagem = codigoMensagem }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return lista;
        }

		public void Inserir(VariavelInfo variavel)
		{
            using (var conn = GetSqlConnection())
            {
                var parameters = new DynamicParameters();
                parameters.Add("Codigo", variavel.Codigo, direction: ParameterDirection.Output);
                parameters.AddDynamicParams(variavel);
                conn.Execute("email.VariavelInserir", parameters, commandType: CommandType.StoredProcedure);
                variavel.Codigo = parameters.Get<int>("Codigo");
                conn.Close();
            }
		}

		public void Excluir(int codigo)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Query<VariavelInfo>("email.VariavelExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

        public void Inserir(VariavelValorInfo valor)
        {
            valor.Atualizacao = DateTime.Now;

            using (var conn = GetSqlConnection())
            {
                conn.Query<VariavelInfo>("email.VariavelValorInserir", valor, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
        }

        public IList<KeyValuePair<string, string>> BuscarValores(int codigoDisparo, int codigoContato)
        {
            var valores = new List<KeyValuePair<string, string>>();

            using (var conn = GetSqlConnection())
            {
                var command = new SqlCommand("email.VariavelValorListar", (SqlConnection)conn);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("CodigoDisparo", codigoDisparo);
                command.Parameters.AddWithValue("CodigoContato", codigoContato);

                conn.Open();

                using (IDataReader reader = command.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        KeyValuePair<string, string> valor = new KeyValuePair<string, string>(
                            reader["Nome"].ToString(),
                            reader["Valor"].ToString());
                        valores.Add(valor);
                    }
                    reader.Close();
                }

                conn.Close();
            }

            return valores;
        }
	}
}
