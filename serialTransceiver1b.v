// Code your design here
module serialTransceiver #(parameter width = 32)(
    input wire [width-1:0] dataIn,
    input wire sample,
    input wire startTx,
    input wire clk,
    input wire clkTx,
    input wire reset,
    output reg txDone,
    output reg txBusy,
    output reg dout
);
    reg [width-1:0] memory;
    reg start;
    reg [5:0] count;
    reg [5:0] size;
    reg [5:0] i;
    

    always @(posedge clk, posedge reset)begin
        if(reset)begin 
            txBusy<=0;
            memory<=0;
            // dout<=0;
            start<=0;
        end else begin 
            if(sample && !startTx)begin
                memory<=dataIn;
                count<=width-1;
              	txDone<=0;
            end
        end
    end
    always @(posedge clkTx, posedge reset)begin 
        if(reset)begin 
            txBusy<=0;
            memory<=0;
            dout<=0;
            start<=0;
            txDone <=0;
        end else begin 
            if(startTx && !sample) begin 
                start <=1'b1;
                txBusy<=1;
            end
            if(start && !sample)begin 
              if(count >=6'b0 && count != 6'h3f)begin
                  $display("%h", count);
                    dout <= memory[count];
                    count <= count-1;
                end
              if(count == 6'h3f) begin 
                    start <=0;
                	dout<=0;
                    txBusy <=0;
                    txDone<=1;
                end
            end
          if(txDone)begin
            txDone<=0;
          end
        end
    end
endmodule