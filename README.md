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
<h3>Files Index with explanation</h3>
<h4>Top module</h4>
<h5>Verification Files</h5>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/TOP.v">Top module File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/interface.sv">Top module Interface File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/top.svh">UVM Top module File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/goldenmodel.sv">Golden Model File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/goldeninter.sv">Golden Model Interface</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/test.svh">UVM Test package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/env.svh">UVM Environment package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/agent.svh">UVM Agent package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/driver.svh">UVM Driver package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/monitor.svh">UVM Monitor package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/sequencer.svh">UVM Sequencer package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/sequence.svh">UVM Sequence package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/sequence_item.svh">UVM Sequence Item package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/scoreboard.svh">UVM Scoreboard package</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/cvrgcllctr.svh">UVM Coverage Collector package</a></li>
</ul>
</br>
<h4>-Control Unit</h4>
<p>The control unit is responsible for receiving the control word from the decoder and performing based on it whether to activate the sending unit or the receiving unit or even the both units. The sending unit is responsible for adjusting the DAC with the desired power value and checking the validity of the control word. The receiving unit is reponsible for getting data from the buffer unit and transferring it through the AXI port to the PS unit. Moreover, the whole unit is responsible for checking that the whole system haven't reached the maximum number of transferring orders yet.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/Rec_unit.v">Receiving Unit Design File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/SendingUnit.v">Sending Unit Design File</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/curam.v">The RAM connected to the CU output</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/controlUnit.v">Top Module</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/rectb.sv">Receive-block Control Unit Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/TB.sv">Control Unit Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/pack.sv">CU Testbench package</a></li>
</ul>
<br></br>
<h4>-Decoder</h4>
<p>The decoder's role is to receive the control word from the PS and decoding it to the control unit.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/dec.v">Decoder Design</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/dectb.sv">Decoder Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/decgold.sv">Decoder Golden model for Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/decassert.sv">Design Assertions file</a></li>
</ul>
<br></br>
<h4>-Buffer</h4>
<p>The buffer is responsible for processing the data coming from the FIFO through getting rid of spikes through averaging and adding tags to each received sample.</p>
<ul>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/buffer.v">Buffer Design</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/buffer_tb.sv">Buffer Testbench</a></li>
  <li><a href="https://github.com/m7md5303/Ultrasonic-zynq7000-based-system/blob/main/FIFO.sv">FIFO for testing the system</a></li>
</ul>
