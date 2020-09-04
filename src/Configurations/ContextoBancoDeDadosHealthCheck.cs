using docker_deploy_artifacts.Infraestrutura.Data;
using docker_deploy_artifacts.Models;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Logging;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace src.Infraestrutura.Configurations
{
    public class ContextoBancoDeDadosHealthCheck : IHealthCheck
    {
        public IServiceScopeFactory ScopeFactory { get; }
        private ContextoBancoDeDados _contextoBancoDeDados;
        private ILogger<ContextoBancoDeDadosHealthCheck> _logger;
        public ContextoBancoDeDadosHealthCheck(IServiceScopeFactory scopeFactory)
        {
            ScopeFactory = scopeFactory;
        }

        public async Task<HealthCheckResult> CheckHealthAsync(HealthCheckContext context, CancellationToken cancellationToken = default)
        {
            using (
                var scope = ScopeFactory.CreateScope())
            {
                _logger = scope.ServiceProvider.GetRequiredService<ILogger<ContextoBancoDeDadosHealthCheck>>();

                try
                {
                    _contextoBancoDeDados = scope.ServiceProvider.GetRequiredService<ContextoBancoDeDados>();

                    var migracoesPendentes = await _contextoBancoDeDados.Database.GetPendingMigrationsAsync();

                    if (migracoesPendentes.Count() == 0)
                    {
                        return HealthCheckResult.Healthy();
                    }

                    await _contextoBancoDeDados.Database.MigrateAsync();

                    if (_contextoBancoDeDados.Cliente.Count() == 0)
                    {
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "JIMI HENDRIX", DataNascimento = Convert.ToDateTime("1968-11-21") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "BBKING", DataNascimento = Convert.ToDateTime("1934-05-08") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "BILL GATES", DataNascimento = Convert.ToDateTime("1958-07-19") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "STEVE JOBS", DataNascimento = Convert.ToDateTime("1960-12-05") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "EDDIE VEDDER", DataNascimento = Convert.ToDateTime("1960-10-10") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "DAVID GILMOUR", DataNascimento = Convert.ToDateTime("1956-02-28") });
                        _contextoBancoDeDados.Cliente.Add(new Cliente() { Nome = "LEANDRO BIANCH DO FUTURO", DataNascimento = DateTime.Now.Date });
                        _contextoBancoDeDados.SaveChanges();
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError($"{nameof(ContextoBancoDeDadosHealthCheck)} - {nameof(CheckHealthAsync)} error: {ex}");


                    return new HealthCheckResult(status: context.Registration.FailureStatus, exception: ex);
                }

                return HealthCheckResult.Healthy();
            }  
        }
    }
}
