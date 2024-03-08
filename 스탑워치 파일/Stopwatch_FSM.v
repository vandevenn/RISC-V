`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 16:02:47
// Design Name: 
// Module Name: Stopwatch_FSM
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


module Stopwatch_FSM(
    input clk,
    input reset,
    input i_run_stop,
    input i_clear,
    output reg o_run,
    output reg o_stop,
    output reg o_clear    
    );
    parameter STOP = 2'b00, RUN = 2'b01, CLEAR = 2'b10;
    reg [1:0] state = STOP, nextstate;
    
    // current state register
    always @(posedge clk, posedge reset) begin
        if (reset) state <= STOP;
        else state <= nextstate;
    end
    
    // next state combinational logic
    always @(i_run_stop,i_clear,state) begin
        case (state)
            STOP: begin
                if (i_run_stop) nextstate = RUN;
                else if (i_clear) nextstate = CLEAR;
                else nextstate = STOP;
                end
                    RUN: begin
                    if (i_run_stop) nextstate = STOP;
                    else nextstate = RUN;
                    end
                        CLEAR: begin                                        
                        if (i_run_stop) nextstate = RUN;
                        else nextstate = CLEAR;
                        end
            default: nextstate = STOP;           
        endcase
    end
    
    always @(state) begin
        case (state)
            STOP: begin 
                o_stop = 1'b1;
                o_run = 1'b0;
                o_clear = 1'b0;
            end
                RUN: begin
                    o_stop =1'b0;
                    o_run =1'b1;
                    o_clear =1'b0;
                end    
                        CLEAR: begin
                             o_stop = 1'b0;
                             o_run = 1'b0;
                             o_clear = 1'b1;
                        end  
                            default: begin
                                o_stop = 1'b1;
                                o_run = 1'b0;
                                o_clear = 1'b0;
                            end    
        endcase    
    end
endmodule
