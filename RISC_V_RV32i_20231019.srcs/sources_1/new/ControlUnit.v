`timescale 1ns / 1ps
`include "RV32i_define.v"

module ControlUnit(
    input [6:0] opcode,
    input [2:0] func3,
    input [6:0] func7,
    //PC signal
    output reg pcload,
     //Jump signal
    output reg RFWrDataJumpMuxSel,
    output reg jal,
    output reg jalr,
    //RegFile signal
    output reg RFWriteEn,
    output reg RFWrDataSrcMuxSel,
    //ALU signal
    output reg [6:0] ALUControl,
    //AluMux signal
    output reg aluSrcMuxSel,
    //branch signal
    output reg branch,    
        //BUS signal
    output reg write,
        //PCChoice signal
    output reg PCChoiceMuxSel
    );
    
    always @(*) begin
        case (opcode)
            `OPCODE_TYPE_R: begin
                pcload = 1'b1;
                RFWriteEn = 1'b1;
                aluSrcMuxSel = 1'b0;
                RFWrDataSrcMuxSel = 1'b0;
                write = 1'b0;
                branch = 1'b0;
                 RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                PCChoiceMuxSel = 1'b0; 
                                 
            end
            `OPCODE_TYPE_I: begin
                pcload = 1'b1;
                RFWriteEn = 1'b1;
                aluSrcMuxSel = 1'b1;
                RFWrDataSrcMuxSel = 1'b0; //ALU Value
                write = 1'b0;
                branch = 1'b0;
                 RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0; 
                jalr = 1'b0; 
                PCChoiceMuxSel = 1'b0;                
            end            
            `OPCODE_TYPE_IL: begin
                pcload = 1'b1;
                RFWriteEn = 1'b1;
                aluSrcMuxSel = 1'b1;
                RFWrDataSrcMuxSel = 1'b1; //RAM DATA
                write = 1'b0; //RAM Read
                branch = 1'b0;
                 RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0; 
                jalr = 1'b0; 
                PCChoiceMuxSel = 1'b0;                
            end    
            `OPCODE_TYPE_S: begin
                pcload = 1'b1;
                RFWriteEn = 1'b0;
                aluSrcMuxSel = 1'b1;
                RFWrDataSrcMuxSel = 1'b1; //RAM DATA
                write = 1'b1; //Ram Write
                branch = 1'b0;
                 RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0; 
                jalr = 1'b0;     
                PCChoiceMuxSel = 1'b0;            
            end    
            `OPCODE_TYPE_B: begin
                pcload = 1'b1;
                RFWriteEn = 1'b0;
                aluSrcMuxSel = 1'b0;
                RFWrDataSrcMuxSel = 1'b0; //AluValue DATA
                write = 1'b0; //Ram Write
                branch = 1'b1;
                RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;  
                PCChoiceMuxSel = 1'b0;                 
            end    
            `OPCODE_TYPE_J: begin
                pcload = 1'b1;                            
                RFWriteEn = 1'b1;                         
                aluSrcMuxSel = 1'b1;                      
                RFWrDataSrcMuxSel = 1'b0; //AluValue DATA 
                write = 1'b0; //Ram Write                 
                branch = 1'b0; 
                RFWrDataJumpMuxSel = 1'b1;
                jal = 1'b1;
                jalr = 1'b0; 
                PCChoiceMuxSel = 1'b0;                           
            end
            `OPCODE_TYPE_JI: begin
                pcload = 1'b1;                            
                RFWriteEn = 1'b1;                         
                aluSrcMuxSel = 1'b1;                      
                RFWrDataSrcMuxSel = 1'b0; //AluValue DATA 
                write = 1'b0; //Ram Write                 
                branch = 1'b0; 
                RFWrDataJumpMuxSel = 1'b1;
                jal = 1'b0;
                jalr = 1'b1; 
                PCChoiceMuxSel = 1'b0;                           
            end
             `OPCODE_TYPE_LU: begin
                pcload = 1'b1;                            
                RFWriteEn = 1'b1;                         
                aluSrcMuxSel = 1'b1;                      
                RFWrDataSrcMuxSel = 1'b0; //AluValue DATA 
                write = 1'b0; //Ram Write                 
                branch = 1'b0; 
                RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                PCChoiceMuxSel = 1'b0;                            
            end
            `OPCODE_TYPE_AU: begin
                pcload = 1'b1;                            
                RFWriteEn = 1'b1;                         
                aluSrcMuxSel = 1'b1;                      
                RFWrDataSrcMuxSel = 1'b0; //AluValue DATA 
                write = 1'b0; //Ram Write                 
                branch = 1'b0; 
                RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                PCChoiceMuxSel = 1'b1;
                                           
            end
            
            default: begin
                pcload = 1'b1;
                RFWriteEn = 1'b1;
                aluSrcMuxSel = 1'b0;
                RFWrDataSrcMuxSel = 1'b0;
                write = 1'b0;
                RFWrDataJumpMuxSel = 1'b0;
                jal = 1'b0;
                jalr = 1'b0;
                PCChoiceMuxSel = 1'b0;            
           end
       endcase
   end
   
   always @(*) begin
   ALUControl = {func3,`ADD};
        case (opcode)
            `OPCODE_TYPE_R: begin
                case ({func7[5], func3})
                    4'b0000: ALUControl = {func3, `ADD};
                    4'b1000: ALUControl = {func3, `SUB};
                    4'b0001: ALUControl = {func3, `SLL};
                    4'b0101: ALUControl = {func3, `SRL};
                    4'b1101: ALUControl = {func3, `SRA};
                    4'b0010: ALUControl = {func3, `SLT};
                    4'b0011: ALUControl = {func3, `SLTU};
                    4'b0100: ALUControl = {func3, `XOR};
                    4'b0110: ALUControl = {func3, `OR};
                    4'b0111: ALUControl = {func3, `AND};         
                    default: ALUControl = {func3, `ADD};
                endcase    
            end
           
            `OPCODE_TYPE_I : begin
                case ({func7[5], func3})
                4'b0000: ALUControl = {func3, `ADD};
                4'b0010: ALUControl = {func3, `SLT};                
                4'b0011: ALUControl = {func3, `SLTU}; //SLTU
                4'b0100: ALUControl = {func3, `XOR};                
                4'b0110: ALUControl = {func3, `OR};
                4'b0111: ALUControl = {func3, `AND};  
               
                4'b0001: ALUControl = {func3, `SLLI}; // SLLI
                4'b0101: ALUControl = {func3, `SRLI}; // SRLI 
                4'b1101: ALUControl = {func3, `SRAI}; // SRAI                                                                       
                default: ALUControl ={func3, `ADD};
                endcase
            end           
            `OPCODE_TYPE_LU: begin
                ALUControl = {func3,`LUI};
                end  
            `OPCODE_TYPE_AU: begin
                ALUControl = {func3,`AUI};
                end     
        endcase
    end                     
endmodule
