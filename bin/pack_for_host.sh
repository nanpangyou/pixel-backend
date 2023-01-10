# 注意修改 oh-my-env 目录名为你的目录名
dir=oh-my-env

# 部分变量，以及打包路径
time=$(date +'%Y%m%d-%H%M%S')
dist=tmp/pixel_backend-$time.tar.gz
current_dir=$(dirname $0)
deploy_dir=/workspaces/$dir/pixel_backend_deploy

# 删除上次的打包文件
yes | rm tmp/pixel_backend-*.tar.gz; 
yes | rm $deploy_dir/pixel_backend-*.tar.gz; 


# 打包 --exclude（ 不包含 ） -c 创建 -z 通过gzip指令处理备份文件 -v verbose（显示详情） -f 打包的文件名  * （不包含.开头的文件）
tar --exclude="tmp/cache/*" -czv -f $dist *

# -p 参数, 确保文件夹存在，没有就会自动创建
mkdir -p $deploy_dir
cp $current_dir/../config/host.Dockerfile $deploy_dir/Dockerfile
cp $current_dir/setup_host.sh $deploy_dir/
mv $dist $deploy_dir

# 用时间戳作为版本号
echo $time > $deploy_dir/version
echo 'DONE!'