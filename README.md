# Docker for Symfony
A Docker base configuration for Symfony 4 application.

## Getting started
 1. [Download](https://github.com/mpiot/docker4symfony/archive/master.zip) a .zip archive of this repository
 2. Extract files in your Symfony project (resolve conflict with .gitignore, just add lines)
 3. Replace some parts in travis.yml file:
    * mpiot/symfony-docker, by your GitHub repository
    * mapiot/symfony-docker, by your DockerHub repository
 4. In your [Travis account](https://travis-ci.org/), you must add 2 variables:
    * DOCKER_HUB_LOGIN, that contain your [DockerHub](https://hub.docker.com/) login
    * DOCKER_HUB_PASSWORD, that contain your [DockerHub](https://hub.docker.com/) password
 5. Build, create and start your new Containerized application with `make install`
 6. **Enjoy !**
 
## Make file
The Docker configuration come with a **Makefile**, use the command `make` to display all the possibilities (install, start, build assets, create db migration, db migrate, db rollback, tests, lint, etc...).

*Note: In this file the PHP-CS is called: lint-php and lint-php-cs.*

## Set access files right
Because the application is containerized, when you connect in the Shell `make shell`, and use `bin/console` command, files are created as root user. To avoid always re-attribute rights, we can use ACL's.

    sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX .
    sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX .

## Xdebug configuration
Xdebug is installed per default in the app image (in the development target build). You can remove it by passing a build argument in the *docker-compose.override.yml* file:

    services:
    app:
        build:
            context: .
            target: app-dev
            args:
                - XDEBUG_VERSION=0

Then, rebuild with `make install`, the resulting container do not contain Xdebug.

If like a lot of happy developpers you want to use Xdebug, you need to configure your IDE and your Browser, the above exemple is for [PHPStorm](https://www.jetbrains.com/phpstorm/)

1. Configure your Browser, the simplest part of this doc:

  - Go to [PHPStorm browser debugging extensions](https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions), and choose the extension depending
  your browser.
  - Install and configure it, in the Options of the Extension set the IDE key: 'PHPSTORM' for example.

2. Configure the IDE

  - On the top right of PhpStorm, you have a button: 'Add Configuration...' click on
  - On the Top left of the windows, click on the '+', then choose 'PHP Remote Debug'
  - Choose a name: 'docker'
  - Check 'Filter debug connection by IDE key', and fill the IDE key with the previous choised IDE key, in our case: 'PHPSTORM'
  - In the Server text field, click on the ... button, a Server windows appear
  - Click on the '+' in the top left
  - Choose a name: 'docker'
  - Fill the following fields:
     - Host: _
     - Port: 80
  - Check the Use path mappings
  - Select the main folder with yout code is in the File/Directory column
  - Then in the Absolute path on the server, fill: '/app', then save all the opened windows
  
