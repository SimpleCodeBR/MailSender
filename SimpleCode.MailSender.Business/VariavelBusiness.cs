using SimpleCode.MailSender.Data;
using SimpleCode.MailSender.Model;
using System;
using System.Collections.Generic;
using System.Transactions;

namespace SimpleCode.MailSender.Business
{
    public class VariavelBusiness
    {
        private VariavelData data;

        public VariavelBusiness(IDataConfig config)
        {
            data = new VariavelData(config);
        }

        public IList<VariavelInfo> Listar(int codigoDisparo)
        {
            return data.Listar(codigoDisparo);
        }

        public void Inserir(VariavelInfo variavel)
        {
            try
            {
                using (TransactionScope scope = new TransactionScope())
                {
                    data.Inserir(variavel);

                    foreach (VariavelValorInfo valor in variavel.Valores)
                    {
                        valor.CodigoVariavel = variavel.Codigo;
                        Inserir(valor);
                    }

                    scope.Complete();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Excluir(int codigo)
        {
            data.Excluir(codigo);
        }

        private void Inserir(VariavelValorInfo valor)
        {
            data.Inserir(valor);
        }

        public IList<KeyValuePair<string, string>> BuscarValores(int codigoDisparo, int codigoContato)
        {
            return data.BuscarValores(codigoDisparo, codigoContato);
        }
    }
}