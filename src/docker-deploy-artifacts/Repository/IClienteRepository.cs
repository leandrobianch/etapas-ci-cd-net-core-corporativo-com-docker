using System.Collections.Generic;
using docker_deploy_artifacts.Models;

namespace docker_deploy_artifacts.Repository
{
    public interface IClienteRepository
    {
         IList<Cliente> ObterClientes();
    }
}