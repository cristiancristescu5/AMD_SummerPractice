module decInputKey(
    input wire reset,
    input wire clk,
    input wire inputKey,
    input wire validCmd,
    output reg active,
    output reg mode
);
    localparam s0 = 7'b0000001;
    localparam s1 = 7'b0000010;
    localparam s2 = 7'b0000100;
    localparam s3 = 7'b0001000;
    localparam s4 = 7'b0010000;
    localparam s5 = 7'b0100000;
    localparam s6 = 7'b1000000;

    reg [6:0] sc;
    reg [6:0] sv;
    always @(posedge clk, posedge reset) begin 
        if(reset)begin
            mode<=0;
            active<=0;
            sc<=s0;
            sv<=7'hx;
        end else begin 
            if(validCmd)begin 
                sc<=sv;
            end
        end 
    end
    always @(sc or inputKey) begin
        case(sc) 
            s0: begin 
                if(inputKey) begin 
                    sv = s1;
                end else begin 
                    sv = s0;
                    end
            end
            s1: begin 
                if(!inputKey) begin 
                    sv =s2;
                end else begin 
                    sv =s0;
                    end
            end
            s2: begin 
                if(inputKey) begin 
                    sv =s3;
                end else begin 
                    sv =s0; 
                    end
            end 
            s3: begin 
                if(!inputKey) begin 
                    sv =s4;
                end else begin 
                    sv =s0;
                end
            end
            s4: begin 
                if(inputKey) begin 
                    sv =s6;
                end else begin 
                    sv =s5;
                end
            end
            s5:begin
                if(inputKey) begin 
                    sv =s6;
                end else begin 
                    sv =s5;
                end
            end
            s6:begin
                if(!inputKey)begin
                    sv =s5;
                end else begin 
                    sv =s6;
                end
            end
        endcase
    end

    always @(sc) begin
        case(sc)
            s0: begin 
                active<=0;
                mode<=0;
            end
            s1: begin 
                active<=0;
                mode<=0;
            end
            s2: begin 
                active<=0;
                mode<=0;
            end
            s3: begin 
                active<=0;
                mode<=0;
            end
            s4: begin 
                active<=0;
                mode<=0;
            end
            s5: begin 
                active<=1;
                mode<=0;
            end
            s6: begin 
                active<=1;
                mode<=1;
            end
        endcase

    end

endmodule