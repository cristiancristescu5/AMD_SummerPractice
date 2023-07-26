module frequencyDivider(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire configDiv,
    input wire [31:0] din,
    output wire clkOut
);
    reg [31:0] regIn;
    reg clkOutTemp;
    assign clkOut = clkOutTemp;
    reg [31:0] divisor;
    reg [31:0] counter;
  always @(negedge clk) begin
    if(enable && !reset && regIn == 32'b0)begin 
      clkOutTemp<=clk;
    end 
  end
  always @(posedge clk or posedge reset) begin 
        if(reset) begin 
            regIn<=32'b0;
            clkOutTemp<=0;
            counter <= 32'b0;
        end else begin
            case(enable) 
                1'b0:begin 
                    clkOutTemp<=0;
                    if(!configDiv)begin
                      divisor <= regIn>>1;
                      counter<=32'b0;
                    end else begin 
                        regIn<=din;
                    end
                end
                1'b1:begin
                  if(regIn != 32'b0)begin
                    if(counter == (regIn-1))begin 
                        counter<=32'b0;
                    end else begin 
                        counter <= counter + 1;
                     end
                    	clkOutTemp <= (counter < divisor);
                  end else begin
                    	clkOutTemp <= clk;
                  end
                end
            endcase
        end
  end
    
endmodule