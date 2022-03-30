using System;

namespace SimpleCode.MailSender.Model
{
	[Serializable]
	public class AlertaInfo
	{
		private Exception ex;

        public AlertaInfo(string causa, TipoAlerta tipo)
        {
            this.Origem = causa;
            this.Tipo = tipo;
        }

        public AlertaInfo(string causa, TipoAlerta tipo, Exception ex)            
        {
            this.Origem = causa;
            this.Tipo = tipo;
			this.ex = ex;
        }

	    public int Codigo
		{ get; set; }

		public DateTime Criacao
		{ get; set; }

		public string Origem
		{ get; set; }

		public int CodigoUsuario
		{ get; set; }

		public string IP
		{ get; set; }
		
		public TipoAlerta Tipo
		{ get; set; }

		public string Descricao
        {
			get
            {
				if (this.ex != null)
					return ex.Message;
				return string.Empty;
            }
        }

		public string Detalhes
        {
			get
            {
				if (this.ex != null)
					return ex.StackTrace;
				return string.Empty;
            }
        }
	}
}