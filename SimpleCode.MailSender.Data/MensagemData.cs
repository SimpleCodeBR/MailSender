using Dapper;
using SimpleCode.MailSender.Model;
using System.Collections.Generic;
using System.Data;
using System.Linq;

namespace SimpleCode.MailSender.Data
{
    public class MensagemData : DataBase
	{		
	    private VariavelData variavelData;

		public MensagemData(IDataConfig config) : base(config)
		{			
            variavelData = new VariavelData(config);
		}

		public IList<MensagemInfo> Listar()
		{
			IList<MensagemInfo> mensagemLista;

			using (var conn = GetSqlConnection())
            {
				mensagemLista = conn.Query<MensagemInfo>("email.MensagemListar", commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
            }

			return mensagemLista;
		}

        public IList<MensagemInfo> Listar(int codigoAmbiente)
        {
			IList<MensagemInfo> mensagemLista;

			using (var conn = GetSqlConnection())
			{
				mensagemLista = conn.Query<MensagemInfo>("email.MensagemListarPorAmbiente", new { CodigoAmbiente = codigoAmbiente }, commandType: CommandType.StoredProcedure).ToList();
				conn.Close();
			}

			return mensagemLista;
        }

		public MensagemInfo Consultar(int codigo)
		{
			MensagemInfo mensagem;

			using (var conn = GetSqlConnection())
			{
				mensagem = conn.Query<MensagemInfo>("email.MensagemConsultar", new { Codigo = codigo }, commandType: CommandType.StoredProcedure).FirstOrDefault();
				conn.Close();
			}

			mensagem.Variaveis = variavelData.ListarPorMensagem(mensagem.Codigo);

			return mensagem ?? new MensagemInfo();
		}

		public void Inserir(MensagemInfo mensagem)
		{
			using (var conn = GetSqlConnection())
			{
				var parameters = new DynamicParameters();
				parameters.Add("Codigo", mensagem.Codigo, direction: ParameterDirection.Output);
				parameters.AddDynamicParams(mensagem);
				conn.Execute("email.MensagemInserir", parameters, commandType: CommandType.StoredProcedure);
				mensagem.Codigo = parameters.Get<int>("Codigo");
				conn.Close();
			}
		}

		public void Atualizar(MensagemInfo mensagem)
		{
			using (var conn = GetSqlConnection())
            {
				conn.Execute("email.MensagemAtualizar", mensagem, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}

		public void Excluir(int codigo)
		{
			using (var conn = GetSqlConnection())
			{
				conn.Execute("email.MensagemExcluir", new { Codigo = codigo }, commandType: CommandType.StoredProcedure);
				conn.Close();
			}
		}
	}
}
