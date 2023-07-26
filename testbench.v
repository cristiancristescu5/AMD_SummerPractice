module top_tb;
    reg inputKey;
    reg validCmd;
    reg rwMem;
    reg [7:0] addr;
    reg [7:0] InA;
    reg [7:0] InB;
    reg [3:0] sel;
    reg configDiv;
    reg [31:0] Din;
    reg reset;
    reg clk;
    wire calcActive;
    wire calcMode;
    wire busy;
    wire DOutValid;
    wire DataOut;
    wire clkTx;

    top1 dut (
        .inputKey(inputKey),
        .validCmd(validCmd),
        .rwMem(rwMem),
        .addr(addr),
        .InA(InA),
        .InB(InB),
        .sel(sel),
        .configDiv(configDiv),
        .Din(Din),
        .reset(reset),
        .clk(clk),
        .calcActive(calcActive),
        .calcMode(calcMode),
        .busy(busy),
        .DOutValid(DOutValid),
        .DataOut(DataOut),
        .clkTx(clkTx)
    );

    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(1);
        inputKey = 0;
        validCmd = 1;
        rwMem = 1;
        addr = 8'h1;
        InA = 8'hff;
        InB = 8'h0;
        sel = 4'h0;
        configDiv = 1;
        Din = 32'h2;
        reset = 1;
      	Din=32'h2;
        clk = 0;
		#10;
      	reset = 0;
      	configDiv = 0;
        #5;
      	configDiv=1;
      	inputKey = 1;
      	#10;
      	configDiv=0;
      	inputKey = 0;
      	#10;
      	inputKey = 1;
      	#10;
      	inputKey = 0;
		#10;
      	inputKey = 0;
      	configDiv =1;	
        #30;
      	rwMem =0;
      	#800;
      #20;
      	$finish;
    end
    always begin
      #5 clk = ~clk;
    end

endmodule
