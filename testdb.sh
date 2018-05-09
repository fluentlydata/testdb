#!/bin/bash
# from http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# and http://jonalmeida.com/posts/2013/05/26/different-ways-to-implement-flags-in-bash/

# parametes
data=$(pwd)/data
container_name=example_testdb
schema=example
pw=root
ip=$(docker-machine ip default)
port=33000

function printHelp() {
	echo "options:" 
	echo "-t|--test"
	echo "-r|--run"
	echo "-k|--kill"
	echo "-i|--inspect"
}

while [[ ! $# -eq 0 ]]
do
key="$1"
case $key in
	-t|--test)
    echo "hello world"
	exit
    ;;
	-r|--run)
    # thanks to https://stackoverflow.com/questions/49945649/mysql-error-authentication-plugin-caching-sha2-password-cannot-be-loaded
    # "--default-authentication-plugin=mysql_native_password" is needed in order to be able to connect by a local non-docker mysql instance
    docker run -p 33000:3306 --name "$container_name" -d -v "$data":/docker-entrypoint-initdb.d -e MYSQL_DATABASE="$schema" -e MYSQL_ROOT_PASSWORD="$pw" mysql:8  --default-authentication-plugin=mysql_native_password
	echo "mysql db running on $ip:$port"
    exit
    ;;
    -k|--kill)
	docker kill "$container_name" && docker rm "$container_name"
	# more agressive: docker ps -a | grep Exit | cut -d ' ' -f 1 | xargs docker rm
	exit
    ;;
    -i|--inspect)
	docker exec -i -t "$container_name" /bin/bash -c "mysql -uroot -p'$pw'"
	exit
    ;;
	*)
	printHelp
	exit
    ;;
esac
shift # past argument or value
done

printHelp
