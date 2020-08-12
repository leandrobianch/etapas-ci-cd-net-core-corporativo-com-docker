using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using docker_deploy_artifacts.Infraestrutura.Data;
using docker_deploy_artifacts.Models;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace docker_deploy_artifacts
{
    public class Program
    {
       public static void Main(string[] args)
       {
         var host = CreateHostBuilder(args).Build();
         using (var scope = host.Services.CreateScope())
         {
            var contextoBancoDeDados = scope.ServiceProvider.GetRequiredService<ContextoBancoDeDados>();
            contextoBancoDeDados.Database.Migrate();
            if(contextoBancoDeDados.Cliente.Count () == 0)
            {
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "JIMI HENDRIX", DataNascimento = Convert.ToDateTime("1968-11-21") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "BBKING", DataNascimento = Convert.ToDateTime("1934-05-08") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "BILL GATES", DataNascimento = Convert.ToDateTime("1958-07-19") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "STEVE JOBS", DataNascimento = Convert.ToDateTime("1960-12-05") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "EDDIE VEDDER", DataNascimento = Convert.ToDateTime("1960-10-10") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "DAVID GILMOUR", DataNascimento = Convert.ToDateTime("1956-02-28") });
                contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "LEANDRO BIANCH DO FUTURO", DataNascimento = DateTime.Now.Date });
                contextoBancoDeDados.SaveChanges();
            }
         }
         host.Run();
        }


        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    config.AddEnvironmentVariables();
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
