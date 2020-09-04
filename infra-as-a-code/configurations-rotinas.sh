
# se está no pipeline automatizado
if [[ "${TF_BUILD}" ]]
then 
    echo "Iniciando as configurações das rotinas de C.I e C.D No Azure DevOps Pipeline"
else

    echo "Iniciando as configurações das rotinas de C.I e C.D local"
   
    . ./infra-as-a-code/configurations-rotina.dev.secrets
fi