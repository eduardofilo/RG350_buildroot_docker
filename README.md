# Docker image to compile RG350 Buildroot and Toolchain

Docker image, based in Debian Stretch, for building Buildroot for RG350 without altering our host machine.

## Links

* [Detailed post (in spanish)](http://apuntes.eduardofilo.es/2020-05-25-rg350_docker_buildroot.html).
* [Dockerfile](https://github.com/eduardofilo/RG350_buildroot_docker)

## Docker container start up

1. Install Docker in host machine:

    ```
    $ sudo apt install docker.io
    $ sudo groupadd docker
    $ sudo usermod -aG docker $USER
    $ sudo systemctl enable docker
    $ sudo systemctl start docker
    ```

2. Download buildroot repository to host machine:

    ```
    $ cd ~/git
    $ git clone https://github.com/tonyjih/RG350_buildroot.git
    ```

3. Run container:

    ```
    $ docker run -it -v ~/git:/root/git --name RG350_buildroot eduardofilo/rg350_buildroot
    ```

## Container connection

Once created, we can connect with container with:

```
$ docker exec -it RG350_buildroot /bin/bash
```

If previous command returns an error indicating that the container is stopped, we can start it before executing the command:

```
$ docker start RG350_buildroot
```

## Working with RG350 Buildroot

Once we are in container terminal, these are the things that can be done:

* To config Buildroot (only necessary first time):

    ```
    # cd ~/git/RG350_buildroot
    # make rg350_defconfig BR2_EXTERNAL=board/opendingux
    ```

* OPTIONAL. We can personalize Buildroot with one of this command (use one or the other):

    ```
    # cd ~/git/RG350_buildroot
    # make menuconfig
    # make nconfig
    ```

* To build toolchain (only necessary first time):

    ```
    # cd ~/git/RG350_buildroot
    # export BR2_JLEVEL=0
    # make toolchain
    ```

* To build particular libraries and packages, for example to build SDL and SDL_Image:

    ```
    # cd ~/git/RG350_buildroot
    # export BR2_JLEVEL=0
    # make sdl sdl_image
    ```

* OPTIONAL. If you want to include a set of default applications, emulators, and games from various sources, run this command (you only need to do this once):

    ```
    # cd ~/git/RG350_buildroot
    # board/opendingux/gcw0/download_local_pack.sh
    ```

* To build the OS image, run:

    ```
    # cd ~/git/RG350_buildroot
    # board/opendingux/gcw0/make_initial_image.sh
    ```

The image will saved to: `~/git/RG350_buildroot/output/images/od-imager/images/sd_image.bin`

The entire compilation process generates about 12GB of files.

## Commands to manage containers

|Command|Effect|
|:--------------|:--------|
|`docker container ls -a`|List all containers. Use to get container hash.|
|`docker container start <hash>`|Start container.|
|`docker exec -it <hash> /bin/bash`|Get bash prompt in container.|
|`docker container stop <hash>`|Stop container.|
|`docker container rm <hash>`|Remove container.|
