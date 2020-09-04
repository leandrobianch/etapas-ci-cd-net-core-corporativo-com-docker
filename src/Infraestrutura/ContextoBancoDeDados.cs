using docker_deploy_artifacts.Models;
using Microsoft.EntityFrameworkCore;

namespace docker_deploy_artifacts.Infraestrutura.Data
{
  public class ContextoBancoDeDados : DbContext
  {
      public virtual DbSet<Cliente> Cliente {get; set; }

      public ContextoBancoDeDados(DbContextOptions<ContextoBancoDeDados> options) : base(options)
      {
      }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
          {
              modelBuilder.Entity<Cliente>(e =>
              {
                  e.HasKey(p => p.Codigo);
                  e.Property(p => p.Nome).IsRequired();
                  e.Property(p => p.DataNascimento).IsRequired();
                  e.Ignore(p => p.Idade);
                  e.Ignore(p => p.FormatadaIdade);
                  e.Ignore(p => p.FormataSeEhMaiorDeIdade);
              });

              base.OnModelCreating(modelBuilder);
          }
  }
}
