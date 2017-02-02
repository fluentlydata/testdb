#!/bin/bash
# from http://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash
# and http://jonalmeida.com/posts/2013/05/26/different-ways-to-implement-flags-in-bash/

# parametes
data=$(pwd)/data
container_name=example_testdb
schema=example
pw=root

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
    docker run --name "$container_name" -d -v "$data":/docker-entrypoint-initdb.d -e MYSQL_DATABASE="$schema" -e MYSQL_ROOT_PASSWORD="$pw" mysql
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
