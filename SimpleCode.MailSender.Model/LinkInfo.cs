using System;
using System.Collections.Generic;

//Auto generated by CodeProvider 3.0
namespace SimpleCode.MailSender.Model
{
	[Serializable]
	public class LinkInfo
	{
		public LinkInfo()
		{
		    ParametrosRastreamento = new List<LinkParametroRastreamentoInfo>();
		}

		public int Codigo
		{ get; set; }

		public int CodigoMensagem
		{ get; set; }

		public string Endereco
		{ get; set; }

        public IList<LinkParametroRastreamentoInfo> ParametrosRastreamento
        { get; set; }
	}
}