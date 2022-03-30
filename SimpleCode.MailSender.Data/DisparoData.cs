using Dapper;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class DisparoData : DataBase
	{
		private IDataConfig _config;

		public DisparoData(IDataConfig config) : base(config)
		{			
			_config = config;
		}

		public IList<DisparoInfo> Listar(int codigoAmbiente, bool carregarMensagem)
		{
			IList<DisparoInfo> lista;

			using (var conn = GetSqlConnection())
            {
				lista = conn.Query<DisparoInfo>("email.DisparoListar", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			if (carregarMensagem)
            {
				var mensagemData = new MensagemData(_config);
				foreach (var item in lista)
                {
					item.Mensagem = mensagemData.Consultar(item.CodigoMensagem);
				}
            }

			return lista;
		}

        public IList<DisparoInfo> ListarPorMensagem(int codigoMensagem)
        {
			IList<DisparoInfo> lista;

			using (var conn = GetSqlConnection())
			{
				lista = conn.Query<DisparoInfo>("email.DisparoListarPorMensagem", new { codigoMensagem = codigoMensagem }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
			}

			return lista;
        }

		public DisparoInfo Consultar(int codigo)
		{
			DisparoInfo disparo;

			using (var conn = GetSqlConnection())
			{
				disparo = conn.Query<DisparoInfo>("email.DisparoConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			return disparo ?? new DisparoInfo();
		}

		public void Inserir(DisparoInfo disparo)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", disparo.Codigo, direction: ParameterDirection.Output);
				parameters.Add("CodigoMensagem", disparo.CodigoMensagem);				
				parameters.Add("Ativo", disparo.Ativo);
				parameters.Add("Criacao", disparo.Criacao);
				parameters.Add("CodigoRemetente", disparo.CodigoRemetente);
				parameters.Add("CodigoStatusDisparo", disparo.StatusDisparo);
				parameters.Add("CodigoAmbiente", disparo.CodigoAmbiente);
				conn.Execute("email.DisparoInserir", parameters, commandType: CommandType.StoredProcedure);
				disparo.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(DisparoInfo disparo)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.DisparoAtualizar", disparo, commandType: CommandType.StoredProcedure);
				conn.Close();
            }
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.DisparoExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

        public void InserirDestinatario(int codigoDisparo, int? codigoGrupo, int? codigoContato)
        {
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.DestinatarioInserir", new { CodigoDisparo = codigoDisparo, CodigoGrupo = codigoGrupo, CodigoContato = codigoContato, Inclusao = DateTime.Now }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
        }

        public void InserirDestinatarioCopia(int codigoDisparo, int codigoContato)
        {
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.DestinatarioCopiaInserir", new { CodigoDisparo = codigoDisparo, CodigoContato = codigoContato, Inclusao = DateTime.Now }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
        }

        public void GerarOcorrencias(int codigoDisparo)
        {
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.OcorrenciaDisparoGerar", new { CodigoDisparo = codigoDisparo, DataAtual = DateTime.Now }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
        }
	}
}