module ControlRWFlow(
    input wire validCmd,
    input wire rw,
    input wire reset,
    input wire clk,
    input wire txDone,
    input wire active,
    input wire mode,
    output reg accessMem,
    output reg rwMem,
    output reg sampleData,
    output reg txData,
    output reg busy
);
localparam idle = 9'b000000001;    
localparam r1   = 9'b000000010;    
localparam r2   = 9'b000000100;
localparam r3   = 9'b000001000;
localparam r4   = 9'b000010000;
localparam w    = 9'b000100000;
localparam t1   = 9'b001000000;
localparam t2   = 9'b010000000;
localparam t3   = 9'b100000000;

reg [8:0] sc;
reg [8:0] sv;

  always @(sc, validCmd, rw, active, mode,busy, sampleData ,txDone) begin 
    case (sc)
        idle:begin 
            if(validCmd && active && mode && !rw)begin 
                sv = r1;
            end
            if(validCmd && active && mode && rw)begin 
                sv = w;
            end
            if(validCmd && active && !mode)begin 
                sv = t1;
            end
            if(!validCmd)begin 
                sc = idle;
            end
        end
        r1:begin 
            if(active && mode && !txDone)begin 
                sv = r2;
            end else begin 
              	sv = idle;
            end
        end
        r2:begin 
          if(active && mode && (txDone == 0))begin 
                sv = r3;
            end else begin 
              	sv = idle;
            end
        end
        r3:begin 
          $display("r3");
          if(active && (txDone==0))begin 
                sv = r4;
            end else begin 
              	sv = idle;
            end
        end
        r4:begin 
            if(active && !txDone)begin 
                sv = r4;
            end
            if(active && txDone)begin 
                sv = idle;
            end
        end
        w: begin //cu ce raman in starea asta?
            if(!busy)begin
                sv = idle;
            end
          	if(validCmd && active && mode && rw)begin 
                sv = w;
            end
        end
        t1: begin 
            if(active && !mode && !txDone)begin 
                sv = t2;
            end else begin 
              	sv = idle;
            end
        end
        t2: begin 
            if(active && !txDone)begin
                sv = t3;
            end else begin 
              	sv = idle;
            end 
        end
        t3: begin 
            if(active && !txDone)begin 
                sv = t3;
            end else if(txDone) begin
                sv = idle;  
            end else begin 
              	sv = idle;
            end
        end
        default: begin 
            sv = idle;
        end
    endcase
end

always @(posedge clk, posedge reset)begin 
    if(reset)begin 
        accessMem <=0;
        rwMem <=0;
        sampleData <=0;
        txData<=0;
        busy <=0;
      	sc<=idle;
      	sv<=9'bx;
    end else begin 
      $display("%b", sc);
        sc <= sv;
    end
end

always @(sc)begin 
    case(sc)
        idle:begin 
            accessMem <=0;
            rwMem <=0;
            sampleData <=0;
            txData<=0;
            busy <=0;
        end
        r1:begin 
            accessMem<=1;
            rwMem<=0;
            busy <=1;
        end
        r2:begin 
          accessMem<=0;
            sampleData<=1;
        end
        r3:begin 
          $display("r3");
            sampleData <=0;
            txData <=1;
        end
        r4:begin
          if(txDone)begin 
            txData<=0;
          end
        end
        w:begin 
            accessMem<=1;
            rwMem<=1;
            busy<=1;
          
        end
        t1:begin
           busy<=1;
           sampleData<=1;
        end
        t2:begin
          sampleData<=0;
           txData<=1; 
        end
        t3:begin
            
        end
    endcase
end

endmodule