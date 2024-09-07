# Setting Up a Linux Environment for a Python Program on Zynq Z702

## 1. Choose Between Yocto and PetaLinux
Both Yocto and PetaLinux are suitable for building Linux environments for embedded systems, but they have different use cases:

- **Yocto**: A more flexible and powerful build system, suitable if you need extensive customization and control over your build process.
- **PetaLinux**: A simplified build system tailored for Xilinx devices, making it easier to use for standard setups.

Given that you're working with a Zynq Z7020, PetaLinux might be the more straightforward choice unless you need specific customizations that Yocto offers.

## 2. Set Up Your Development Environment
- **Install PetaLinux**: Follow the [PetaLinux installation guide](https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1144-petalinux-tools-reference-guide.pdf) to set up the PetaLinux tools on your development machine.
- **Create a PetaLinux Project**: Use the `petalinux-create` command to create a new project for your Zynq Z7020.

## 3. Configure the Linux Kernel and Root Filesystem
- **Configure the Kernel**: Use `petalinux-config -c kernel` to configure the Linux kernel. Ensure that the necessary drivers, including the AXI DMA driver from the GitHub link you provided, are enabled.
- **Configure the Root Filesystem**: Use `petalinux-config -c rootfs` to add any additional packages or libraries needed for your Python program.

## 4. Build the PetaLinux Project
- **Build the Project**: Run `petalinux-build` to compile the kernel, root filesystem, and other components.
- **Generate Boot Files**: Use `petalinux-package --boot` to create the boot files (BOOT.BIN, image.ub) needed to boot your Zynq device.

## 5. Deploy and Test
- **Deploy to the Zynq Device**: Copy the generated boot files to an SD card or other boot medium and boot your Zynq device.
- **Test the Environment**: Ensure that the Linux environment boots correctly and that your Python program runs as expected.

## 6. Set Up Python Virtual Environment
- **Create a Virtual Environment**: On your Zynq device, create a Python virtual environment to manage dependencies:
   ```bash
   python3 -m venv myenv
   source myenv/bin/activate 
   ```
   Install Dependencies: Use pip to install any required Python packages within the virtual environment.

## 7. Integrate the AXI DMA Driver
- **Clone the Repository**: Clone the GitHub repository for the AXI DMA driver:
    ```bash
      git clone https://github.com/bperez77/xilinx_axidma.git
    ```

-  **Build and Install the Driver**: Follow the instructions in the repository to build and install the driver on your Zynq device.

## 8. Run Your Python Program
- **Execute Your Program**: With the environment set up and the driver installed, you can now run your Python program and ensure it interacts correctly with the AXI DMA driver.


# Example Project: Data Transfer from Hardware to Python Program

## Objective
Create a project where data is transferred from a hardware sensor to a Python program running on the Zynq device.

## Steps

1. **Hardware Setup:** 
   - Connect a sensor (e.g., temperature sensor) to the Zynq device via an AXI interface.

2. **Driver Integration:** 
   - Use the AXI DMA driver to facilitate data transfer between the sensor and the Zynq device.

# Python Code Example

```python
import os
import mmap

# Open the AXI DMA device file
fd = os.open("/dev/axidma0", os.O_RDWR | os.O_SYNC)

# Memory-map the AXI DMA device
dma = mmap.mmap(fd, length=4096, flags=mmap.MAP_SHARED, prot=mmap.PROT_READ | mmap.PROT_WRITE, offset=0)

# Read data from the sensor
data = dma.read(4)  # Read 4 bytes of data

# Convert the data to an integer
sensor_value = int.from_bytes(data, byteorder='little')

print(f"Sensor Value: {sensor_value}")

# Close the memory-mapped file
dma.close()
os.close(fd)

```
This example demonstrates how to read data from a hardware sensor using the AXI DMA driver and process it in a Python program running on the Zynq device. 