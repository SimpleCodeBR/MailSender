using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class ServidorData : DataBase
	{
		public ServidorData(IDataConfig config) : base(config)
		{			
		}

		public IList<ServidorInfo> Listar(int codigoAmbiente)
		{
			IList<ServidorInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<ServidorInfo>("email.ServidorListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return lista;
		}

        public LinkedList<SmtpCredentialInfo> ListarCredenciais(int codigoAmbiente)
        {
			var lista = new LinkedList<SmtpCredentialInfo>();

			using (var conn = GetSqlConnection())
            {
				var command = new SqlCommand("email.ServidorListarCredenciais", (SqlConnection) conn);
				command.CommandType = CommandType.StoredProcedure;
				command.Parameters.AddWithValue("CodigoAmbiente", codigoAmbiente);

				using (IDataReader reader = command.ExecuteReader())
				{
					while (reader.Read())
					{
                        var credencial = new SmtpCredentialInfo
                        {
                            EnableSsl = Util.ToBoolean(reader["SSL"]),
                            Password = Util.ToString(reader["Senha"]),
                            Port = Util.ToInt32(reader["Porta"]),
                            Server = Util.ToString(reader["Endereco"]),
                            User = Util.ToString(reader["Usuario"])
                        };

                        var node = new LinkedListNode<SmtpCredentialInfo>(credencial);
						lista.AddLast(node);
					}
					reader.Close();
				}

				conn.Close();
			}

            return lista;
        }

		public ServidorInfo Consultar(int codigo)
		{
			ServidorInfo servidor;

			using (var conn = GetSqlConnection())
            {
				servidor = conn.QueryFirstOrDefault<ServidorInfo>("email.ServidorConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
            }
			
			return servidor ?? new ServidorInfo();
		}

		public void Inserir(ServidorInfo servidor)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", servidor.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(servidor);
				conn.Execute("email.ServidorInserir", parameters, commandType: CommandType.StoredProcedure);
				servidor.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(ServidorInfo servidor)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.ServidorAtualizar", servidor, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.ServidorExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}
