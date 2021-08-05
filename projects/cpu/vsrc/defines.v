
`timescale 1ns / 1ps

`define ZERO_WORD  64'h00000000_00000000   
`define REG_BUS    63 : 0     
`define LOW_WORD    31:0
`define HIGH_WORD   63:32

//ALU parameters:
`define INST_ADD   4'h0
`define INST_SUB   4'h1
`define INST_XOR   4'h4
`define INST_OR    4'h6
`define INST_AND   4'h7
`define INST_SL    4'h8
`define INST_SRL   4'h9
`define INST_SRA   4'hB
`define INST_SRT   4'hC