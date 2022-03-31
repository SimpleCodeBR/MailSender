using System.Reflection;
using SimpleCode.MailSender.WorkerService;

IHost host = Host.CreateDefaultBuilder(args)
    .ConfigureServices(services =>
    {
        var sender = new Sender(ConfigHelper.GetConfig(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)));

        services.AddSingleton(sender);

        services.AddHostedService<Worker>();        
    })
    .Build();

await host.RunAsync();
