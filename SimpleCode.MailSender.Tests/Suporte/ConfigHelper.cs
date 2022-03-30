using System;
using Microsoft.Extensions.Configuration;
using SimpleCode.MailSender.Business;
using SimpleCode.MailSender.Data;

namespace SimpleCode.MailSender.Tests
{
	public static class ConfigHelper
	{
        public static IConfigurationRoot GetIConfigurationRoot(string outputPath)
        {
            return new ConfigurationBuilder()
                .SetBasePath(outputPath)
                .AddJsonFile("appsettings.json", optional: true)                
                .Build();
        }

        public static IDataConfig GetConfig(string outputPath)
        {
            var configuration = new DataConfig();

            var iConfig = GetIConfigurationRoot(outputPath);

            iConfig
                .GetSection("CustomConfig")
                .Bind(configuration);

            return configuration;
        }
    }
}

