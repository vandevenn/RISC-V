`timescale 1ns / 1ps

module RV32I(
        input clk,
        input reset,
        //Bus Signal
        output [31:0] address,
        output [31:0] WriteData,
        input [31:0] readData,
        output write,
        output [2:0] ram_func3
    );

wire [6:0] opcode;
wire [2:0] func3;
wire [6:0] func7;
wire [4:0] ALUControl;
wire pcload;
wire RFWriteEn;
wire aluSrcMuxSel;
wire RFWrDataSrcMuxSel;
wire branch;
wire RFWrDataJumpMuxSel;
wire jal;
wire jalr;
wire PCChoiceMuxSel;
ControlUnit U_CU(
     .opcode(opcode),
     .func3(func3),
     .func7(func7),
    .pcload(pcload),
    .RFWriteEn(RFWriteEn),
    .RFWrDataSrcMuxSel(RFWrDataSrcMuxSel),
    .ALUControl(ALUControl),
    .aluSrcMuxSel(aluSrcMuxSel),
    .write(write),
    .branch(branch),
    .RFWrDataJumpMuxSel(RFWrDataJumpMuxSel),
    .PCChoiceMuxSel(PCChoiceMuxSel),
    .jal(jal),
    .jalr(jalr)
    );

DataPath U_DP(
    .clk(clk),
    .reset(reset),
     .opcode(opcode),
     .func3(func3),
     .func7(func7),
    .pcload(pcload),
    .RFWriteEn(RFWriteEn),
    .RFWrDataSrcMuxSel(RFWrDataSrcMuxSel),
    .ALUControl(ALUControl),
    .aluSrcMuxSel(aluSrcMuxSel),
    .address(address),
    .writeData(WriteData),
    .readData(readData),
    .branch(branch),
    .RFWrDataJumpMuxSel(RFWrDataJumpMuxSel),
    .PCChoiceMuxSel(PCChoiceMuxSel),
    .jal(jal),
    .jalr(jalr),
    .ram_func3(ram_func3)
    );
 endmodule