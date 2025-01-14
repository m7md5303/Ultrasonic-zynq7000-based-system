# PetaLinux Image Creation with Xilinx AXIDMA Driver

This document outlines the steps we followed to create a PetaLinux image using the `xilinx-zc706-2018.3.bsp` file and integrate the Xilinx AXIDMA driver into the build.

## Prerequisites

- Installed Docker image of PetaLinux with `xilinx-zc706-2018.3.bsp` file.
- Docker image contains all the necessary dependencies and installations of PetaLinux.

## Steps to Create PetaLinux Image

1. **Create a PetaLinux Project**  
   Run the following command to create a PetaLinux project:

   ``` bash
   petalinux-create -t project -s ./xilinx-zc706-2018.3.bsp
   ```

2. **Clone the Xilinx AXIDMA Driver**  
Clone the Xilinx AXIDMA driver repository:

   ``` bash
   git clone https://github.com/bperez77/xilinx_axidma
   ```

## Issue with Out-of-Tree Builds

PetaLinux seems to store all generated build files in a separate directory, which prevents running an out-of-tree build using the driver's build system. To resolve this, we need to create a PetaLinux 'modules' project, copy the driver source code, and make some modifications.

## Creating and Modifying the Modules Project

1. **Create a PetaLinux 'Modules' Project**  
   Change to your PetaLinux project directory and run the following command:

   ``` bash
   petalinux-create -t modules -n xilinx-axidma --enable
   ```

2. **Copy the Driver Files**  
   Copy all the C source files, header files, and the `axidma_ioctl.h` file from the driver directory to the PetaLinux project:

   ``` bash
    cp -a driver/*.c driver/*.h include/axidma_ioctl.h <path/to/PetaLinux/project>/project-spec/meta-user/recipes-modules/xilinx-axidma/files
    ```

   Remove the auto-generated `xilinx-axidma.c` file:

   ``` bash
   rm <path/to/PetaLinux/project>/project-spec/meta-user/recipes-modules/xilinx-axidma/files/xilinx-axidma.c
    ```

3. **Modify the Makefile**  
   Replace the first line of the Makefile at `<path/to/PetaLinux/project>/project-spec/meta-user/recipes-modules/xilinx-axidma/files/Makefile` with the following:

   ``` bash
   DRIVER_NAME = xilinx-axidma
    $(DRIVER_NAME)-objs = axi_dma.o axidma_chrdev.o axidma_dma.o axidma_of.o
    obj-m := $(DRIVER_NAME).o
    ```

## Modifying the Bitbake Recipe

To ensure the files are included in the build, append all C and header files to the `SRC_URI` list in the `xilinx-axidma.bb` file:

``` bash  
    SRC_URI = "file://Makefile \ 
           file://axi_dma.c \
           file://axidma_chrdev.c \
           file://axidma_dma.c \
           file://axidma_of.c \
           file://axidma.h \
           file://axidma_ioctl.h \
           file://COPYING \
          "
```

## Building the Module

You can build the PetaLinux image normally or build just the AXIDMA module with the following command:

``` bash
petalinux-build -c xilinx-axidma
```
