package pack;

class CU;

         bit clk;
                    /***********Used-Arrays************/
         logic arr  [] = {16,32,64};
         logic data [] = {100,200,300};
                    /*********Cover-Variables**********/
         bit send_en;
         bit[24:0] AXI_OUT;
         bit no_order;
         bit sending;
                    /*********Constrained-Variables**********/
    rand bit valid;               // to check the validity of the receiving data by the decoder to work on it by the cu or not.
    rand bit send_mode;           // to specify the mode of the submodule by the cu to be sender.
    rand bit receive_mode;        // to specify the mode of the submodule by the cu to be receiver.
    rand bit increase;            // to increase the power of the DAC.
    rand bit decrease;            // to decrease the power of the DAC.
    rand bit on;                  // to enable the process of receive or send .
    rand bit off;                 // to disable the process of receive or send . 
    rand bit reset;               // to reset the submodule by the cu.
    rand bit [7:0] amount;        // to specify the amount which will increased or decreased .
    rand bit [24:0] data_transfer; // data coming from the buffer.
                
                    /*********Constraints**********/
    constraint rst {reset dist {0:=50,1:=50};}               
    constraint vld {valid dist {1:=50,0:=50};}
    constraint inc {increase dist {1:=50,0:=50};}
    constraint dec {decrease dist {1:=50,0:=50};}
    constraint onn {on dist {1:=50,0:=50};}
    constraint of  {off dist {1:=50,0:=50};}
    constraint mod {receive_mode!=send_mode;}
    constraint amo {amount inside {arr};}
    constraint dat {data_transfer inside {data};}
    constraint options 
    {
        if (increase==0) 
            decrease==1;
        else 
            decrease==0;

        if (on==0) 
            off==1;
        else 
            off==0;
    }

    covergroup CVP @ (posedge clk);

        coverpoint valid iff (reset);
        coverpoint send_mode iff (reset);
        coverpoint receive_mode iff (reset);
        coverpoint increase iff (reset);
        coverpoint decrease iff (reset);
        coverpoint on iff (reset);
        coverpoint off iff (reset);
        coverpoint send_en iff (reset);
        coverpoint AXI_OUT iff (reset);
        coverpoint no_order iff (reset);
        coverpoint sending iff (reset);
    
    endgroup

    function new;
      CVP=new;
    endfunction

endclass    

endpackage