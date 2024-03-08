`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:37:55
// Design Name: 
// Module Name: ClockDevider
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


module ClockDevider(
    input clk,
    input reset,
    output reg o_clk = 0
    );
    
    reg [26:0] r_counter = 2'b0;
    
        always @(posedge clk, posedge reset)
            if (reset) begin
            o_clk <= 0;
            end else begin
                if (r_counter == (100_000/2 -1)) begin
                r_counter <= 0;
                o_clk <= ~o_clk;
                end else begin
                r_counter <= r_counter +1;
            end
       end
endmodule
