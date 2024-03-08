`timescale 1ns / 1ps


module Ram(
    input clk,
    input reset,
    input we,
    input ce,
    input [7:0] addr,
    input [31:0] i_data,
    input [2:0] func3,
    output reg [31:0] o_data
    );
    reg [31:0] mem[0:2**8-1];
    
// IL - Type
    always @(*) begin
        if (o_data == we) begin
            o_data = 32'bz;
        end else begin
                    o_data = mem[addr];                     // LW
                    case (func3)
                        3'b000: o_data = mem[addr][7:0];    // LB
                        3'b001: o_data = mem[addr][15:0];   // LH
                        3'b010: o_data = mem[addr];         // LW
                        3'b100: o_data = mem[addr][7:0];    // LBU
                        3'b101: o_data = mem[addr][15:0];   // LHU    
                    endcase                         
        end
    end
    
    
    // S - Type
    always @(posedge clk) begin
        if (we && ce && !reset) mem[addr] <= i_data;                   // SW
        case (func3)
            3'b000: if (we && ce && !reset) mem[addr] <= i_data[7:0];  // SB
            3'b001: if (we && ce && !reset) mem[addr] <= i_data[15:0]; // SH
            3'b010: if (we && ce && !reset) mem[addr] <= i_data;       // SW
        endcase    
    end
    
endmodule
 