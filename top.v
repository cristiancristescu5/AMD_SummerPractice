`include "alu.v"
`include "controller.v"
`include "dec.v"
`include "freqDividerFinal.v"
`include "memory.v"
`include "mux.v"
`include "serialTransceiver1b.v"
`include "concatenator.v"

module top1 #(parameter width = 8)(
    input wire inputKey,
    input wire validCmd,
    input wire rwMem,
    input wire [7:0] addr,
    input wire [width-1:0] InA,
    input wire [width-1:0] InB,
    input wire [3:0] sel,
    input wire configDiv,
    input wire [31:0] Din,
    input wire reset,
    input wire clk,
    output wire calcActive,
    output wire calcMode, //
    output wire busy, //controller
    output wire DOutValid,//busy st
    output wire DataOut,//dout st
    output wire clkTx // fd
);
    wire [width-1:0] outA;//mux1
    wire [width-1:0] outB;//mux2
    wire [3:0] selTmp;//mux2
    wire [width-1:0] aluOut;//alu
    wire [3:0] aluFlags;//alu
    wire resetTmp;//reset 
    wire rwTmp;//
    wire activeTmp;//controller
    wire modeTmp;
    wire txDoneTmp;
    wire accessMemTmp;
    wire rwMemTmp;
    wire sampleDataTmp;
    wire txDataTmp;
    wire [31:0] concatOutTmp;
    wire [31:0] memOut;
    wire [31:0] mux4Out;
    wire clkTxTmp;
  	wire busyTmp;
    assign calcMode = modeTmp;
    assign calcActive = activeTmp;
    assign clkTx = clkTxTmp;
	assign busy = busyTmp;
    decInputKey decDut(.reset(reset),
                    .clk(clk), 
                    .inputKey(inputKey),
                    .validCmd(validCmd),
                    .active(activeTmp),
                    .mode(modeTmp));
    assign rwTmp = (activeTmp & rwMem);
//   	and(rwTmp, activeTmp, rwMem);
    assign resetTmp = ((~activeTmp) & reset);

    mux1_3_0 mux1Dut(.A(InA),
                    .sel(resetTmp),
                    .out(outA));

    mux1_3_0 mux2Dut(.A(InB),
                    .sel(resetTmp),
                    .out(outB));

    mux1_3_0 #(.WIDTH(4)) mux3Dut (.A(sel),
                    .sel(resetTmp),
                    .out(selTmp));
    
    alu aluDut(.a(outA),
            .b(outB),
            .op(selTmp),
            .out(aluOut),
            .flag(aluFlags));

    concatenator1 concatenatorDut(.a(outA),
                            .b(outB),
                            .c(aluOut),
                            .d(selTmp),
                            .e(aluFlags),
                            .out(concatOutTmp));


    ControlRWFlow controllerDut(.validCmd(validCmd),
                            .rw(rwTmp),
                            .reset(reset),
                            .clk(clk),
                            .txDone(txDoneTmp),
                            .active(activeTmp),
                            .mode(modeTmp),
                            .accessMem(accessMemTmp),
                            .rwMem(rwMemTmp),
                            .sampleData(sampleDataTmp),
                            .txData(txDataTmp),
                                .busy(busyTmp));
    memory memoryDut(.valid(accessMemTmp),
                                .rw(rwMemTmp),
                                .reset(resetTmp),
                                .clk(clk),
                                .din(concatOutTmp),
                                .addr(addr),
                                .dout(memOut));
    mux4 mux4Dut(.in1(concatOutTmp),
                .in2(memOut),
                .sel(modeTmp),
                .out(mux4Out));
    frequencyDivider freqDividerDut(.clk(clk),
                                .reset(resetTmp),
                                .enable(activeTmp),
                                .configDiv(configDiv),
                                .din(Din),
                                .clkOut(clkTxTmp));
    serialTransceiver serialTransceiverDut(.dataIn(mux4Out),
                                        .sample(sampleDataTmp),
                                        .startTx(txDataTmp),
                                        .clk(clk),
                                        .clkTx(clkTxTmp),
                                        .reset(resetTmp),
                                        .txDone(txDoneTmp),
                                        .txBusy(DOutValid),
                                        .dout(DataOut));
endmodule