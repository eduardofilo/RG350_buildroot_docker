# Creación imagen Docker y arranque de contenedor

1. Instalar Docker en máquina host:

    ```
    $ sudo apt  install docker.io
    ```

2. Bajar repositorio en máquina host:

    ```
    $ cd ~/git
    $ git clone https://github.com/tonyjih/RG350_buildroot.git
    ```

3. Arrancar contenedor:

    ```
    $ docker run -it -v ~/git/RG350_buildroot:/root/RG350_buildroot --name RG350_buildroot eduardofilo/rg350_buildroot
    ```

# Conexión con contenedor

Si se pierde la conexión conectar con contenedor con:

```
$ docker start RG350_buildroot
$ docker exec -it RG350_buildroot /bin/bash
```

# Trabajo con el contenedor

Una vez que estemos en la terminal del contenedor arrancado podemos hacer las siguientes cosas:

* Opcionalmente para personalizar alguna opción de Buildroot, utilizar uno de los dos siguientes comandos (sólo uno):

    ```
    # make menuconfig
    # make nconfig
    ```

* Configurar Buildroot (sólo es necesario la primera vez):

    ```
    # cd ~/RG350_buildroot
    # make rg350_defconfig BR2_EXTERNAL=board/opendingux
    ```

* Compilar el toolchain (sólo es necesario una vez):

    ```
    # cd ~/RG350_buildroot
    # export BR2_JLEVEL=0
    # make toolchain
    ```

* Compilar una librería o paquete. Por ejemplo para compilar SDL y SDL_Image:

    ```
    # cd ~/RG350_buildroot
    # export BR2_JLEVEL=0
    # make sdl sdl_image
    ```


* Si se quiere que la imagen incluya emuladores y aplicaciones, ejecutar antes lo siguiente (sólo es necesario hacerlo una vez):

    ```
    # cd ~/RG350_buildroot
    # board/opendingux/gcw0/download_local_pack.sh
    ```

* Compilación de imagen para flashear en SD:

    ```
    # cd ~/RG350_buildroot
    # board/opendingux/gcw0/make_initial_image.sh
    ```

Todo el proceso de compilación genera unos 12GBs de archivos.

# Comandos para gestionar contenedores

* `docker container start <nombre_imagen>`: Arrancar contenedor con la imagen `<nombre_imagen>`.
* `docker container ls -a`: Listar contenedores. Para averiguar hash por ejemplo.
* `docker container stop <hash>`: Detener contenedor.
* `docker container rm <hash>`: Borra contenedor.
