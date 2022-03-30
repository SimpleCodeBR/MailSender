using System;

namespace SimpleCode.MailSender.Model
{
    [Serializable]
    public class DestinatarioInfo
    {
        public int Codigo
        { get; set; }

        public int CodigoDisparo
        { get; set; }

        public TipoDestinatario Tipo
        { get; set; }
    }
}
