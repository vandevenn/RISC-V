`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 14:47:27
// Design Name: 
// Module Name: Fnd_Counter
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


module Fnd_Counter(
    input clk,reset,
    input stop,
    input run,
    input clear,
    output [13:0] value
    );

wire w_clk10hz;
ClockDivider10Hz #(
.HERZ(10)
)   U_Clockdiv (
    .clk(clk),
    .reset(reset),
    .o_clk(w_clk10hz)
    );
    
Counter9999 U_Counter9999(
    .clk(w_clk10hz),
    .reset(reset),
    .stop(stop),
    .run(run),
    .clear(clear),
    .o_count(value)
    );
    
    endmodule