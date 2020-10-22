using System;
using Xunit;
using docker_deploy_artifacts.Models;
namespace docker_deploy_artifacts_units_tests.Domain
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

        [Theory]
        [InlineData("JIMI HENDRIX", 18, "Sim")]
        [InlineData("JIMI HENDRIX", 16, "Não")]
        [InlineData("BBKING", 56, "Sim")]
        [InlineData("LEANDRO BIANCH DO FUTURO", 17, "Não")]        
        public void Cliente_QuandoInformarAIdade_DeveRetornarSeMaiorDeIdadeFormatada(string nome, int idade, string resultadoEsperado)
        {
            // assert
            _cliente.Nome = nome;
            _cliente.DataNascimento = DateTime.Now.AddYears(-idade);

            // Act
            _cliente.CalcularIdade();
            
            // Assert
            Assert.Equal(resultadoEsperado, _cliente.FormataSeEhMaiorDeIdade);
        }

        [Theory]
        [InlineData("JIMI HENDRIX", 18, "Sim")]
        [InlineData("JIMI HENDRIX", 16, "Não")]
        [InlineData("BBKING", 56, "Sim")]
        [InlineData("LEANDRO BIANCH DO FUTURO", 17, "Não")]        
        public void Cliente_QuandoInformarAIdade_DeveRetornarAIdadeFormatadaIdade(string nome, int idade, string resultadoEsperado)
        {
            // assert
            _cliente.Nome = nome;
            _cliente.DataNascimento = DateTime.Now.AddYears(-idade);

            // Act
            _cliente.CalcularIdade();
            
            // Assert
            Assert.Equal($"{_cliente.Idade} anos", _cliente.FormatadaIdade);
        }
    }
}
