
This image is based on [PrivateBin on Nginx, php-fpm & Alpine](https://github.com/PrivateBin/docker-nginx-fpm-alpine) and is not meant for production environments.

**NGINX** will serve from `/var/www/web` folder, you just need to create a volume and you're done.

## Usage
From a `docker-compose.yml` file:  
```
version: '3'
services:
  web:
    image: 'rauluranga/nginx-php-fpm7:latest'
    ports:
      - "80:8080"
    depends_on:
      - db
    networks:
      - app-network
    env_file:
      - ./.env
    working_dir: /var/www/
    volumes:
      - ./web:/var/www/web:delegated
  db:
    image: mysql:5.7
    container_name: db
    volumes:
        - dbdata:/var/lib/mysql
    restart: always
    environment:
        MYSQL_ROOT_PASSWORD: secret
        MYSQL_DATABASE: mydb
        MYSQL_USER: myuser
        MYSQL_PASSWORD: mypassword
    ports:
        - "3306:3306"
    networks:
        - app-network
networks:
  app-network:
    driver: bridge
volumes:
  dbdata:
    driver: local
```

**Build locally**
```
$ docker build -t TARGET_IMAGE[:TAG] .
```

**Build Multi-Arch Images for Arm and x86**
```
$ docker buildx build --platform linux/amd64,linux/arm64 -t TARGET_IMAGE[:TAG] .
```

Read: 
* [Building Multi-Arch Images for Arm and x86 with Docker Desktop](https://www.docker.com/blog/multi-arch-images/)
* [PrivateBin on Nginx, php-fpm & Alpine](https://github.com/PrivateBin/docker-nginx-fpm-alpine)
