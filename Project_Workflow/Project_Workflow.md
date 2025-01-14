# Summary of Zynq-7000 SoC Project Workflow

**Author**: Embedded Team Guidance  
**Date**: *\today*  

## Table of Contents
- [Project Overview](#project-overview)
- [Toolchain Overview](#toolchain-overview)
- [Workflow and Tools](#workflow-and-tools)
  - [Vivado and FPGA Design](#1-vivado-and-fpga-design-handled-by-fpga-team)
  - [Vitis for Embedded Software Development](#2-vitis-for-embedded-software-development)
  - [PetaLinux for Linux Image Creation](#3-petalinux-for-linux-image-creation)
  - [Testing and Integration](#4-testing-and-integration)
- [Testing AXI Communication without Hardware](#testing-axi-communication-without-hardware)
  - [Bare-Metal Testing with Vitis](#1-bare-metal-testing-with-vitis)
  - [Linux-Based Testing with PetaLinux and QEMU](#2-linux-based-testing-with-petalinux-and-qemu)
- [Code Examples](#code-examples)
  - [Bare-Metal AXI Access in Vitis](#bare-metal-axi-access-in-vitis)
  - [Linux User-Space AXI Access](#linux-user-space-axi-access)
- [References](#references)

---

## Project Overview
You are working on a project involving the Zynq-7000 SoC (ZC702) with three main components:

- **FPGA Team**: Develops custom logic in the FPGA, including AXI interfaces.
- **Embedded Team**: Establishes communication between the ARM processor and the FPGA via AXI, and sets up a Linux environment for the software team.
- **Software Team**: Develops Python scripts to process data provided by the embedded team.

---

## Toolchain Overview
- **Vivado**: Used by the FPGA team for designing and implementing the FPGA hardware, including AXI interfaces.
- **Vitis**: An IDE for embedded software development, focusing on writing and testing C/C++ applications that interact with the FPGA via AXI.
- **PetaLinux**: A tool for building and customizing Linux distributions for Xilinx devices, including kernel and root filesystem.
- **QEMU**: An emulator that allows you to run Linux images on your local machine without needing physical hardware.

---

## Workflow and Tools

### 1. Vivado and FPGA Design (Handled by FPGA Team)
The FPGA team designs the AXI interfaces using Vivado and provides the hardware description (HDF/XSA) file. This file is later used by the embedded team in Vitis.

### 2. Vitis for Embedded Software Development
- **Platform Project in Vitis**:
  - Create a platform project in Vitis using the hardware description provided by the FPGA team.
  
- **Bare-Metal Testing in Vitis**:
  - Develop and test C/C++ applications in a bare-metal environment (without an OS) to interact with AXI registers using Vitis.
  
- **Linux-Based Testing in Vitis**:
  - For Linux-based applications, use Vitis to develop, cross-compile, and deploy C/C++ code that runs within a Linux environment on the Zynq-7000 SoC.

### 3. PetaLinux for Linux Image Creation
- Build a customized Linux image with PetaLinux, including the Linux kernel, device tree, and root filesystem.
- Use QEMU to emulate the Zynq-7000 SoC and test the Linux image before deploying it on hardware.

### 4. Testing and Integration
- **Bare-Metal Testing**:
  - Develop and test C/C++ code in Vitis to interact with AXI registers directly, without Linux.
  
- **Linux-Based Testing**:
  - Cross-compile C/C++ applications using PetaLinux and test them within a Linux environment on QEMU.
  
- **Final Deployment**:
  - Deploy the Linux image and your applications to the actual ZC702 board once available, and test the complete setup.

---

## Testing AXI Communication without Hardware

### 1. Bare-Metal Testing with Vitis
- **Develop Bare-Metal Application**:
  - Create a Vitis project for bare-metal development.
  - Write C/C++ code to interact with AXI registers using memory-mapped I/O functions like `Xil_Out32` and `Xil_In32`.
  
- **Test and Debug**:
  - If supported, use QEMU to emulate the application.
  - Deploy and test on hardware when available.

### 2. Linux-Based Testing with PetaLinux and QEMU
- **Cross-Compile C/C++ Code**:
  - Write a Linux user-space application that uses `mmap` to access AXI registers.
  - Cross-compile the code using the toolchain provided by PetaLinux.
  
- **Deploy and Test in QEMU**:
  - Deploy the cross-compiled application to the Linux image running in QEMU.
  - Test AXI communication in the emulated environment.
  
- **Final Deployment on Hardware**:
  - Once the hardware is available, deploy the application and perform final testing.

---

## Code Examples

### Bare-Metal AXI Access in Vitis
The following C code demonstrates how to interact with AXI registers in a bare-metal environment using Vitis.

```c
#include "xil_io.h"

#define AXI_BASE_ADDR  0x40000000  // Replace with actual base address

int main() {
    u32 data;

    // Write to AXI register
    Xil_Out32(AXI_BASE_ADDR, 0xABCD1234);

    // Read from AXI register
    data = Xil_In32(AXI_BASE_ADDR);

    // Check if data is correct
    if (data == 0xABCD1234) {
        // Success: Data read matches the data written
    } else {
        // Error handling
    }

    return 0;
}
```


### Linux User-Space AXI Access
The following C code demonstrates how to interact with AXI registers in a Linux user-space application using `mmap`.

```c
#include "xil_io.h"

#include <fcntl.h>
#include <sys/mman.h>
#include <unistd.h>
#include <stdint.h>

#define AXI_BASE_ADDR  0x40000000  // Replace with actual base address
#define AXI_MAP_SIZE   0x10000

int main() {
    int fd;
    uint32_t *axi_ptr;

    // Open /dev/mem
    fd = open("/dev/mem", O_RDWR | O_SYNC);
    if (fd < 0) {
        // Handle error
        return -1;
    }

    // Map AXI address space
    axi_ptr = (uint32_t *)mmap(NULL, AXI_MAP_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, AXI_BASE_ADDR);
    if (axi_ptr == MAP_FAILED) {
        // Handle error
        close(fd);
        return -1;
    }

    // Write to AXI register
    axi_ptr[0] = 0xABCD1234;

    // Read from AXI register
    uint32_t data = axi_ptr[0];

    // Check if data is correct
    if (data == 0xABCD1234) {
        // Success: Data read matches the data written
    } else {
        // Error handling
    }

    // Clean up
    munmap(axi_ptr, AXI_MAP_SIZE);
    close(fd);

    return 0;
}

```


## References

For further details and discussion, please refer to the conversation available at:  
- [ChatGPT Explain The Flow](https://chatgpt.com/share/98e6e366-a9f5-43ac-96ad-fa0242a90848)

Additional resources:  
- [Tutorial Video 1](https://youtube.com/watch?v=TQkIWdDn0oo)  
- [Tutorial Video 2](https://youtu.be/u7OnhmskSKs?feature=shared)  
- [Tutorial Video 3](https://youtu.be/k4kw1h6XetU?feature=shared)  
- [This Latex Code](https://www.overleaf.com/read/tfjtfbxksftz#472271)