using System;

namespace SimpleCode.MailSender.Model 
{
	[Serializable]
	public class VariavelValorGlobalInfo
	{
		public VariavelValorGlobalInfo() { }

		public int Codigo { get; set; }

		public int CodigoAmbiente { get; set; }

		public string Chave { get; set; }

		public string Valor { get; set; }
	}
}