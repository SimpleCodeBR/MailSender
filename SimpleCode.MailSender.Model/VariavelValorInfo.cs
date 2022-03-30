using System;

namespace SimpleCode.MailSender.Model
{
    [Serializable]
    public class VariavelValorInfo
    {
        public int CodigoVariavel
        { get; set; }

        public int CodigoContato
        { get; set; }

        public int CodigoDisparo
        { get; set; }

        public string Valor
        { get; set; }

        public DateTime Atualizacao
        { get; set; }
    }
}
