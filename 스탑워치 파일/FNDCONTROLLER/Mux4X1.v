`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:25:27
// Design Name: 
// Module Name: Mux4X1
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


module Mux4X1(
    input [3:0] x0,x1,x2,x3,
    input [1:0] sel,
    output reg[3:0]y    
    );
    
    always @(*) begin
        case(sel) 
        2'b00: y = x0;
        2'b01: y = x1;
        2'b10: y = x2;
        2'b11: y = x3;
        endcase
        end
endmodule
