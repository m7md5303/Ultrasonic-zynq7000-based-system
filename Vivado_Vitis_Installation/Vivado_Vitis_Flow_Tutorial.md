# Vivado Tutorial

## Table of Contents
- [Vivado Installation](#vivado-installation)
- [Vivado Workflow](#vivado-workflow)

## Vivado Installation

We encountered problems downloading Vivado due to license errors, so we created a workaround.  
Download Vivado from this link: **[LINK](https://getintopc.com/softwares/design/xilinx-vivado-design-suite-2018-free-download/)**

## Vivado Workflow

1. **Create a new RTL project.**  
   ![Creating a new RTL project](images/Creating_a_new_RTL_project.png)
   
2. **Choose our board**, which is the ZYNQ-7 ZC702 Evaluation Board.

3. **Create a Block Design** (found in the Flow Navigator section under the IP Integrator category).  
   ![Creating a Block Design](images/Creating_a_Block_Design.png)

4. **In the Block Design section,** within the Diagram area, add a Zynq-7 Processing System.  
   ![Adding a Zynq-7 Processing System](images/Adding_a_Zynq_7_Processing_System.png)

5. **Click on "Run Block Automation"** (found as a hyperlink in the same area of the board diagram), and press Next.  
   ![Running Block Automation](images/Running_Block_Automation.png)

6. **Press on Validate.** You will see an error since we did not configure the `M_AXI_GP0_ACLK` clock. Connect it to `FCLK_CLK0` for now, then validate again. The validation should be successful.  
   ![Validation Error](images/Validation_Error.png)  
   ![Validation Success](images/Validation_Success.png)

7. **Right-click on your design** under the Design Sources section, select "Create HDL Wrapper," and press OK.  
   ![Creating HDL Wrapper](images/Creating_HDL_Wrapper.png)

8. **Click on your design wrapper** to view the Verilog code.

9. **From the Program and Debug category** under the Flow Navigator section, click on "Generate Bitstream" and press OK until the generation is complete.  
   ![Generating Bitstream - Step 3](images/Generating_Bitstream.png)

10. **Export the hardware** from the "File" menu in the top bar, check the "Include Bitstream" option, and press Enter.  
    ![Export Hardware - Step 1](images/Export_Hardware.png)  
    ![Export Hardware - Step 2](images/Export_Hardware_step2.png)

11. **Launch SDK** from the "File" menu in the top bar.  
    ![Launching SDK](images/Launching_SDK.png)

12. **Eclipse will open** containing your SDK, ready for editing.  
    ![Eclipse Open with SDK](images/Eclipse_Open_with_SDK.png)

13. **From the "File" menu,** choose "Create New Application Project."  
    ![Creating New Application Project](images/Creating_New_Application_Project.png)

14. **Name the project,** choose the OS as "standalone" for now, and press Next.  
    ![Project Settings](images/Project_Settings.png)

15. **Choose "Hello World"** in C from the available templates.  
    ![Choosing "Hello World" Template](images/Choosing_Hello_World_Template.png)

16. **The project will build.**

17. **If you encounter the error** "The application was unable to start correctly (0xc0000142)," like we did, uninstall WinAVR and rebuild the project.  
    ![Application Error](images/Application_Error.png)  
    ![Uninstalling WinAVR](images/Uninstalling_WinAVR.png)

18. **It should build correctly now.** If you encounter any other errors, congratulations, you have faced a problem we didn't!  
    ![Successful Build](images/Successful_Build.png)

