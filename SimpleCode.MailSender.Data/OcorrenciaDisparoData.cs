using Dapper;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;

namespace SimpleCode.MailSender.Data
{
    public class OcorrenciaDisparoData : DataBase
	{		
	    private AnexoData anexoData;

		public OcorrenciaDisparoData(IDataConfig config) : base(config)
		{			
            anexoData = new AnexoData(config);
		}

		public Queue<OcorrenciaDisparoInfo> Listar(int quantidade)
		{
            IList<OcorrenciaDisparoInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<OcorrenciaDisparoInfo>("email.OcorrenciaDisparoListar", new { DataAtual = DateTime.Now, QuantidadeLinhasSolicitadas = quantidade }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            var fila = new Queue<OcorrenciaDisparoInfo>();

            foreach (var item in lista)
            {
                fila.Enqueue(item);
            }

            return fila;
		}

        public IList<OcorrenciaDisparoInfo> ListarPorDisparo(int codigoDisparo)
        {
            IList<OcorrenciaDisparoInfo> lista;

            using (var conn = GetSqlConnection())
            {
                lista = conn.Query<OcorrenciaDisparoInfo>("email.OcorrenciaDisparoListarPorDisparo", new { CodigoDisparo = codigoDisparo }, commandType: CommandType.StoredProcedure).ToList();
                conn.Close();
            }

            return lista;
        }        
        
        public OcorrenciaDisparoInfo Consultar(int codigoDisparo, int codigoContato)
        {
            OcorrenciaDisparoInfo info;

            using (var conn = GetSqlConnection())
            {
                info = conn.Query<OcorrenciaDisparoInfo>("email.OcorrenciaDisparoListarPorDisparo", new { CodigoDisparo = codigoDisparo, CodigoContato = codigoContato }, commandType: CommandType.StoredProcedure).FirstOrDefault();
                conn.Close();
            }

            return info;
        }

		public void Inserir(OcorrenciaDisparoInfo ocorrenciaDisparo)
		{
            using (var conn = GetSqlConnection())
            {
                conn.Execute("email.OcorrenciaDisparoInserir", ocorrenciaDisparo, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

        public void InserirSnapshot(OcorrenciaDisparoInfo ocorrenciaDisparo)
        {
            using (var conn = GetSqlConnection())
            {
                var codigo = int.MinValue;
                var parameters = new DynamicParameters();
                parameters.Add("Codigo", codigo, direction: ParameterDirection.Output);
                parameters.Add("Criacao", DateTime.Now);
                parameters.Add("CodigoDisparo", ocorrenciaDisparo.CodigoDisparo);
                parameters.Add("CodigoContato", ocorrenciaDisparo.CodigoContato);
                parameters.Add("Assunto", ocorrenciaDisparo.Subject);
                parameters.Add("HTML", ocorrenciaDisparo.Body);
                conn.Execute("email.SnapshotDisparoInserir", parameters, commandType: CommandType.StoredProcedure);                
                conn.Close();
            }
        }

        public void AtualizarEnvio(OcorrenciaDisparoInfo ocorrenciaDisparo)
		{
            using (var conn = GetSqlConnection())
            {
                var parameters = new DynamicParameters();                
                parameters.Add("CodigoDisparo", ocorrenciaDisparo.CodigoDisparo);
                parameters.Add("CodigoContato", ocorrenciaDisparo.CodigoContato);
                parameters.Add("Enviado", ocorrenciaDisparo.Enviado);
                parameters.Add("CodigoStatusDisparo", ocorrenciaDisparo.StatusDisparo);
                parameters.Add("UltimaAlteracao", ocorrenciaDisparo.UltimaAlteracao);
                parameters.Add("Tentativas", ocorrenciaDisparo.Tentativas);
                conn.Execute("email.OcorrenciaDisparoAtualizarEnvio", parameters, commandType: CommandType.StoredProcedure);
                conn.Close();
            }
		}

        public void PreencherDetalhes(OcorrenciaDisparoInfo ocorrenciaDisparo, HomologacaoInfo homolog)
        {            
            using (var conn = GetSqlConnection())
            {
                var command = new SqlCommand("email.OcorrenciaDisparoBuscarDetalhes", (SqlConnection) conn);
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("CodigoDisparo", ocorrenciaDisparo.CodigoDisparo);
                command.Parameters.AddWithValue("CodigoContato", ocorrenciaDisparo.CodigoContato);
                conn.Open();

                using (var reader = command.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        if (homolog.Habilitada && !string.IsNullOrEmpty(homolog.Email))
                            ocorrenciaDisparo.To.Add(new MailAddress(homolog.Email, reader["NomeDestinatario"].ToString()));
                        else
                            ocorrenciaDisparo.To.Add(new MailAddress(reader["EmailDestinatario"].ToString(),
                                reader["NomeDestinatario"].ToString()));

                        ocorrenciaDisparo.From = new MailAddress(reader["EmailRemetente"].ToString(), reader["NomeRemetente"].ToString());
                        ocorrenciaDisparo.Subject = reader["Assunto"].ToString();
                        ocorrenciaDisparo.Body = reader["HTML"].ToString();
                        ocorrenciaDisparo.Mensagem.Codigo = Convert.ToInt32(reader["CodigoMensagem"]);
                        ocorrenciaDisparo.Mensagem.Campanha.Codigo = Util.ToInt32(reader["CodigoCampanha"]);
                        ocorrenciaDisparo.Mensagem.Campanha.Nome = Util.ToString(reader["NomeCampanha"]);
                    }

                    reader.NextResult();

                    while (reader.Read() && !homolog.Habilitada)
                    {
                        ocorrenciaDisparo.CC.Add(new MailAddress(Util.ToString(reader["Email"]), Util.ToString(reader["Nome"])));
                    }

                    reader.Close();
                }

                conn.Close();
            }
        }		
	}
}