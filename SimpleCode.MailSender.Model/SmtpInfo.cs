using System;
using System.Net;
using System.Net.Mail;

namespace SimpleCode.MailSender.Model
{
    [Serializable]
    public class SmtpInfo : SmtpClient
    {
        public SmtpInfo(SmtpCredentialInfo credential)
        {
            this.User = credential.User;
            this.Password = credential.Password;
            base.EnableSsl = credential.EnableSsl;
            base.Host = credential.Server;
            base.Port = credential.Port;

            base.Credentials = new NetworkCredential(User, Password);
        }

        public string User
        { get; set; }

        public string Password
        { get; set; }
    }
}