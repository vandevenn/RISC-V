`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 13:10:57
// Design Name: 
// Module Name: BCDtoFND
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


module BCDtoFND(
    input [3:0]i_bcd,
    output reg [7:0] o_fnd
    );


always @(*) begin
    case(i_bcd)
    4'h0: o_fnd = 8'hc0;
    4'h1: o_fnd = 8'hf9;
    4'h2: o_fnd = 8'ha4;
    4'h3: o_fnd = 8'hb0;
    4'h4: o_fnd = 8'h99;
    4'h5: o_fnd = 8'h92;
    4'h6: o_fnd = 8'h82;
    4'h7: o_fnd = 8'hf8;
    4'h8: o_fnd = 8'h80;
    4'h9: o_fnd = 8'h90;
    4'ha: o_fnd = 8'h88;
    4'hb: o_fnd = 8'h83;
    4'hc: o_fnd = 8'hc6;
    4'hd: o_fnd = 8'ha1;
    4'he: o_fnd = 8'h86;
    4'hf: o_fnd = 8'h8e;   //4��Ʈ�� 16������ �� �� �Է� �� �� o_fnd �� 8��Ʈ�� ���� ����(���� 7_SEG led ��翡 �°�)
    endcase
end
endmodule