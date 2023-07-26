module alu(
    input  wire [7:0]  a,
    input wire [7:0]  b,
    input wire [3:0]  op,
    output reg [7:0]  out,
    output reg [3:0]  flag
);
	
    always @(*) begin   
      	flag<=0000;
        case(op)
            4'h0:begin
              out<=a+b;
              flag[1] <= (a[7] & b[7]) | (a[7] & ~out[7]) | (b[7] & ~out[7]);
            end
            4'h1: begin
              if(a<b)begin
                   flag[3]<=1;
                 end
                    out <= a-b;
              
             end
            4'h2: begin
                 if(a>8'hf && b>8'hf)begin
                   flag[2]<=1;  
                end
                out <= a*b;
            end
            4'h3: begin 
                 if(a<b) begin 
                   flag[3] <=1;
                 end
                 out <= a/b;
            end
            4'h4 : begin 
                out<= a<<b;
            end
            4'h5:begin 
                out<= a>>b;
            end

            4'h6:begin
                out<= a & b;
            end
            4'h7:begin 
                out<= a | b;
            end
            4'h8:begin 
                out<=a^b; 
            end
            4'h9:begin
                out<=a ~^ b;
            end
            4'ha:begin 
                out<= ~(a & b);
            end
            4'hb:begin 
                out<=~(a | b);
            end
            default: begin
                out<=8'h00;
                flag<=0000;
            end
        endcase
         if(out == 0 && op <= 4'hb) begin 
           flag[0] <=1;   
         end
    end

endmodule