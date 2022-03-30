using System;

namespace SimpleCode.MailSender.Model
{
	[Serializable]
	public class AnexoInfo
	{
		public AnexoInfo()
		{ }

		public int Codigo
		{ get; set; }

		public int CodigoDisparo
		{ get; set; }

		public int CodigoContato
		{ get; set; }

		public string Arquivo
		{ get; set; }
	}
}