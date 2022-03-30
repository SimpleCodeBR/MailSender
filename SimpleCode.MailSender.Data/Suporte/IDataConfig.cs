namespace SimpleCode.MailSender.Data
{
	public interface IDataConfig
	{
		string SqlConnectionString { get; set; }

		bool HomologMode { get; set; }

		string HomologEmail { get; set; }

		int Threadings { get; set; }

		int QuantidadeEmails { get; set; }

		string EmailNaoEnviar { get; set; }
	}
}
