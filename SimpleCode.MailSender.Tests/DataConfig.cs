using SimpleCode.MailSender.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SimpleCode.MailSender.Tests
{
    public class DataConfig : IDataConfig
    {
        public string SqlConnectionString { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
    }
}
