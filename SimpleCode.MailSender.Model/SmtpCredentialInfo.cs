using System;

namespace SimpleCode.MailSender.Model
{
    [Serializable]
    public class SmtpCredentialInfo
    {
        public string User
        { get; set; }

        public string Password
        { get; set; }

        public bool EnableSsl
        { get; set; }

        public string Server
        { get; set; }

        public int Port
        { get; set; }
    }
}