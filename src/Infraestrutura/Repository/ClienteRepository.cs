using System.Collections.Generic;
using System.Linq;
using docker_deploy_artifacts.Infraestrutura.Data;
using docker_deploy_artifacts.Models;
using docker_deploy_artifacts.Repository;

namespace docker_deploy_artifacts.Infraestrutura.Repository
{
    public class ClienteRepository : IClienteRepository
    {
        private readonly ContextoBancoDeDados _contextoBancoDeDados;
        public ClienteRepository(ContextoBancoDeDados contextoBancoDeDados)
        {
            _contextoBancoDeDados = contextoBancoDeDados;
        }

        public IList<Cliente> ObterClientes()
        {
            return _contextoBancoDeDados.Cliente.ToList();
        }
    }
}