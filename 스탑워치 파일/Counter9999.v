`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 14:35:36
// Design Name: 
// Module Name: Counter9999
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


module Counter9999(
    input clk,
    input reset,
    input stop,
    input run,
    input clear,
    output reg [13:0] o_count = 0
);

always @(posedge clk, posedge reset) begin
    
    if (reset) begin
        o_count <= 0;
    end else begin   
        if (stop) o_count <= o_count;
        else if(run) begin
            if (o_count == 9999) o_count <= 0;
            else o_count <= o_count + 1;
            end else if (clear) o_count <= 0;
            else o_count <= 0;
        end
    end    
endmodule







