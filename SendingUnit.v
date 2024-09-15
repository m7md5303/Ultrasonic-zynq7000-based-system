module SendingUnit (clk,rst_n,order_full,sendEnable,ValidSignal,AmountSignal,increaseSignal,decreaseSignal,onSignal,offSignal,outputDAC,order);
   input clk,rst_n,order_full,sendEnable,ValidSignal,increaseSignal,decreaseSignal,onSignal,offSignal;
   input  [7:0] AmountSignal;
   output reg [11:0]outputDAC;
   output reg order;
   reg flag=0;
   always @(posedge clk or negedge rst_n) begin
     if (~rst_n)begin
         outputDAC=0;
         order<=0;
        end
     else if (sendEnable && ValidSignal && ~order_full) begin
          // When sending is enabled and the data is valid
          if (onSignal && ~offSignal) begin
            // Control DAC only when onSignal is active and offSignal is not
               order<=1;
              if (increaseSignal && ~decreaseSignal) begin
                  // Increase DAC output by the value of AmountSignal*16
                  outputDAC <= outputDAC + AmountSignal*16;
              end
              else if (decreaseSignal && ~increaseSignal) begin
                  // Decrease DAC output by the value of AmountSignal*16
                  outputDAC <= outputDAC - AmountSignal*16;
              end
              else begin
                flag=1;
                order<=0;
              end
           end 
          else if (offSignal) begin
               // When offSignal is active, set DAC to zero
             outputDAC <= 12'b0;
           end
           else begin
             flag=1;
           end
      end
   end
endmodule
