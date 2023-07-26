module mux4(
    input wire [31:0]  in1,
    input wire [31:0]  in2,
    input  sel,
    output reg [31:0]  out  
);
    always @(*) begin
    if(!sel) begin
        out <= in1;
    end else begin 
        out <= in2;
    end
    end
endmodule

module mux1_3 #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0]  A,
    input wire [WIDTH-1:0]  B,
    input  sel,
    output reg [WIDTH:0] out
);  
    always @(*)
    if(sel) begin 
         out <= B;
    end else begin 
         out <= A;
    end
endmodule

module mux1_3_0 #(parameter WIDTH = 8)(
    input wire [WIDTH-1:0] A,
    input sel,
    output reg [WIDTH-1:0] out
);
    always @(*)begin
        case(sel)
            0: out<=A;
            1: out<=8'h00;
        endcase

    end
endmodule