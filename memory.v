module memory #(parameter WIDTH = 8, parameter DinLength = 32)(
    input wire valid,
    input wire rw,
    input wire reset,
    input wire clk,
    input wire [DinLength-1:0] din,
    input wire [7:0] addr,
    output reg [DinLength-1:0] dout
);
    reg [3:0] i;
    reg [DinLength-1:0] memory [WIDTH-1 : 0];
    always @(posedge clk, posedge reset)begin 
        if(reset) begin 
            for( i = 0 ; i < WIDTH ; i = i+1) begin
                memory[i] = 0;
            end
            dout<=0;
        end
        if(!reset)begin 
            case(valid)
                1'b1:begin 
                     case(rw)
                        1'b1:begin 
                            if(addr<WIDTH)begin 
                                memory[addr] <=din;
                              
                             end
                            end
                        1'b0: begin 
                            if(addr<WIDTH)begin 
                                dout<=memory[addr];
                            end
                        end
                     endcase
                    end
                1'b0:begin 

                end
            endcase
        end
    end


endmodule