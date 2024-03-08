`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 14:04:42
// Design Name: 
// Module Name: ButtonDetector
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


module ButtonDetector(
    input clk,
    input reset,
    input i_button,
    output o_button
    );

    wire w_q0, w_q1, w_q2, w_q3;
    reg [31:0] r_counter =0;
    reg r_clk_100hz = 0;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 0;
            r_clk_100hz <= 0;
        end else begin
            if (r_counter == 1_000_000 / 2 - 1) begin
                r_counter <= 0;
                r_clk_100hz <= ~r_clk_100hz;
                end else begin
                r_counter <= r_counter + 1; 
                end
            end
       end     
       
dff U2_Dff(
    .clk(r_clk_100hz),
    .reset(reset),
    .d(i_button),
    .q(w_q2)
);  

dff U3_Dff(
    .clk(r_clk_100hz),
    .reset(reset),
    .d(w_q2),
    .q(w_q3)
);  

dff U0_Dff(
    .clk(clk),
    .reset(reset),
    .d(w_q3),
    .q(w_q0)
);    

dff U1_Dff(
    .clk(clk),
    .reset(reset),
    .d(w_q0),
    .q(w_q1)
);

assign o_button = ~w_q0 & w_q1;

endmodule

module dff (
    input clk,
    input reset,
    input d,
    output reg q
    );
    
    always @(posedge clk, posedge reset) begin
        if (reset) q <= 1'b0;
        else q <= d;
    end
endmodule

