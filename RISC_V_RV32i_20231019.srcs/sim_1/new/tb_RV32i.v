`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/19 14:34:59
// Design Name: 
// Module Name: tb_RV32i
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
 

module tb_RV32i(

    );
    
    reg clk;
    reg reset;
    wire [3:0] OutPortA;
    wire [3:0] OutPortB;
    wire [3:0] OutPortC;
    wire [3:0] OutPortD;
    
 RV32i_MCU dut(
       .clk(clk),
       .reset(reset),
       .OutPortA(OutPortA),
        .OutPortB(OutPortB),
        .OutPortC(OutPortC),
        .OutPortD(OutPortD)
    );  
    
    always #5 clk = ~clk;
    
    initial begin
        #00 clk = 0; reset = 1;
        #20 reset = 0;
    end    
endmodule


