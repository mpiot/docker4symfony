# Docker for Symfony
A Docker base configuration for Symfony 4 applications.

There are 3 branchs:
 - master: a simple Docker configuration
 - travis: same as master, with TravisCi config for CI, and Delivery
 - travis-azure: same as travis, but customized image for Azur Deployment

## Getting started
 1. [Download](https://github.com/mpiot/docker4symfony/archive/master.zip) a .zip archive of this repository
 2. Extract the files in your Symfony project (to avoid any conflict with the .gitignore files, just manually add the lines)
 3. Replace some parts in the travis.yml file:
    * mpiot/symfony-docker, by your GitHub repository
    * mapiot/symfony-docker, by your DockerHub repository
 4. In your [Travis account](https://travis-ci.org/), you need to add 2 variables:
    * DOCKER_HUB_LOGIN, that contain your [DockerHub](https://hub.docker.com/) login
    * DOCKER_HUB_PASSWORD, that contain your [DockerHub](https://hub.docker.com/) password
 5. If you want to use the provided php_cs.dist file, you should check it, and update the Licence header
 6. Build, create and start your new Containerized application with `make install`
 7. **Enjoy !**
 
## Make file
The Docker configuration comes with a **Makefile**, use the command `make` to display all possible options (install, start, build assets, create db migration, db migrate, db rollback, tests, lint, etc.).

*Note: In this file the PHP-CS is called: lint-php and lint-php-cs.*

## Set access files right
Because the application is containerized, when you connect to a container with `make shell`, and use `bin/console` command, files are created as root user. To avoid having to manually re-attribute access rights, we can use ACLs.

    sudo setfacl -dR -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX .
    sudo setfacl -R -m u:"$HTTPDUSER":rwX -m u:$(whoami):rwX .

## Xdebug configuration
Xdebug is installed by default in the app image (in the development target build). You can remove it by passing a build argument to the *docker-compose.override.yml* file:

    services
    app:
        build:
            context: .
            target: app-dev
            args:
                - XDEBUG_VERSION=0

Then, rebuild with `make install`, the resulting container does not contain Xdebug.

If like a lot of happy developers you want to use Xdebug, you need to configure your IDE and your browser, the following exemple is for [PHPStorm](https://www.jetbrains.com/phpstorm/)

1. Configure your browser, the easiest part of this doc:

  - Go to [PHPStorm browser debugging extensions](https://confluence.jetbrains.com/display/PhpStorm/Browser+Debugging+Extensions), and choose the extension depending
  your browser.
  - Install and configure it, in the extension options set the IDE key: 'PHPSTORM' for example.

2. Configure PhpStorm

  - Click on 'Add configuration...' 'in the upper right hand corner of PhpStorm
  - At the top left of the window, click the '+' button and choose 'PHP Remote Debug'
  - Choose a name: 'docker'
  - Check 'Filter debug connection by IDE key', and fill the IDE key with the previously chosen IDE key, in our case: 'PHPSTORM'
  - In the 'server' text field, click on the '...' button, a Server window will appear
  - Click the '+' button in the top left corner
  - Choose a name: 'docker'
  - Fill in the following fields:
     - Host: _
     - Port: 80
  - Check the 'Use path mappings' option
  - Select your project folder in the 'File/Directory' column
  - Set the 'Absolute path on the server' to '/app'
  - Finally, click 'Ok' in both the 'Server' and the 'Run/Debug Configurations' windows
  
