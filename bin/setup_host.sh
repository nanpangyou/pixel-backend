
DB_PASSWORD=123456
RAILS_MASTER_KEY=c95b81927c312b94cd1ff18805df76ed
DB_HOST=db-for-pixel
container_name=pixel-prod-1
version=$(cat pixel_backend_deploy/version)

echo 'docker build ...'
docker build pixel_backend_deploy -t pixel_backend:$version
if [ "$(docker ps -aq -f name=^pixel-prod-1$)" ]; then
  echo 'docker rm ...'
  docker rm -f $container_name
fi
echo 'docker run ...'
docker run -e DB_HOST=$DB_HOST -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY -d -p 3000:3000 --network=network1 -e DB_PASSWORD=$DB_PASSWORD --name=$container_name pixel_backend:$version
echo 'docker exec ...'
docker exec -it $container_name bin/rails db:create db:migrate
echo 'DONE!'