using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Text;

namespace SimpleCode.MailSender.Model
{
	[Serializable]
	public class OcorrenciaDisparoInfo : MailMessage
	{
		public OcorrenciaDisparoInfo()
		{
		    this.Mensagem = new MensagemInfo();
            this.Anexos = new List<AnexoInfo>();
		}

		public int CodigoDisparo
		{ get; set; }

		public int CodigoContato
		{ get; set; }

        public int CodigoAmbiente
        { get; set; }

        public MensagemInfo Mensagem
        { get; set; }

		public bool Enviado
		{ get; set; }

		public StatusDisparo StatusDisparo
		{ get; set; }

		public DateTime Criacao
		{ get; set; }

		public DateTime UltimaAlteracao
		{ get; set; }

		public int Visitas
		{ get; set; }

		public DateTime PrimeiraVisita
		{ get; set; }

		public int Tentativas
		{ get; set; }

        public SmtpInfo Smtp
        { get; set; }

        public IList<AnexoInfo> Anexos
        { get; set; }

        new public Encoding BodyEncoding
        {
            get
            {
                return Encoding.UTF8;
            }
        }

        new public Encoding SubjectEncoding
        {
            get
            {
                return Encoding.UTF8;
            }
        }

        public void Send()
        {
            try
            {
                base.Sender = new MailAddress(Smtp.User);
                Smtp.Send(this);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
	}
}
