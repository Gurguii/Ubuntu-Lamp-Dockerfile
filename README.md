
# Dockerfile Lamp image/container setup

Builds a docker image from **ubuntu:latest** with Lamp(Linux, Apache, MySQL, Php) pile.  

Additionally, it comes with **evasive** and **security2** mods preinstalled on **Apache** and **autoindex** mod disabled.  

**Image size** - ***1.08gb***

## Quick setup
- Clone this repository locally  
```bash
sudo git clone https://github.com/Gurguii/Ubuntu-Lamp-Dockerfile
```  

- Get into the Ubuntu-Lamp-Dockerfile directory  
```bash
cd Ubuntu-Lamp-Dockerfile
```  

- Run setup.sh with **sudo** privileges
```bash
sudo bash setup.sh
```

- You will see Docker printing info about the image being built from **Dockerfile** file, any error (there shouldn't be) will be printed.  
*Note: If you find any error you can't fix, let me know (give some context and info) and I'll try to help you out*  

- After the setup ends, you will have a docker **image** and **container**(running) called **lamp**(which can be changed in the **.vars** file). 
*Note: Might take a bit since the image is not light at all and installing/setting everything takes some time. Will try to improve deploy time*  

- An http/https domain (lamp.es) will be now accesible(you can also use host IP):  

    \- The https site contains a **/db.php** route which will corroborate the conexion to the Mysql server using a newly created user, database and table with random users.  This can be changed by editing **.mysql.queries** file in the project directory.  

    \- In addition, **/info.php** shouldn't be accesible because apache2's mod **security2** is forbidding the access.  

    \- If you want to test the **evasive** mod just quicky refresh the page and you will soon be forbidden from accessing the site for 10 seconds. This and other parameters are changable in */etc/apache2/mods-enabled/evasive.conf* file, run service apache2 restart after.
    
- In order to get into the running container:  
```bash
docker exec -it lamp bash
``` 
### METAINFO
- Commands used by **setup.sh** to:

    ***build image***
    ```bash
    docker build -t $docker_image_name .
    ```  
    ***create container***
    ```bash
    docker run --entrypoint /bin/startup.sh -p 80:80 -p 443:443 -d --name $docker_instance_name
    ```
    
    The **run** command *starts* and *detach* a container *forwarding* default *http/https* ports from host to internal ones.  

- Commands used by entrypoint custom script *.startup.sh*:
  
    ***start mysql***  
    ```bash
    service mysql start
    ```
    ***start apache2***  
    ```bash
    apache2ctl -D bg
    ```

### Custom build info  
- **.mysql.queries** file contains the queries that will be run when creating the image, by default they create  user **db_user** with password **db_pass**, database **db_name** and table **db_table**.  
- **.vars** file contains **$docker_image_name** and **$docker_instance_name** which will be the image/container names, both *lamp* by default.
- **conf** directory contains the evasive, security2, virtualhost configuration files.
