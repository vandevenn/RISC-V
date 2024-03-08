`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:32:29
// Design Name: 
// Module Name: Counter
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


module Counter (
    input clk,
    input reset,
    output reg[1:0] o_count = 2'b0
    );
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
        o_count <= 2'b0;
        end else
        o_count <= o_count + 1;
        end
        
endmodule
