using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using docker_deploy_artefacts.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace docker_deploy_artefacts.Controllers {
    public class HomeController : Controller {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _configuration;
        private readonly IHostingEnvironment _env;

        public HomeController (ILogger<HomeController> logger,
            IConfiguration configuration,
            IHostingEnvironment env) {
            _env = env;
            _configuration = configuration;
            _logger = logger;
        }

        public IActionResult Index () {
            ViewData["Ambiente"] = _env.EnvironmentName;
            ViewData["MachineName"] = Environment.MachineName;

            return View ();
        }

        public IActionResult Privacy () {
            return View ();
        }

        [ResponseCache (Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error () {
            return View (new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}