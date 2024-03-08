`timescale 1ns / 1ps
module RV32i_MCU(
    input clk,
    input reset,
    output [3:0] OutPortA,
    output [3:0] OutPortB,
    output [3:0] OutPortC,
    output [3:0] OutPortD,
    output [3:0] fndselect,
    output [7:0] fndfont,
    input [3:0]swA,
    input [3:0]swB,
    input [3:0]swC,
    input [3:0]swD
    );
    
wire write;
wire [31:0] address, writeData, readData , readDataRAM,readDataGPOA,readDataGPOB, readDataGPOC, readDataGPOD,readDataRCM, readDataGPI;
wire [6:0] w_sel;
wire [2:0] w_ramfunc3;

RV32I U_RV32I(
      .clk(clk),
      .reset(reset),
      .address(address),
      .WriteData(writeData),
      .readData(readData),
      .write(write),
      .ram_func3(w_ramfunc3)
    );
Decoder_bus U_DECB(
    .sel(address),
    .y(w_sel)
 );      
mux_bus UMuxB(
     .sel(address),
     .i_data_0(readDataRAM),
     .i_data_1(readDataGPOA),
     .i_data_2(readDataGPOB),
     .i_data_3(readDataGPOC),
     .i_data_4(readDataGPOD),
     .i_data_5(readDataRCM),
     .i_data_6(readDataGPI),
     .o_data(readData)
 ); 
 
  
 
Ram U_Ram1(
    .clk(clk),
    .reset(reset),
    .we(write),
    .ce(w_sel[0]),
    .addr(address[15:0]),
    .i_data(writeData),
    .o_data(readDataRAM),
    . func3(w_ramfunc3)
    );

GPO U_GPOA(
    .clk(clk),
    .reset(reset),
    .sel(w_sel[1]),
    .address(address[0]),
    .we(write),
    .wData(writeData),
    .rData(readDataGPOA),
    .outPort(OutPortA)
    );
GPO U_GPOB(
    .clk(clk),
    .reset(reset),
    .sel(w_sel[2]),
    .address(address[0]),
    .we(write),
    .wData(writeData),
    .rData(readDataGPOB),
    .outPort(OutPortB)
    );
    
GPO U_GPOC(
    .clk(clk),
    .reset(reset),
    .sel(w_sel[3]),
    .address(address[0]),
    .we(write),
    .wData(writeData),
    .rData(readDataGPOC),
    .outPort(OutPortC)
    );
  
GPO U_GPOD(
    .clk(clk),
    .reset(reset),
    .sel(w_sel[4]),
    .address(address[0]),
    .we(write),
    .wData(writeData),
    .rData(readDataGPOD),
    .outPort(OutPortD)
    );            
 
 Fnd_controller_Mem U_FCM(
    .clk(clk),
    .reset(reset),
    .sel(w_sel[5]),
    .address(address[0]),
    .we(write),
   .wData(writeData),
    .rData(readDataRCM),
   .fndselect(fndselect),
   .fndfont(fndfont)
    );  
 
GPI U_GPI(
   .clk(clk),
    .reset(reset),
    .sel(w_sel[6]),
    .address(address[1:0]),
    .we(write),
    .rData(readDataGPI),
    .inPortA(swA),
    .inPortB(swB),
    .inPortC(swC),
    .inPortD(swD)
    );
 endmodule
 
 module Decoder_bus(
    input [31:0]sel,
    output reg [6:0] y
 );
    always @(*) begin
        case(sel[31:8])
            24'h0000_00: y = 7'b0000001; //RAM
            24'h0000_01: y = 7'b0000010; //GPOA
            24'h0000_02: y = 7'b0000100; //GPOB
            24'h0000_03: y = 7'b0001000; //GPOC
            24'h0000_04: y = 7'b0010000; //GPOD
            24'h0000_05: y = 7'b0100000; //FCM
            24'h0000_06: y = 7'b1000000; //GPI
            default: y = 7'b0000000;
        endcase     
   end       
   endmodule  
  
  module mux_bus(
    input [31:0] sel,
    input [31:0] i_data_0,
    input [31:0] i_data_1,
    input [31:0] i_data_2,
    input [31:0] i_data_3,
    input [31:0] i_data_4,
    input [31:0] i_data_5,
    input [31:0] i_data_6,
    output reg [31:0] o_data
 ); 
 always @(*) begin
        case(sel[31:8])
            24'h0000_00: o_data = i_data_0; //RAM
            24'h0000_01: o_data = i_data_1; //GPOA
            24'h0000_02: o_data = i_data_2; //GPOB
            24'h0000_03: o_data = i_data_3; //GPOC
            24'h0000_04: o_data = i_data_4; //GPOD
            24'h0000_05: o_data = i_data_5; //FCM
            24'h0000_06: o_data = i_data_6; //GPI
            default: o_data = 32'b0;
        endcase     
   end         
 endmodule