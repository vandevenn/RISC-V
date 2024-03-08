`timescale 1ns / 1ps
`include "RV32i_define.v"

module DataPath(
    //global signal
    input clk,
    input reset,
    //PC signal
    input pcload,
    //RegFile signal
    input RFWriteEn,
    input RFWrDataSrcMuxSel,
    //Jump signal
    input RFWrDataJumpMuxSel,
    input jal,
    input jalr,
    //ALU signal
    input [6:0] ALUControl,  
    //AluMux signal
    input aluSrcMuxSel,
    //branch signal
    input branch,
    //PCChoice signal
    input PCChoiceMuxSel,
    //BUS signal
    output [31:0] address,
    output [31:0] writeData,
    input [31:0]readData,
    //Control Unit signal
    output [6:0] opcode,
    output [2:0] func3,
    output [6:0] func7,
    output [2:0] ram_func3
    );
    wire[31:0] w_pcadd4,w_instMemAddr, w_instCode, w_ALUValue, w_RFSrcData1,w_RFSrcData2, w_immValue, w_aluSrcMuxValue, w_RFWrDataSrcMuxValue, w_BranchAdderValue, w_PCSrcMuxValue, w_RFWrDataJumpMuxValue, w_JALRMuxValue, w_PCChoiceMuxValue, shiftValue;
    wire w_PCSrcMuxSel, w_BTaken, w_branch;
    
    assign opcode = w_instCode[6:0];
    assign func3 = w_instCode[14:12];
    assign func7 = w_instCode[31:25];
    assign address = w_ALUValue;
    assign writeData = w_RFSrcData2;
    assign ram_func3 = w_instCode[14:12];
 mux_2x1 U_JALRMux(
    .sel(jalr),
    .a(w_PCSrcMuxValue),
    .b(w_RFWrDataSrcMuxValue),
    .y(w_JALRMuxValue)
    );
       
register U_PC(
    .clk(clk),
    .reset(reset),
    .i_data(w_JALRMuxValue),
    .load(pcload),
    .o_data(w_instMemAddr)
    );
    
Adder U_Adder4(
    .a(w_instMemAddr),
    .b(4),
    .y(w_pcadd4)
    );

ROM U_ROM(
    .addr(w_instMemAddr),
    .data(w_instCode)    
    );
    
mux_2x1 U_RFWrDataJumpMux(
    .sel(RFWrDataJumpMuxSel),
    .a(w_RFWrDataSrcMuxValue),
    .b(w_pcadd4),
    .y(w_RFWrDataJumpMuxValue)
    );
        
RegFile U_RegFile(
    .clk(clk),
    .reset(reset),
   .srcAddr1(w_instCode[19:15]),
    .srcAddr2(w_instCode[24:20]),
    .dstAddr(w_instCode[11:7]),
    .writeEn(RFWriteEn),
    .writeData(w_RFWrDataJumpMuxValue),
    .srcData1(w_RFSrcData1),
    .srcData2(w_RFSrcData2)
    );
mux_2x1 U_RFWrDataSrcMux(
    .sel(RFWrDataSrcMuxSel),
    .a(w_ALUValue),
    .b(readData),
    .y(w_RFWrDataSrcMuxValue)
    );    
mux_2x1 U_PCChoiceMux(
    .sel(PCChoiceMuxSel),
    .a(w_RFSrcData1),
    .b(w_instMemAddr),
    .y(w_PCChoiceMuxValue)
    );
ALU U_ALU(
    .ALUControl(ALUControl),
    .src1(w_PCChoiceMuxValue),
    .src2(w_aluSrcMuxValue),
    .result(w_ALUValue),
    .btaken(w_BTaken)
    );
ImeGen U_ImeGen(
    .instCode(w_instCode),
    .imm(w_immValue)
    );
mux_2x1 U_AluSrcMux(
    .sel(aluSrcMuxSel),
    .a(w_RFSrcData2),
    .b(w_immValue),
    .y(w_aluSrcMuxValue)
    );

    

shifter U_sh(
    .i_data(w_immValue),
    .o_data(shiftValue)
    );

Adder U_BranchAdder(
    .a(w_instMemAddr),
    .b(shiftValue),
    .y(w_BranchAdderValue)
    );
mux_2x1 U_PCSrcMux(
    .sel(w_PCSrcMuxSel),
    .a(w_pcadd4),
    .b(w_BranchAdderValue),
    .y(w_PCSrcMuxValue)
    );
    
    and U_Btake (w_branch, w_BTaken, branch);
    or U_JumpOR (w_PCSrcMuxSel, w_branch, jal);
endmodule

module RegFile(
    input clk,
    input reset,
    input [4:0] srcAddr1,
    input [4:0] srcAddr2,
    input [4:0] dstAddr,
    input writeEn,
    input [31:0] writeData,
     output [31:0] srcData1,
     output [31:0] srcData2
    );
   reg [31:0] regFiles[0:31];
   integer i;
   
   initial begin
        for (i=0; i<32; i = i + 1) begin  //simulation
        regFiles[i] = i;
    end    
   end
   
   assign srcData1 = srcAddr1 ? regFiles[srcAddr1] : 32'b0;
   assign srcData2 = srcAddr2 ? regFiles[srcAddr2] : 32'b0;
   
   always @(posedge clk) begin
        if (writeEn && dstAddr && !reset) begin //동기식 리셋
            regFiles[dstAddr] <= writeData;
            end
    end

endmodule

module Adder(
    input [31:0] a,
    input [31:0] b,
    output [31:0] y
    );
    
   assign y = a + b;
endmodule

module register(
    input clk,
    input reset,
    input [31:0] i_data,
    input load,
    output reg[31:0] o_data
    );
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            o_data <= 0;
            end
            else begin
                if(load) o_data <= i_data;
                else o_data <= o_data;
                end
           end   
endmodule

module ROM(
    input [31:0] addr,
    output [31:0] data    
    );
    reg [31:0] mem[0:1023];
    
    initial begin
       $readmemh("code.mem", mem);
    /*mem[0] = 32'b011111111111_00000_000_00001_0010011;
    mem[1] = 32'b011111111111_00000_000_00010_0010011;
    mem[2] = 32'b011111111111_00000_000_00011_0010011;
    mem[3] = 32'b0000000_00001_00001_000_10000_1100011; // BEQ
    mem[4] = 32'b011111111111_00000_000_00100_0010011;
    mem[5] = 32'b011111111111_00000_000_00101_0010011;
    mem[6] = 32'b011111111111_00000_000_00110_0010011;
    mem[7] = 32'b011111111111_00000_000_00111_0010011;
    mem[8] = 32'b011111111111_00000_000_01000_0010011;
    mem[9] = 32'b011111111111_00000_000_01001_0010011;
    mem[10] = 32'b011111111111_00000_000_01010_0010011;*/
            
       end
      
    assign data = mem[(addr>>2)]; // divided by 4

endmodule

module ALU(
    input [6:0] ALUControl,
    input [31:0] src1,
    input [31:0] src2,
    output reg [31:0] result,
    output reg btaken
    );
    

    always @(*) begin
        case (ALUControl[3:0])
            `ADD: result = src1 + src2;
            `SUB: result = src1 - src2;
            `SLL: result = src1 << src2;
            `SRL: result = src1 >> src2;
            `SRA: result = src1 >>> src2;
            `SLT: result = (src1 < src2) ? 1:0;
            `SLTU: result = (src1 < src2) ? 1:0;
            `XOR: result = src1 ^ src2;
            `OR: result = src1 | src2;
            `AND: result = src1 & src2;
            `SLLI: result = src1 << src2[4:0];
            `SRLI: result = src1 >> src2[4:0];
            `SRAI: result = src1 >>> src2[4:0];
            `LUI: result = src2 << 12;
            `AUI: result = src1 + (src2 << 12);
            default: result = 32'b0;
        endcase
    end       
    
    always @(*) begin
        case (ALUControl[6:4])
            3'b000: btaken = src1 == src2; 
            3'b001: btaken = src1 != src2;
            3'b100: btaken = src1 < src2;
            3'b101: btaken = src1 >= src2;
            3'b110: btaken = src1 < src2;
            3'b111: btaken = src1 >= src2;   
            default : btaken = 1'b0;
        endcase
    end     
endmodule

module mux_2x1(
    input sel,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] y
    );
    
    always @(*) begin
        case(sel)
        1'b0: y = a;
        1'b1: y = b;
        endcase
    end
endmodule

module ImeGen(
    input [31:0] instCode,
    output reg [31:0] imm
    );
  
  always @(*) begin
  case (instCode[6:0])
    `OPCODE_TYPE_I: imm = {{20{instCode[31]}}, instCode[31:20]}; //31번 최상위 비트 20번 반복 
     `OPCODE_TYPE_IL: imm = {{20{instCode[31]}}, instCode[31:20]}; 
     `OPCODE_TYPE_S  : imm = {{20{instCode[31]}}, instCode[31:25], instCode[11:7]};
     `OPCODE_TYPE_B  : imm = {{20{instCode[31]}}, instCode[31], instCode[7], instCode[30:25], instCode[11:8]};
     `OPCODE_TYPE_J:  imm = {{12{instCode[31]}},//
                                 instCode[31], // imm[20] 
                                 instCode[19:12], //imm[19:12]
                                 instCode[20], 
                                 instCode[30:21]};
    `OPCODE_TYPE_JI:  imm = {{20{instCode[31]}}, instCode[31:20]};       
    `OPCODE_TYPE_LU:  imm = {{12{instCode[31]}}, instCode[31:12]};         
    `OPCODE_TYPE_AU:  imm = {{12{instCode[31]}}, instCode[31:12]};                 
    default: imm =32'b0;
    endcase
    end
endmodule 

module shifter (
    input [31:0] i_data,
    output [31:0] o_data
    );
    assign o_data = i_data << 1;
endmodule

