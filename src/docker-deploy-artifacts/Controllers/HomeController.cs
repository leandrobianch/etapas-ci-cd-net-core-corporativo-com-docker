using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using docker_deploy_artifacts.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace docker_deploy_artifacts.Controllers {
    public class HomeController : Controller {
        private readonly ILogger<HomeController> _logger;
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _env;

        public HomeController (ILogger<HomeController> logger,
            IConfiguration configuration,
            IWebHostEnvironment env) {
            _env = env;
            _configuration = configuration;
            _logger = logger;
        }

        public IActionResult Index () {
            ViewData["Ambiente"] = _env.EnvironmentName;
            ViewData["MachineName"] = Environment.MachineName;
            ViewData["Versao"] = ObterVersion();
            ViewData["DefaultConnection"] = _configuration.GetConnectionString("DefaultConnection");

            return View ();
        }

        public static string ObterVersion()
        {
            AssemblyInformationalVersionAttribute attribute = (AssemblyInformationalVersionAttribute)Assembly.GetExecutingAssembly().GetCustomAttributes(typeof(AssemblyInformationalVersionAttribute), false).FirstOrDefault();

            return attribute?.InformationalVersion;
        }


        public IActionResult Privacy () {
            return View ();
        }
    }
}