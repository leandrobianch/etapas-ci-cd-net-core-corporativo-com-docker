using System.Linq;
using docker_deploy_artifacts.Repository;
using Microsoft.AspNetCore.Mvc;

namespace docker_deploy_artifacts.Controllers
{
    public class ClienteController : Controller
    {
        private readonly IClienteRepository _clienteRepository;
        public ClienteController(IClienteRepository clienteRepository)
        {
            _clienteRepository = clienteRepository;
        }

        public ActionResult Index()
        {
            var clientes = _clienteRepository.ObterClientes().ToList();

            clientes.ForEach(c => c.CalcularIdade());

            return View(clientes);
        }
    }
}