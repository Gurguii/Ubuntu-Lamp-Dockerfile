#!/bin/bash
trap ctrl_c INT
ctrl_c(){
	exit 0
}

# check privileges
if [[ $EUID != 0 ]]; then
	printf "Need sudo privileges¡\n"
	exit 0
fi

source .vars

# build docker image
printf "[+] Building docker image... " && docker build -t $docker_image_name . && printf "\n[+] Image '%s' created\n" "$docker_image_name"

# create docker instance
printf "[+] Creating docker instance... " && docker run --entrypoint /bin/startup.sh -p 80:80 -p 443:443 -d --name $docker_instance_name $docker_image_name && printf "[+] Instance '%s' created\n" "$docker_instance_name"
