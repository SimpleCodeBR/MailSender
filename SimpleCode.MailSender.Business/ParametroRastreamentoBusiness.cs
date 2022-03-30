using System;
using System.Collections.Generic;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
	public class ParametroRastreamentoBusiness
	{
		private ParametroRastreamentoData data;

		public ParametroRastreamentoBusiness(IDataConfig config)
		{
			data = new ParametroRastreamentoData(config);
		}

		public IList<ParametroRastreamentoInfo> Listar()
		{
			return data.Listar();
		}
	}
}
