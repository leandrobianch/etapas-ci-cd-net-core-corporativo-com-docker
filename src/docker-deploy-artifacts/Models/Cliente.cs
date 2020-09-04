using System;
using System.ComponentModel.DataAnnotations;
using System.Linq;

namespace docker_deploy_artifacts.Models
{
    public class Cliente
    {        
        public int Codigo { get; set; }
        
        [Display(Name = "Nome")]
        public string Nome { get; set; }
        
        [Display(Name = "Data de nascimento")]
        [DataType(DataType.Date)]
        [DisplayFormat(ApplyFormatInEditMode = true, DataFormatString = "{0:dd/MM/yyyy}")]    
        public DateTime DataNascimento { get; set; }

        [Display(Name = "Idade")]
        public string FormatadaIdade => $"{Idade} anos";

        public int Idade { get; private set;}

        public void CalcularIdade()
        {   
            Idade = DateTime.Now.Year - DataNascimento.Date.Year;
        }
        public bool EhMaiorDeIdade()
        {
            return Idade >= 18;
        }   
        public string FormataSeEhMaiorDeIdade => EhMaiorDeIdade() ? "Sim" : "Não";
     }   
}
