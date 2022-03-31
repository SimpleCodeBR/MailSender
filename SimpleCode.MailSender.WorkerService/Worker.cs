namespace SimpleCode.MailSender.WorkerService
{
    public class Worker : BackgroundService
    {
        private readonly ILogger<Worker> _logger;
        private readonly Sender _sender;

        public Worker(ILogger<Worker> logger, Sender sender)
        {
            _logger = logger;
            _sender = sender;
        }        

        protected override async Task ExecuteAsync(CancellationToken stoppingToken)
        {
            while (!stoppingToken.IsCancellationRequested)
            {
                _logger.LogInformation("Worker running at: {time}", DateTimeOffset.Now);

                _sender.Send();

                await Task.Delay(_sender.Interval, stoppingToken);
            }
        }
    }
}