using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;

namespace SimpleCode.MailSender.Business
{
    public static class AlertaDataExtension
    {
        public static IDataConfig config { get; set; }
        
        public static void Salvar(this AlertaInfo alerta)
        {
            try
            {
                new AlertaData(config).Inserir(alerta);
            }
            catch (Exception)
            {

            }
        }
    }
}