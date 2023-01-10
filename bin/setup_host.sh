
DB_PASSWORD=123456
container_name=pixel-prod-1
version=$(cat pixel_backend_deploy/version)

echo 'docker build ...'
docker build pixel_backend_deploy -t pixel_backend:$version
if [ "$(docker ps -aq -f name=^pixel-prod-1$)" ]; then
  echo 'docker rm ...'
  docker rm -f $container_name
fi
echo 'docker run ...'
docker run -d -p 3000:3000 --network=network1 -e DB_PASSWORD=$DB_PASSWORD --name=$container_name pixel_backend:$version
echo 'docker exec ...'
docker exec -it $container_name bin/rails db:create db:migrate
echo 'DONE!'