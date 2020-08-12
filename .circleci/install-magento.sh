#/bin/bash

# Increase kernel config required by Elasticsearch container
sudo sysctl -w vm.max_map_count=262144

docker login -u $DOCKER_USER -p $DOCKER_PASS docker-adobe-cif-release.dr-uw2.adobeitc.com

docker-compose up -d
docker ps

# Wait for Magento to be installed
while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' http://localhost:8080/graphql)" != "200" ]];
do echo "Waiting for Magento installation to complete ..." && sleep 15;
done

# Get Magento container id
CONTAINER=`docker ps | grep "bitnami/magento" | cut -f1 -d " "`

# Copy Magento repo credentials and install sample data
echo $MAGENTO_AUTH_JSON > auth.json
docker cp auth.json $CONTAINER:/opt/bitnami/magento/htdocs/auth.json
docker exec -it $CONTAINER php /opt/bitnami/magento/htdocs/bin/magento sampledata:deploy
docker exec -it $CONTAINER php /opt/bitnami/magento/htdocs/bin/magento setup:upgrade