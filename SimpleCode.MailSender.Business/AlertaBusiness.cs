using System;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;

namespace SimpleCode.MailSender.Business
{
	public class AlertaBusiness
	{
		private AlertaData data;

		public AlertaBusiness(IDataConfig config)
		{
			data = new AlertaData(config);
		}

		public void Inserir(AlertaInfo alerta)
		{
			alerta.Criacao = DateTime.Now;
			data.Inserir(alerta);
		}
	}
}

