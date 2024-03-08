`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:22:13
// Design Name: 
// Module Name: DigitSplitter
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


module DigitSplitter(
    input[13:0] i_digit,
    output [3:0] o_digit1,
    output [3:0] o_digit10,
    output [3:0] o_digit100,
    output [3:0] o_digit1000
    );
    
    assign o_digit1 = i_digit %10;
    assign o_digit10 = i_digit/10 %10;
    assign o_digit100 = i_digit/100 %10;
    assign o_digit1000 = i_digit/1000 %10;
endmodule

