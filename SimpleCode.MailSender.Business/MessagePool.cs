using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Net;
using System.Threading;

namespace SimpleCode.MailSender.Business
{
    public class MessagePool
    {      

        private Queue<OcorrenciaDisparoInfo> Messages
        { get; set; }        

        private Dictionary<int, LinkedListNode<SmtpCredentialInfo>> SmtpServersCredentials2
        { get; set; } 

        private OcorrenciaDisparoBusiness disparoBusiness;

        private IDataConfig config;

        public MessagePool(IDataConfig config)
        {            
            this.config = config;

            LoadCredentialsFromDatabase();

            Messages = new Queue<OcorrenciaDisparoInfo>();
            disparoBusiness = new OcorrenciaDisparoBusiness(this.config);
        }

        public void Send(int quantidade)
        {
            var alertaBusiness = new AlertaBusiness(config);
            try
            {                
                AlertaInfo alerta;                
                
                LoadMessages(quantidade);

                int threadings = config.Threadings;

                ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                
                if (Messages.Count > 0)
                {
                    alerta = new AlertaInfo("Iniciando envio de um lote...", TipoAlerta.Alerta);
                    alertaBusiness.Inserir(alerta);
                    
                    List<ManualResetEvent> resetEvents = new List<ManualResetEvent>();
                    
                    while (Messages.Count > 0)
                    {
                        OcorrenciaDisparoInfo message = Messages.Dequeue();

                        ManualResetEvent resetEvent = new ManualResetEvent(false);
                        Messenger messenger = new Messenger(resetEvent, config);                        
                        
                        message.Smtp = new SmtpInfo(SmtpServersCredentials2[message.CodigoAmbiente].Value);

                        ThreadPool.QueueUserWorkItem(messenger.Send, message);
                        resetEvents.Add(resetEvent);                        
                        
                        SmtpServersCredentials2[message.CodigoAmbiente] =
                            SmtpServersCredentials2[message.CodigoAmbiente].Next ??
                            SmtpServersCredentials2[message.CodigoAmbiente].List.First;
                        
                        if(resetEvents.Count == threadings)
                        {
                            WaitHandle.WaitAll(resetEvents.ToArray());
                            resetEvents = new List<ManualResetEvent>();
                        }
                    }
                    
                    alerta = new AlertaInfo("Envio do lote concluído!", TipoAlerta.Alerta);
                    alertaBusiness.Inserir(alerta);
                }
                else
                {
                    alerta = new AlertaInfo("Não há mensagens pendentes.", TipoAlerta.Alerta);
                    alertaBusiness.Inserir(alerta);
                }
            }
            catch(Exception ex)
            {
                AlertaInfo alerta = new AlertaInfo("Erro genérico ao enviar mensagens", TipoAlerta.Erro, ex);
                alertaBusiness.Inserir(alerta);
            }
        }        

        private void LoadCredentialsFromDatabase()
        {
            SmtpServersCredentials2 = new ServidorBusiness(config).ListarCredenciais();
        }

        private void LoadMessages(int quantidade)
        {
            Messages = disparoBusiness.Listar(quantidade);
        }
    }
}