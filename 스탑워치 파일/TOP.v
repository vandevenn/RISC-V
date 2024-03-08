`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 17:57:30
// Design Name: 
// Module Name: TOP
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


module TOP(
    input clk,
    input reset,
    input run_stop_button,
    input clear_button,
    output [3:0] fndselect,
    output [7:0] fndfont
    
    );
wire w_button1,w_button2;
wire [1:0]w_run, w_stop, w_clear;
wire [13:0] w_value;
ButtonDetector U_BD1(
    .clk(clk),
    .reset(reset),
    .i_button(run_stop_button),
    .o_button(w_button1)
    );
    
ButtonDetector U_BD2(
    .clk(clk),
    .reset(reset),
    .i_button(clear_button),
    .o_button(w_button2)
    );

Stopwatch_FSM U_FSM(
    .clk(clk),
    .reset(reset),
    .i_run_stop(w_button1),
    .i_clear(w_button2),
    .o_run(w_run),
    .o_stop(w_stop),
    .o_clear(w_clear)    
    );

Fnd_Counter U_UPCOUNTER(
    .clk(clk),
    .reset(reset),
    .stop(w_stop),
    .run(w_run),
    .clear(w_clear),
    .value(w_value)
    );
   
Fnd_controller U_FND_CONTROLLER(
    .clk(clk),
    .reset(reset),
    .value(w_value),
    .fndselect(fndselect),
    .fndfont(fndfont)
    );       
    
endmodule
