# Establece la imagen de base a utilizar
FROM debian:stretch-slim

# Establece el autor (maintainer) del archivo
MAINTAINER Eduardo Moreno

# Variables de entorno
ENV DEBIAN_FRONTEND noninteractive

# Directorio de trabajo
RUN mkdir /root/git
WORKDIR /root/git

#Fijamos la zona horaria a nivel contendor.
ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Actualización imágen de sistema
RUN apt-get update && apt-get -y -o Dpkg::Options::="--force-confold" upgrade

# Instalación de paquetes necesarios para compilar Buildroot
RUN apt-get install -y git build-essential wget cpio python python3 unzip bc mercurial subversion gcc-multilib vim ccache squashfs-tools zip gettext mtools dosfstools libncurses5-dev

# Instalación de paquetes interesantes para compilar aplicaciones para el entorno de la RG350
RUN apt-get install -y cmake

# Configuración de locales
#RUN locale-gen es_ES.UTF-8
#RUN update-locale LANG="es_ES.UTF-8" LANGUAGE="es_ES"
#RUN dpkg-reconfigure locales

# Limpieza del gestor de paquetes
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
