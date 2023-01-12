// Copyright 2023 Hwa-Shan (Watson) Huang
// Author: watson.edx@gmail.com

module rv151_alu(
    input   [31:0] alu_i1,
    input   [31:0] alu_i2,
    input   [3:0]  alu_fn, //function
    output  [31:0] alu_ot
);

wire [31:0] ot_add ;
wire [31:0] ot_sub ;
wire [31:0] ot_sll ;
wire [31:0] ot_slt ;
wire [31:0] ot_sltu;
wire [31:0] ot_xor ;
wire [31:0] ot_srl ;
wire [31:0] ot_sra ;
wire [31:0] ot_or  ;
wire [31:0] ot_and ;

reg [31:0] alu_out;

assign ot_add  = alu_i1 + alu_i2;
assign ot_sub  = alu_i1 - alu_i2;
assign ot_sll  = alu_i1 << alu_i2[4:0];
assign ot_slt  = {31'h0, $signed(alu_i1)   < $signed(alu_i2)  };
assign ot_sltu = {31'h0, $unsigned(alu_i1) < $unsigned(alu_i2)};
assign ot_xor  = alu_i1 ^ alu_i2;
assign ot_srl  = alu_i1 >> alu_i2[4:0];
assign ot_sra  = $signed(alu_i1) >>> alu_i2[4:0];
assign ot_or   = alu_i1 | alu_i2;
assign ot_and  = alu_i1 & alu_i2;

assign alu_ot = alu_out;

always@(*) begin
    case(alu_fn)
        {4'b0000} : alu_out = ot_add  ;
        {4'b1000} : alu_out = ot_sub  ;
        {4'b0001} : alu_out = ot_sll  ;
        {4'b0010} : alu_out = ot_slt  ;
        {4'b0011} : alu_out = ot_sltu ;
        {4'b0100} : alu_out = ot_xor  ;
        {4'b0101} : alu_out = ot_srl  ;
        {4'b1101} : alu_out = ot_sra  ;
        {4'b0110} : alu_out = ot_or   ;
        {4'b0111} : alu_out = ot_and  ;
        {4'b1010} : alu_out = alu_i2  ;
        default   : alu_out = ot_add  ;
    endcase
end

endmodule