package decpack;
parameter DATA_WIDTH = 15;
class decclass;
bit clk;
rand logic rst_n;
rand logic [DATA_WIDTH-1:0] received_data;





    //constraint blocks
    constraint reset {
        rst_n dist{0:=5 , 1:=95};
    }
    constraint onoff {
        received_data [1:0] dist{2:=10 , 1:=90};
    }
    constraint sendrec {
        received_data [5:4] dist{3:=40 , 2:=25 , 1:=25 , 0:=10};
    }
    constraint valid {
        received_data [6] dist{0:=20 , 1:=80};
    }

    covergroup  deccvrg @(posedge clk);
//coverpoint for reset signal
    resetcp: coverpoint rst_n{
	bins active={0};
	bins inactive={1};
}   
//coverpoint for valid signal
    validcp: coverpoint received_data[6]{
	bins active={1};
	bins inactive={0};
}
//coverpoint for the received input bits but the valid signal
    control_inp_cp: coverpoint received_data[6:0];
//coverpoint for the amount signal
    amount_in: coverpoint received_data[DATA_WIDTH-1:7];
//coverpoint for the increase&decrease signals
    incdec: coverpoint received_data[3:2];
//coverpoint for the send&receive modes signal
    sendrec: coverpoint received_data[5:4];
//crossing coverage for reset signal with other inputs
    crossingrst: cross resetcp , control_inp_cp{
        bins reseted = binsof (resetcp.active) && binsof(control_inp_cp);
        bins unreseted = binsof (resetcp.inactive) && binsof(control_inp_cp);
    }
//crossing coverage for valid signal with other inputs
    crossingvalid: cross validcp , control_inp_cp{
        bins valid_in = binsof (validcp.active) && binsof(control_inp_cp);
        bins invalid_in = binsof (validcp.inactive) && binsof(control_inp_cp);
    }
        endgroup














     //constructor
    function new();
       deccvrg=new;
    endfunction //new()


endclass //decclass



    
endpackage