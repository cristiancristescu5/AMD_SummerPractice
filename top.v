`include "alu.v"
`include "controller.v"
`include "dec.v"
`include "freqDividerFinal.v"
`include "memory.v"
`include "mux.v"
`include "serialTransceiver1b.v"
`include "concatenator.v"

module top #(parameter width = 8)(
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
    wire [width-1:0] outA;
    wire [width-1:0] outB;
    wire [3:0] selTmp;
    wire [width-1:0] aluOut;
    wire [3:0] aluFlags;
    wire resetTmp;
    wire rwTmp;
    wire activeTmp;
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
    assign calcMode = modeTmp;
    assign calcActive = activeTmp;
    assign clkTx = clkTxTmp;

    decInputKey dec(.reset(reset),
                    .clk(clk), 
                    .inputKey(inputKey),
                    .validCmd(validCmd),
                    .active(activeTmp),
                    .mode(modeTmp));
    assign rwTmp = (activeTmp & rwMem);
    assign resetTmp = ((~activeTmp) & reset);

    mux1_3_0 mux1(.A(InA),
                    .sel(resetTmp),
                    .out(outA));

    mux1_3_0 mux2(.A(InB),
                    .sel(resetTmp),
                    .out(outB));

    mux1_3_0 #(.WIDTH(4)) mux3 (.A(sel),
                    .sel(resetTmp),
                    .out(selTmp));
    
    alu alu(.a(outA),
            .b(outB),
            .op(selTmp),
            .out(aluOut),
            .flag(aluFlags));

    concatenator concatenator(.a(outA),
                            .b(outB),
                            .c(aluOut),
                            .d(selTmp),
                            .e(aluFlags),
                            .out(concatOutTmp));


    ControlRWFlow controller(.validCmd(validCmd),
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
                            .busy(busy));

    memory #(.WIDTH(255)) memory(.valid(accessMemTmp),
                                .rw(rwMemTmp),
                                .reset(resetTmp),
                                .clk(clk),
                                .din(concatOutTmp),
                                .addr(addr),
                                .dout(memOut));
    mux4 mux4(.in1(concatOutTmp),
                .in2(memOut),
                .sel(modeTmp),
                .out(mux4Out));
    frequencyDivider freqDivider(.clk(clk),
                                .reset(resetTmp),
                                .enable(activeTmp),
                                .configDiv(configDiv),
                                .din(Din),
                                .clkOut(clkTxTmp));
    serialTransceiver serialTransceiver(.dataIn(mux4Out),
                                        .sample(sampleDataTmp),
                                        .startTx(txDataTmp),
                                        .clk(clk),
                                        .clkTx(clkTxTmp),
                                        .reset(resetTmp),
                                        .txDone(txDoneTmp),
                                        .txBusy(DOutValid),
                                        .dout(DataOut));
endmodule




