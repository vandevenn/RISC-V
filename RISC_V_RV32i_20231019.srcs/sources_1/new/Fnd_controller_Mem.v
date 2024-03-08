`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/25 08:45:46
// Design Name: 
// Module Name: Fnd_controller_Mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Fnd_controller_Mem(
    input clk,
    input reset,
    input sel,
    input address,
    input we,
    input [31:0] wData,
    output [31:0] rData,
    output [3:0] fndselect,
    output [7:0] fndfont
    );
     
    wire [13:0] outPort;

Memory U_Mem(
    .clk(clk),
    .reset(reset),
    .sel(sel),
    .address(address),
    .we(we),
    .wData(wData),
    .rData(value),
    .outPort(outPort)
    );

Fnd_controller U_fndCon(
    .clk(clk),
    .reset(reset),
    .value(outPort),
    .fndselect(fndselect),
    .fndfont(fndfont)
    );   
    
endmodule
