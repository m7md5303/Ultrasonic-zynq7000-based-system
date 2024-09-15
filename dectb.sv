import decpack::*;
module dectb ();
parameter DATA_WIDTH=15;
parameter AMOUNT_WIDTH = 8;
    logic clk;                            // Clock signal
    logic rst_n;                            // Reset signal (active high)
    logic [DATA_WIDTH-1:0] received_data; // Parametrized input from the AXI interface
    logic on,on_gold;
    logic off,off_gold;
    logic increase,increase_gold;
    logic decrease,decrease_gold;
    logic valid,valid_gold;
    logic receive,receive_gold;
    logic send,send_gold;
    logic [AMOUNT_WIDTH-1:0] amount,amount_gold; // Parametrized amount for DAC
    int err_count=0,crrct_count=0;
    //
    Decoder DUT (.*);
    bind Decoder decsva decsvainst (.*);
    //
    decgold Gold(.clk(clk),.rst_n(rst_n),.received_data(received_data),
    .on(on_gold),.off(off_gold),.increase(increase_gold),.decrease(decrease_gold)
    ,.valid(valid_gold),.send(send_gold),.receive(receive_gold),.amount(amount_gold));
    //
    decclass dc =new;
    //
initial begin
    clk=0;
    forever begin
        #5; clk=~clk;
        dc.clk=clk;
    end
end
initial begin
    rst_n=0;
    @(negedge clk);
    checkresult;
    repeat(3030)begin
        assert (dc.randomize());
        rst_n=dc.rst_n;
        received_data=dc.received_data;
        @(negedge clk);
        checkresult;
    end
    $display("errors are %d while corrects are %d",err_count,crrct_count);
    $stop;
end
task checkresult;
    if(valid!=valid_gold)begin
        err_count++;
        $display("valid error at %t",$time);
    end
    else if(valid)begin
        if(amount!=amount_gold)begin
        err_count++;
        $display("amount error at %t",$time);
    end
    else if((on!=on_gold)||(off!=off_gold)||(increase!=increase_gold)||(decrease!=decrease_gold)||(send!=send_gold)||(receive!=receive_gold))begin
        err_count++;
        $display("function dissimilarities at %t",$time);
    end
    end
    else begin
        crrct_count++;
    end
endtask //checkresult
endmodule