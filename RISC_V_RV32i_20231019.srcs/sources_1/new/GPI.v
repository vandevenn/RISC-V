`timescale 1ns / 1ps


module GPI(
    input clk,
    input reset,
    input sel,
    input we,
    input [1:0] address,
    output [31:0] rData,
    input [3:0] inPortA,
    input [3:0] inPortB,
    input [3:0] inPortC,
    input [3:0] inPortD 
    );
    reg [31:0] GPIRegMap [0:3];
    reg [3:0] syncA[0:1];
    reg [3:0] syncB[0:1];
    reg [3:0] syncC[0:1];
    reg [3:0] syncD[0:1];
    
    assign rData = (sel && !we) ? GPIRegMap[address] : 32'bz;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            GPIRegMap[0] <= 0;
            GPIRegMap[1] <= 0;
            GPIRegMap[2] <= 0;
            GPIRegMap[3] <= 0;
        end
            else begin
                syncA[0] <= inPortA;
                syncA[1] <= syncA[0];
                GPIRegMap[0][3:0] <= syncA[1];
               
                syncB[0] <= inPortB;
                syncB[1] <= syncB[0];
                GPIRegMap[1][3:0] <= syncB[1];
               
               syncC[0] <= inPortC;
                syncC[1] <= syncC[0];
                GPIRegMap[2][3:0] <= syncC[1];
                
                syncD[0] <= inPortD;
                syncD[1] <= syncD[0];
                GPIRegMap[3][3:0] <= syncD[1];
            end
    end
     
endmodule
