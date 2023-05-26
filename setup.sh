#!/usr/bin/env bash
install() {
    echo "Install Airbyte..."
    git clone -b modern-data-stack https://github.com/danilojpfreitas/airbyte.git
    cd airbyte
    ./run-ab-platform.sh
    cd ..

    echo "Install Airflow..."
    mkdir airflow
    cd airflow
    curl -LfO 'https://airflow.apache.org/docs/apache-airflow/2.6.1/docker-compose.yaml'
    mkdir -p ./dags ./logs ./plugins ./config
    echo -e "AIRFLOW_UID=$(id -u)" > .env
    docker-compose up airflow-init
    docker compose up
    wget https://raw.githubusercontent.com/danilojpfreitas/DataPipeline-airbyte-dbt-airflow-snowflake-metabase/main/airflow/.gitignore
    cd ..

    echo "Install Metabase..."
    mkdir metabase
    cd metabase
    wget https://raw.githubusercontent.com/danilojpfreitas/DataPipeline-airbyte-dbt-airflow-snowflake-metabase/main/metabase/docker-compose.yaml
    docker-compose up
    cd ..

    echo "Access Airbyte at http://localhost:8000 and set up the connections."
  
    echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."  

    echo "Access Metabase at http://localhost:3000 and set up a connection with Snowflake."

}

# up() {
#   echo "Starting Airbyte..."
#   cd airbyte
#   docker-compose down -v
#   ./run-ab-platform.sh
#   cd ..

#   echo "Starting Airflow..."
#   cd airflow
#   docker-compose down -v    
#   docker-compose up airflow-init
#   docker-compose up -d
#   cd ..

#   echo "Starting Metabase..."
#   cd metabase
#   docker-compose down -v
#   docker-compose up -d
#   cd ..
 
#   echo "Access Airbyte at http://localhost:8000 and set up the connections."
  
#   echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."  

#   echo "Access Metabase at http://localhost:3000 and set up a connection with Snowflake."

# }

# config() {

#   echo "Connecting Airflow with Airbyte..."
#   # echo "Enter your Airbyte Epidemiology connection ID: "
#   # read epidemiology_connection_id

#   echo "Enter your Airbyte Economy connection ID: "
#   read economy_connection_id

#   echo "Enter your Airbyte Demographics connection ID: "
#   read demographics_connection_id

#   echo "Enter your Airbyte Index connection ID: "
#   read index_connection_id

#   # Set connection IDs for DAG.
#   cd airflow
#   # docker-compose run airflow-webserver airflow variables set 'AIRBYTE_EPIDEMIOLOGY_CONNECTION_ID' "$epidemiology_connection_id"
#   docker-compose run airflow-webserver airflow variables set 'AIRBYTE_ECONOMY_CONNECTION_ID' "$economy_connection_id"
#   docker-compose run airflow-webserver airflow variables set 'AIRBYTE_DEMOGRAPHICS_CONNECTION_ID' "$demographics_connection_id"
#   docker-compose run airflow-webserver airflow variables set 'AIRBYTE_INDEX_CONNECTION_ID' "$index_connection_id"

#   docker network create modern-data-stack
#   docker network connect modern-data-stack airbyte-proxy
#   docker network connect modern-data-stack airbyte-worker  
#   docker network connect modern-data-stack airflow-airflow-worker-1
#   docker network connect modern-data-stack airflow-airflow-webserver-1
#   docker network connect modern-data-stack metabase
  
#   cd airflow
#   docker-compose run airflow-webserver airflow connections add 'airbyte_example' --conn-uri 'airbyte://airbyte:password@airbyte-proxy:8000'
#   cd ..
  
#   echo "Config Updated..."
# }


# down() {
#   echo "Stopping Airbyte..."
#   cd airbyte
#   docker-compose down
#   cd ..
#   echo "Stopping Airflow..."
#   cd airflow
#   docker-compose down
#   cd ..
#   echo "Stopping Metabase..."
#   cd metabase
#   docker-compose down
#   cd ..
# }

# case $1 in
#   up)
#     up
#     ;;
#   config)
#     config
#     ;;
#   down)
#     down
#     ;;
#   *)
#     echo "Usage: $0 {up|config|down}"
#     ;;
# esac