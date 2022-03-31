using SimpleCode.MailSender.Business;
using SimpleCode.MailSender.Data;

namespace SimpleCode.MailSender.WorkerService
{
    public class Sender
    {        
        private MessagePool pool;
        private IDataConfig config;

        public int Interval { get; set; }

        public Sender(IDataConfig config)
        {            
            this.config = config;
            this.Interval = this.config.Intervalo;
            pool = new MessagePool(config);            
        }        

        public void Send()
        {            
            pool.Send(config.QuantidadeEmails);            
        }        
    }
}
