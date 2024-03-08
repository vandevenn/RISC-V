`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:49:40
// Design Name: 
// Module Name: Fnd_controller
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


module Fnd_controller(
    input clk,reset,
    input [13:0] value,
    output [3:0] fndselect,
    output [7:0] fndfont
    );
    
    wire w_clk_1khz;
    wire [1:0] w_fndsel;
    wire [3:0] w_digit,w_digit1,w_digit10,w_digit100,w_digit1000;
    
    ClockDevider U_ClockDevider (
        .clk(clk),
        .reset(reset),
        .o_clk(w_clk_1khz)
    );
    
    Counter U_Counter(
        .clk(w_clk_1khz),
        .reset(reset),
        .o_count(w_fndsel)
    );
    
    Decoder2x4 U_Decoder(
    .x(w_fndsel),
    .y(fndselect)
    );
    
    DigitSplitter U_DigitSplitter(
    .i_digit(value),
    .o_digit1(w_digit1),
    .o_digit10(w_digit10),
    .o_digit100(w_digit100),
    .o_digit1000(w_digit1000)
    );
    
    Mux4X1 U_Mux(
    .x0(w_digit1),
    .x1(w_digit10),
    .x2(w_digit100),
    .x3(w_digit1000),
    .sel(w_fndsel),
    .y(w_digit)    
    );
    
    BCDtoFND U_BCDtoFND(
    .i_bcd(w_digit),
    .o_fnd(fndfont)
    );
 
    
    
endmodule

