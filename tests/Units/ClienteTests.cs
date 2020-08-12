using System;
using Xunit;
using docker_deploy_artifacts.Models;
namespace docker_deploy_artifacts_tests.Units
{
    public class ClienteTests
    {
        private Cliente _cliente;

        public ClienteTests()
        {
            _cliente = new Cliente();            
        }

        [Fact]
        public void Cliente_QuandoInformarDataAtual_DeveValidarMenorDeIdade()
        {
            // assert
            _cliente.Nome = "LEANDRO BIANCH DO FUTURO";
            _cliente.DataNascimento = DateTime.Now;

            // Act
            _cliente.CalcularIdade();

            // Assert
            Assert.False(_cliente.EhMaiorDeIdade());
        }

        [Fact]
        public void Cliente_QuandoInformarDataComAtual18AnosAtras_DeveValidarMaiorDeIdade()
        {
            // assert
            _cliente.Nome = "JIMI HENDRIX";
            _cliente.DataNascimento = DateTime.Now.AddYears(-18);

            // Act
            _cliente.CalcularIdade();

            // Assert
            Assert.True(_cliente.EhMaiorDeIdade());
        }
    }
}
