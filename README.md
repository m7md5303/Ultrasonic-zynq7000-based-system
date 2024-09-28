# Ultrasonic-zynq7000-based-system
A shared repository between Software, Embedded and FPGA teams to handle sending and receiving ultrasonic waves from the appropriate transducers. The project is based on Xilinix Zynq7000 board.
<h1>FPGA Sector</h1>
<br/>
<h3>System Explanation</h3>
<br/>
<p>
The FPGA block in this system is reponsible for bridging the gap between the PS and the transducer. It aims to transfer the order coming from the PS which comes firstly from the GUI to the transducer. The Block is also responsible for getting rid of the spikes in the received data and setting tags for each received sample along with sending it back to the PS.
</p>
</br>
</br>
<h3>Files Index with explanation</h3>
<h4>-Control Unit</h4>
<p>The control unit is responsible for receiving the control word from the decoder and performing based on it whether to activate the sending unit or the receiving unit or even the both units. The sending unit is responsible for adjusting the DAC with the desired power value and checking the validity of the control word. The receiving unit is reponsible for getting data from the buffer unit and transferring it through the AXI port to the PS unit. Moreover, the whole unit is responsible for checking that the whole system haven't reached the maximum number of transferring orders yet.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/Rec_unit.v">Receiving Unit Design File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/SendingUnit.v">Sending Unit Design File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/curam.v">The RAM connected to the CU output</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/controlUnit.v">Top Module</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/TB.sv">Control Unit Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/pack.sv">CU Testbench package</a></li>
</ul>
<br></br>
<br></br>
<h4>-Decoder</h4>
<p>The decoder's role is to receive the control word from the PS and decoding it to the control unit.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/dec.v">Decoder Design</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/decassert.sv">Design Assertions file</a></li>
</ul>
<br></br>
<br></br>
<h4>-Buffer</h4>
<p>The buffer is responsible for processing the data coming from the FIFO through getting rid of spikes through averaging and adding tags to each received sample.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/FPGA/buffer.v">Buffer Design</a></li>
</ul>
