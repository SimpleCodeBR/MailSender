using SimpleCode.MailSender.Data;

namespace SimpleCode.MailSender.Business
{
    public class DataConfig : IDataConfig
    {
        public string? SqlConnectionString { get; set; }

        public bool HomologMode { get; set; }

        public string? HomologEmail { get; set; }

        public int Threadings { get; set; }

        public string? EmailNaoEnviar { get; set; }

        public int QuantidadeEmails { get; set; }

        public int Intervalo { get; set; }
    }
}
