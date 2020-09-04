using System;
using docker_deploy_artifacts.Infraestrutura.Data;
using docker_deploy_artifacts.Infraestrutura.Repository;
using docker_deploy_artifacts.Repository;
using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using src.Infraestrutura.Configurations;

namespace docker_deploy_artifacts
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }
        public ILogger Logger { get; private set;}

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            var connectionString = Configuration.GetConnectionString("DefaultConnection");

            services.AddDbContext<ContextoBancoDeDados>(options =>
            options.UseSqlServer(connectionString,
                    x => x.MigrationsAssembly(typeof(ContextoBancoDeDados).Assembly.FullName)
                .EnableRetryOnFailure()
            ));

            services.AddScoped<IClienteRepository, ClienteRepository>();

            services.AddHealthChecks().AddCheck<ContextoBancoDeDadosHealthCheck>($"{nameof(ContextoBancoDeDados)}");            
            services.AddHealthChecksUI(config =>
            {
                config.AddHealthCheckEndpoint("SQL Server", ObterHostNameApiHealthCheck());          
                
            }).AddInMemoryStorage();

            services.AddControllersWithViews();
        }

        public string ObterHostNameApiHealthCheck()
        {
            return Environment.GetEnvironmentVariable("HostNameHealthCheck") == null ? "/api/health" : $"{Environment.GetEnvironmentVariable("HostNameHealthCheck")}/api/health";
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            else
            {
                app.UseExceptionHandler("/Home/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }
            
            app.UseHealthChecks("/api/health", new HealthCheckOptions()
            {
                Predicate = _ => true,                
                ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse,
                ResultStatusCodes =
                {
                    [HealthStatus.Healthy] = StatusCodes.Status200OK,
                    [HealthStatus.Degraded] = StatusCodes.Status200OK,
                    [HealthStatus.Unhealthy] = StatusCodes.Status503ServiceUnavailable,
                }
            });

            app.UseHealthChecksUI(options =>
            {
                options.UIPath = "/hc";
            });

            app.UseStaticFiles();

            app.UseRouting();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllerRoute(
                    name: "default",
                    pattern: "{controller=Home}/{action=Index}/{id?}");
            });

            
        }
    }
}
