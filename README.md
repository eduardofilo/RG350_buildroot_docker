# Creación imagen Docker y arranque de contenedor

Artículo con más detalles [aquí](http://apuntes.eduardofilo.es/2020-05-25-rg350_docker_buildroot.html).

Con el siguiente procedimiento mantendremos el código y el resultado de la compilación en un directorio de la máquina host. Docker nos servirá para encapsular únicamente los binarios y librerías utilizados para la compilación de Buildroot.

1. Instalar Docker en máquina host:

    ```
    $ sudo apt install docker.io
    $ sudo groupadd docker
    $ sudo usermod -aG docker $USER
    $ sudo systemctl enable docker
    $ sudo systemctl start docker
    ```

2. Bajar repositorio en máquina host. Con los siguientes comandos quedará en `~/git/RG350_buildroot`:

    ```
    $ cd ~/git
    $ git clone https://github.com/tonyjih/RG350_buildroot.git
    ```

3. Arrancar contenedor pasando el directorio del repositorio del punto anterior como volumen:

    ```
    $ docker run -it -v ~/git/RG350_buildroot:/root/RG350_buildroot --name RG350_buildroot eduardofilo/rg350_buildroot
    ```

Si en lugar de utilizar la versión compilada subida al [Docker Hub](https://hub.docker.com/r/eduardofilo/rg350_buildroot) queremos construirlo en local (por si quisiéramos hacer alguna modificación en el Dockerfile), intercalaríamos los siguientes comandos entre los pasos 2 y 3 anteriores:

```
$ cd ~/git
$ git clone https://github.com/eduardofilo/RG350_buildroot_docker.git
$ cd ~/git/RG350_buildroot_docker
$ docker build -t eduardofilo/rg350_buildroot .
```

Tras ejecutar el paso 3 debería quedar un prompt ejecutándose desde el entorno Debian dentro del contenedor. Como hemos conectado el directorio `/root/RG350_buildroot` del contenedor con el directorio `~/git/RG350_buildroot` de nuestra máquina, cualquier cosa que queramos modificar o recoger al final de la compilación, la podremos localizar desde cualquier explorador de archivos de nuestra máquina. Si en algún momento perdiéramos de vista la terminal ejecutándose en el entorno del contenedor, podremos recuperarla ejecutando:

```
$ docker exec -it RG350_buildroot /bin/bash
```

# Operación de Buildroot

Una vez que tenemos preparado el entorno podremos realizar las tareas y compilaciones previstas en el mismo. Por ejemplo en el entorno preparado por [Tonyjih](https://github.com/tonyjih/RG350_buildroot) vemos que podemos realizar las siguientes cosas (las líneas de terminal siguientes están precedidas por `#` y no por `$` como antes porque se refieren al terminal dentro del contenedor, que se ejecuta con el usuario root del mismo):

* **OPCIONAL**. Para personalizar alguna opción de Buildroot, utilizar uno de los dos comandos siguientes (sólo uno):

    ```
    # make menuconfig
    # make nconfig
    ```

* Configurar Buildroot (sólo es necesario la primera vez):

    ```
    # cd ~/RG350_buildroot
    # make rg350_defconfig BR2_EXTERNAL=board/opendingux
    ```

* Compilar el toolchain (sólo es necesario una vez; tarda 1h50m en un Intel i3-4005U):

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

* Compilación de imagen para flashear en SD (el fichero con la imagen resultante queda en `~/git/RG350_buildroot/output/images/od-imager/images/sd_image.bin` en la máquina host):

    ```
    # cd ~/RG350_buildroot
    # board/opendingux/gcw0/make_initial_image.sh
    ```

Todo el proceso de compilación genera unos 12GBs de archivos.

# Comandos para gestionar contenedores

* `docker container ls -a`: Listar contenedores. Para averiguar hash por ejemplo.
* `docker container stop <hash>`: Detener contenedor.
* `docker container rm <hash>`: Borra contenedor.
