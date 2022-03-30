using NUnit.Framework;
using SimpleCode.MailSender.Business;
using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;
using System.IO;
using System.Linq;
using System.Reflection;

namespace SimpleCode.MailSender.Tests
{
    public class Tests
    {
        private IDataConfig? config;

        [SetUp]
        public void Setup()
        {
            config = ConfigHelper.GetConfig(Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location));
        }

        [Ignore("Testado")]
        [Test]
        public void CriarAmbientes()
        {
            var simplecode = new AmbienteInfo()
            {
                Apelido = "SimpleCode",
                EmailResponsavel = "vanessaort@gmail.com",
                NomeResponsavel = "Vanessa Ortega"
            };            

            var ambienteBusiness = new AmbienteBusiness(config);

            ambienteBusiness.Inserir(simplecode);
            
            Assert.IsTrue(simplecode.Codigo > 0);
        }

        [Ignore("Testado")]
        [Test]
        public void CriarRemetentes()
        {
            var ambiente = new AmbienteBusiness(config).Listar().FirstOrDefault(a => a.Apelido.Equals("SimpleCode"));
            var remetenteBusiness = new RemetenteBusiness(config);

            if (ambiente != null)
            {
                var remetente = new RemetenteInfo()
                {
                    Apelido = "Teste",
                    CodigoAmbiente = ambiente.Codigo,
                    Email = "smtpprovider@gmail.com",
                    Nome = "Teste",
                    Criacao = DateTime.Now,
                    Padrao = true
                };
                remetenteBusiness.Inserir(remetente);

                Assert.IsTrue(remetenteBusiness.Listar(ambiente.Codigo).Count > 0);
            }            
        }

        [Ignore("Testado")]
        [Test]
        public void CriarServidores()
        {
            var ambiente = new AmbienteBusiness(config).Listar().FirstOrDefault(a => a.Apelido.Equals("SimpleCode"));
            var servidorBusiness = new ServidorBusiness(config);

            if (ambiente != null)
            {
                var servidor = new ServidorInfo()
                {                    
                    Apelido = ambiente.Apelido,
                    CodigoAmbiente = ambiente.Codigo,
                    Endereco = "smtp.gmail.com",
                    Porta = 587,
                    SSL = true,                    
                    Usuario = "smtpprovider@gmail.com",
                    Padrao = true
                };

                servidorBusiness.Inserir(servidor);

                Assert.IsTrue(servidorBusiness.Listar(ambiente.Codigo).Count > 0);
            }            
        }

        [Ignore("Testado")]
        [Test]
        public void CriarGrupos()
        {                           
            var grupoBusiness = new GrupoBusiness(config);
            var ambiente = new AmbienteBusiness(config).Listar().FirstOrDefault(a => a.Apelido.Equals("SimpleCode"));

            if (ambiente != null)
            {
                var grupo = new GrupoInfo()
                {
                    Ativo = true,
                    CodigoAmbiente = ambiente.Codigo,
                    Criacao = DateTime.Now,
                    Nome = ambiente.Apelido
                };
                grupoBusiness.Inserir(grupo);

                Assert.IsTrue(grupoBusiness.ListarPorAmbiente(ambiente.Codigo).Count > 0);
            }            
        }

        [Ignore("Testado")]
        [Test]
        public void CriarContatos()
        {
            var ambiente = new AmbienteBusiness(config).Listar().FirstOrDefault(a => a.Apelido.Equals("SimpleCode"));

            if (ambiente != null)
            {
                var grupo = new GrupoBusiness(config).ListarPorAmbiente(ambiente.Codigo).FirstOrDefault();

                if (grupo != null)
                {
                    var contatoBusiness = new ContatoBusiness(config);

                    ContatoInfo contato = new ContatoInfo()
                    {
                        Apelido = "admin",
                        Ativo = true,
                        CodigoAmbiente = ambiente.Codigo,
                        Criacao = DateTime.Now,
                        Email = "info@simplecode.com.br",
                        Nome = "Administrador"
                    };
                    contatoBusiness.Inserir(contato);
                    contatoBusiness.AssociarGrupo(grupo.Codigo, contato.Codigo);

                    contato = new ContatoInfo()
                    {
                        Apelido = "van",
                        Ativo = true,
                        CodigoAmbiente = ambiente.Codigo,
                        Criacao = DateTime.Now,
                        Email = "vanessaort@gmail.com",
                        Nome = "Vanessa Ortega"
                    };
                    contatoBusiness.Inserir(contato);
                    contatoBusiness.AssociarGrupo(grupo.Codigo, contato.Codigo);

                    contato = new ContatoInfo()
                    {
                        Apelido = "van",
                        Ativo = true,
                        CodigoAmbiente = ambiente.Codigo,
                        Criacao = DateTime.Now,
                        Email = "ortegavan@live.com",
                        Nome = "Vanessa Ortega"
                    };
                    contatoBusiness.Inserir(contato);
                    contatoBusiness.AssociarGrupo(grupo.Codigo, contato.Codigo);

                    contato = new ContatoInfo()
                    {
                        Apelido = "digu",
                        Ativo = true,
                        CodigoAmbiente = ambiente.Codigo,
                        Criacao = DateTime.Now,
                        Email = "rsantoz@gmail.com",
                        Nome = "Rodrigo Lima"
                    };
                    contatoBusiness.Inserir(contato);
                    contatoBusiness.AssociarGrupo(grupo.Codigo, contato.Codigo);

                    Assert.IsTrue(contatoBusiness.Listar(ambiente.Codigo).Count > 0);
                }
            }            
        }

        [Ignore("Testado")]
        [Test]
        public void CriarMensagem()
        {
            var ambiente = new AmbienteBusiness(config).Listar().FirstOrDefault(a => a.Apelido.Equals("SimpleCode"));            

            if (ambiente != null)
            {
                var txt = "Teste do MailSender";
                var mensagemBusiness = new MensagemBusiness(config);
                var mensagem = new MensagemInfo()
                {
                    Assunto = txt,
                    Ativo = true,                    
                    CodigoAmbiente = ambiente.Codigo,
                    Criacao = DateTime.Now,
                    HTML = txt,
                    Nome = txt,
                    Tipo = TipoMensagem.Sistema
                };
                mensagemBusiness.Inserir(mensagem);

                var disparo = new DisparoInfo()
                {
                    Ativo = true,
                    CodigoAmbiente = ambiente.Codigo,
                    CodigoMensagem = mensagem.Codigo,
                    CodigoRemetente = new RemetenteBusiness(config).Listar(ambiente.Codigo).First().Codigo,
                    Criacao = DateTime.Now,
                    StatusDisparo = StatusDisparo.NaoIniciado,
                    Mensagem = mensagem
                };

                var grupo = new GrupoBusiness(config).ListarPorAmbiente(ambiente.Codigo).First();
                                
                var destinatario = new DestinatarioInfo()
                {
                    Codigo = grupo.Codigo,
                    Tipo = TipoDestinatario.Grupo
                };
                disparo.Destinatarios.Add(destinatario);
                new DisparoBusiness(config).Inserir(disparo);

                Assert.IsTrue(mensagemBusiness.Listar(ambiente.Codigo).Count > 0);
            }            
        }

        [Ignore("Testado")]
        [Test]
        public void EnviarMensagens()
        {            
            var pool = new MessagePool(config);
            pool.Send(config.QuantidadeEmails);
        }
    }
}