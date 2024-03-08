`timescale 1ns / 1ps

module GPO(
    input clk,
    input reset,
    input sel,
    input address,
    input we,
    input [31:0] wData,
    output [31:0] rData,
    output [3:0] outPort
    );
       
    reg [31:0] gpoRegMap[0:1];
    assign outPort = gpoRegMap[1][3:0];
    assign rData = we ? 32'bx : gpoRegMap[address];
     
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            gpoRegMap[0] = 0;
            gpoRegMap[1] = 0;
        end
        else begin
            if (sel && we) begin
                gpoRegMap[address] = wData;
                end
            end        
      end 
endmodule
