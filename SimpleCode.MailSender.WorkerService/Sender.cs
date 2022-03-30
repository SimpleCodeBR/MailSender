using SimpleCode.MailSender.Business;
using System.Timers;


namespace SimpleCode.MailSender.WorkerService
{
    internal class Sender
    {
        private System.Timers.Timer timer;
        private MessagePool pool;

        public Sender()
        {
            pool = new MessagePool(new DataConfig());

            SetupTimer();
        }

        private void SetupTimer()
        {
            timer = new System.Timers.Timer()
            {
                Interval = 5000,
                AutoReset = false,
                Enabled = true
            };
            timer.Elapsed += Timer_Elapsed;
            timer.Start();
        }

        private void Send()
        {
            timer.Stop();
            pool.Send(100);
            timer.Start();
        }

        private void Timer_Elapsed(object? sender, ElapsedEventArgs e)
        {
            Send();
        }
    }
}
