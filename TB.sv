// Import the package which contain the constraints and the covergroup.
import pack::*;

module TB ();

                         /*************Variables*************/
      bit clk;
      bit send_en;              // Signal sent to the buffer to enable sending data to the CU.
      bit valid;                // To check the validity of the receiving data by the decoder to work on it by the cu or not.
      bit send_mode;            // To specify the mode of the submodule by the cu to be sender.
      bit receive_mode;         // To specify the mode of the submodule by the cu to be receiver.
      bit increase;             // To increase the power of the DAC.
      bit decrease;             // To decrease the power of the DAC.
      bit on;                   // To enable the process of receive or send .
      bit off;                  // To disable the process of receive or send . 
      bit reset;                // To reset the submodule by the cu.
      bit [7:0] amount;         // To specify the amount which will increased or decreased .
      bit [24:0] data_transfer; // Data coming from the buffer.
      bit [11:0] DAC_out,Do_ex; // Out put data to the DAC to control it's power.    
      bit [24:0]AXI_Out,AXI_ex; // Signal to the AXI to receive data.
      bit no_order,no_order_ex; // Signal carry the number of order which sent by the CU.
      bit sending,sending_ex;   // Flag signal to indicate there is data transfer.
      logic [6:0] read_add;
      logic rd_en;
      logic [24:0] read_data;
                         
                         /************Counter**************/
      int correct_counter = 0;
      int incorrect_counter = 0;
      int i;   

                         /************Taking Object from the Class************/
      CU control_unit_obj=new;
                         /***********Instantiate The CU Module ************/
      ControlUnit CU_Dut (.clk(clk), .rst_n(reset), .send_enB(send_en), .ValidSignal(valid),
       .sending(sending), .sendEnable(send_mode), .rec_en(receive_mode), .increaseSignal(increase),
       .decreaseSignal(decrease), .onSignal(on), .offSignal(off), .AmountSignal(amount), 
       .buf_in(data_transfer), .no_order(no_order), .outputDAC(DAC_out) 
       ,.read_add(read_add),.rd_en(rd_en),.read_data(read_data));

// Start generating the Clock.
initial begin
    clk = 0;
    forever begin
        #1 clk = ~clk;
        control_unit_obj.clk=clk;
    end
end

initial begin
                         /**** Testbench for the CU module ****/
        
        /* First the direct test */        
            
            // Test the reset case when be on.
            reset=0;
            valid=0;
            receive_mode=0;
            send_mode=0;
            increase=0;
            decrease=0;
            on=0;
            off=0;
            amount=0;
            data_transfer=0;
            no_order_ex=1;
            #2;
            check(no_order,no_order_ex);
            AXI_ex=25'h000000;
            check_AXI(CU_Dut.AXI_OUT,AXI_ex);
                /* Pass the data to the covergroup */
                Pass_to_cover;
        
            #20;
            
            reset=1;
            
            #50;

            // Test when no order come signal which can't be start its function.    
            receive_mode=1;
            data_transfer=25'h0ffffff;
            AXI_ex=0;
            check_AXI(CU_Dut.AXI_OUT,AXI_ex);
            
            #50;
                /* Pass the data to the covergroup */
                Pass_to_cover;
            
            // Test the case when no on signal which mean not to work.
            send_mode=1;
            receive_mode=1;
            data_transfer=25'h0ffffff;
            AXI_ex=0;
            check_AXI(CU_Dut.AXI_OUT,AXI_ex);
            
            #50;
                /* Pass the data to the covergroup */
                Pass_to_cover;
            
            // Test the off signal for sending data to DAC.
            send_mode=1;
            receive_mode=1;
            valid=1;
            #2;
            off=1;
            Do_ex=12'h000;
            check_DAC(DAC_out,Do_ex);
            
            #50;
                /* Pass the data to the covergroup */
                Pass_to_cover;
            
            // Test the increasing process inaddition to  sending data.
            send_mode=1;
            receive_mode=1;
            valid=1;
            #2;
            on=1;
            off=0;
            increase=1;
            #2;
            send_mode=0;
            data_transfer=25'hfffffff;
            sending_ex=1;
            #4;
            check(sending,sending_ex);
            AXI_ex=25'hfffffff;
            check_AXI(CU_Dut.AXI_OUT,AXI_ex);
            amount=8'h01;
            Do_ex=12'h010;
            #2;
            check(DAC_out,Do_ex);
            
            #100;
                /* Pass the data to the covergroup */
                Pass_to_cover;
            
            // Test the decreasing process inaddition to  sending data.
            send_mode=1;
            receive_mode=1;
            valid=1;
            #2;
            on=1;
            off=0;
            increase=0;
            decrease=1;
            #2;
            send_mode=0;
            data_transfer=25'hEEEEEEE;
            sending_ex=1;
            check(sending,sending_ex);
            AXI_ex=25'hEEEEEEE;
            check_AXI(CU_Dut.AXI_OUT,AXI_ex);
            amount=8'h01;
            Do_ex=12'h000;
            check_DAC(DAC_out,Do_ex);
            
            #100;
                /* Pass the data to the covergroup */
                Pass_to_cover;

        /* Second the Random test */
            
            for (i=0;i<10000;i++) begin
                assert (control_unit_obj.randomize()) 
                control_unit_obj.clk=clk;
                valid=control_unit_obj.valid;
                reset=control_unit_obj.reset;
                send_mode=control_unit_obj.send_mode;
                receive_mode=control_unit_obj.receive_mode;
                on=control_unit_obj.on;
                off=control_unit_obj.off;
                increase=control_unit_obj.increase;
                decrease=control_unit_obj.decrease;
                amount=control_unit_obj.amount;
                data_transfer=control_unit_obj.data_transfer;
                #4;
                control_unit_obj.send_en=send_en;
                control_unit_obj.AXI_OUT=AXI_Out;
                control_unit_obj.no_order=no_order;
                control_unit_obj.sending=sending;
            end
        /* Display the values of the counters */
        display;

    #2 $stop;
end

                     /********** Monitor **********/

initial begin
    $monitor ("valid=%0d,send_mode=%0d,receive_mode=%0d,send_en=%0d,on=%0d,off=%0d,increase=%0d,decrease=%0d,amount=%0d,DAC_OUT=%0d,no_order=%0d,sending=%0d,AXI_out=%0d",&valid,&send_mode,&receive_mode,&send_en,&on,&off,&increase,&decrease,&amount,&DAC_out,&no_order,&sending,&AXI_Out);
end

                     /********* Tasks **********/  

// Task to perform the self checking.
task check (bit out, bit out_ex);
    #2;
    if (out != out_ex) begin
        $display("%t:there is error in the output value =%0d and the epected is = %0d",$time,&out,&out_ex);
        $stop;
        incorrect_counter<=incorrect_counter+1;
        $display("the incorrect_counter = %0d",incorrect_counter);
    end
    else begin
        correct_counter<=correct_counter+1;
        $display("the correct_counter = %0d",correct_counter);
    end
endtask //check

// Task to check the DAC output.
task check_DAC (bit [11:0] out, bit [11:0] out_ex);
    #2;
    if (out != out_ex) begin
        $display("%t:there is error in the DAC_output value =%0d and the DAC_epected is = %0d",$time,&out,&out_ex);
        $stop;
        incorrect_counter<=incorrect_counter+1;
        $display("the incorrect_counter = %0d",incorrect_counter);
    end
    else begin
        correct_counter<=correct_counter+1;
        $display("the correct_counter = %0d",correct_counter);
    end
endtask //check_DAC

// Task to check the output from the AXI.
task check_AXI (bit [24:0] out, bit [24:0] out_ex);
    #2;
    if (out != out_ex) begin
        $display("%t:there is error in the AXI_output value =%0d and the AXI_epected is = %0d",$time,&out,&out_ex);
        $stop;
        incorrect_counter<=incorrect_counter+1;
        $display("the incorrect_counter = %0d",incorrect_counter);
    end
    else begin
        correct_counter<=correct_counter+1;
        $display("the correct_counter = %0d",correct_counter);
    end
endtask //check_AXI

task Pass_to_cover ();

        control_unit_obj.valid=valid;
        control_unit_obj.reset=reset;
        control_unit_obj.send_mode=send_mode;
        control_unit_obj.receive_mode=receive_mode;
        control_unit_obj.on=on;
        control_unit_obj.off=off;
        control_unit_obj.increase=increase;
        control_unit_obj.decrease=decrease;
        control_unit_obj.amount=amount;
        control_unit_obj.data_transfer=data_transfer;
        control_unit_obj.send_en=send_en;
        control_unit_obj.AXI_OUT=AXI_Out;
        control_unit_obj.no_order=no_order;
        control_unit_obj.sending=sending;

endtask //Pass_to_cover

// Task to display the  Value of Counters. 
task  display ();

    $display("the correct_counter =%0d ", correct_counter);
    $display("the incorrect_counter =%0d ", incorrect_counter);

endtask //display

endmodule