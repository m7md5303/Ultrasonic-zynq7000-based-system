package sonar_sequence_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import sonar_sequence_item_pkg::*;
    parameter DATA_WIDTH = 32;
    parameter AMOUNT_WIDTH = 8;
    //reset sequence
    class sonar_reset_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_reset_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_reset_sequence");
            super.new(name);
        endfunction

           task body();
           seq_item = sonar_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=0;
           seq_item.received_data=$random;
           finish_item(seq_item);
        endtask
    endclass
// Bits assignment within the received_data word
// Bit 0: On
// Bit 1: Off
// Bit 2: Increase
// Bit 3: Decrease
// Bit 4: Receive
// Bit 5: Send
// Bit 6: Valid
// Bits [DATA_WIDTH-1:6]: Amount (remaining bits)

//sendsequence   
    class sonar_send_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_send_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_send_sequence");
            super.new(name);
        endfunction

           task body();
           seq_item = sonar_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.rst_n.rand_mode(0);
           assert(seq_item.randomize());
           seq_item.received_data[0] = 1;
           seq_item.received_data[1] = 0;
           seq_item.received_data[2] = !seq_item.received_data[3];
           seq_item.received_data[4] = 0;
           seq_item.received_data[5] = 1;
           seq_item.received_data[6] = 1;
           finish_item(seq_item);
        endtask
    endclass


        //receive sequence   
    class sonar_receive_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_receive_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_receive_sequence");
            super.new(name);
        endfunction

           task body();
           seq_item = sonar_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.rst_n.rand_mode(0);
           assert(seq_item.randomize());
           seq_item.received_data[0] = 1;
           seq_item.received_data[1] = 0;
           seq_item.received_data[2] = !seq_item.received_data[3];
           seq_item.received_data[4] = 1;
           seq_item.received_data[5] = 0;
           seq_item.received_data[6] = 1;
           finish_item(seq_item);
        endtask
    endclass


            //increase sequence   
    class sonar_increase_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_increase_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_increase_sequence");
            super.new(name);
        endfunction

           task body();
           seq_item = sonar_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.rst_n.rand_mode(0);
           assert(seq_item.randomize());
           seq_item.received_data[0] = 1;
           seq_item.received_data[1] = 0;
           seq_item.received_data[2] = 1;
           seq_item.received_data[3] = 0;
           seq_item.received_data[4] = 0;
           seq_item.received_data[5] = 1;
           seq_item.received_data[6] = 1;
           finish_item(seq_item);
        endtask
    endclass

                //decrease sequence   
    class sonar_decrease_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_decrease_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_decrease_sequence");
            super.new(name);
        endfunction

           task body();
           seq_item = sonar_sequence_item::type_id::create("seq_item");
           start_item(seq_item);
           seq_item.rst_n=1;
           seq_item.rst_n.rand_mode(0);
           assert(seq_item.randomize());
           seq_item.received_data[0] = 1;
           seq_item.received_data[1] = 0;
           seq_item.received_data[2] = 0;
           seq_item.received_data[3] = 1;
           seq_item.received_data[4] = 0;
           seq_item.received_data[5] = 1;
           seq_item.received_data[6] = 1;
           finish_item(seq_item);
        endtask
    endclass

        class sonar_rand_all_sequence extends uvm_sequence #(sonar_sequence_item);
        `uvm_object_utils (sonar_rand_all_sequence)
        sonar_sequence_item seq_item;

        function new(string name = "sonar_rand_all_sequence");
            super.new(name);
        endfunction

        task body();
        repeat(10500)begin
        seq_item = sonar_sequence_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rand_mode(1);
        assert(seq_item.randomize());
        finish_item(seq_item);
        end
        endtask
        endclass

endpackage