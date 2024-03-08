`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:17:23
// Design Name: 
// Module Name: Decoder2x4
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


module Decoder2x4(
    input [1:0]x,
    output reg[3:0] y
    );
    
    always @(*) begin
        case(x)
        2'b00: y = 4'b1110;
        2'b01: y = 4'b1101;
        2'b10: y = 4'b1011;
        2'b11: y = 4'b0111;
        endcase
        end
endmodule
