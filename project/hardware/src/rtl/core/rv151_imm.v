// Copyright 2023 Hwa-Shan (Watson) Huang
// Author: watson.edx@gmail.com

module rv151_imm(
    input   [31:0] imm_it, //instruction
    input   [2:0]  imm_tp, //type
    output  [31:0] imm_ot  //output
);

reg [31:0] imm_out;

assign imm_ot = imm_out;

always@(*) begin
    case(imm_tp)
    /* I */ 3'h1 :      imm_out = {{20{imm_it[31]}}, imm_it[31:20]};   
    /* S */ 3'h2 :      imm_out = {{20{imm_it[31]}}, imm_it[31:25], imm_it[11:7]};
    /* B */ 3'h3 :      imm_out = {{20{imm_it[31]}}, imm_it[7], imm_it[30:25], imm_it[11:8], 1'b0};
    /* U */ 3'h4 :      imm_out = {imm_it[31:12], 12'h0};
    /* J */ 3'h5 :      imm_out = {{12{imm_it[31]}}, imm_it[19:12], imm_it[20], imm_it[30:21], 1'b0};
    /* R */ default :   imm_out = 32'h0;
    endcase
end

endmodule