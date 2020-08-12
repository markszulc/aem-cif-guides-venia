#/bin/bash
docker-compose up -d

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