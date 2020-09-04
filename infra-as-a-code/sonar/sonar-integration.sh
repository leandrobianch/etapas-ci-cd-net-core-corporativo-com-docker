#!/bin/bash
SONAR_API_JSON_STATUS=$(curl -u $SONAR_TOKEN: "$SONAR_HOST_URL/api/qualitygates/project_status?projectKey=$SONAR_PROJECT_KEY")
echo "Json Sonar: $SONAR_API_JSON_STATUS"
SONAR_STATUS=$(echo $SONAR_API_JSON_STATUS | grep -Po '(?<="projectStatus":{"status":").*(?=","conditions")')
echo "Status sonar: $SONAR_STATUS"
if [[ "$SONAR_STATUS" != "OK" ]]
then 
    echo "As métricas do sonar não foram atendidas"
    exit 1;
fi