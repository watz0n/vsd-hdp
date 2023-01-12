module rv151_bch(
    input   [31:0]  bch_c1,
    input   [31:0]  bch_c2,
    input           bch_op, //branch operation
    input   [2:0]   bch_fn, //branch function
    output          bch_tk  //taken
);

wire bch_eq ;
wire bch_ne ;
wire bch_lt ;
wire bch_ge ;
wire bch_ltu;
wire bch_geu;

reg  bch_taken;

assign bch_eq  = bch_c1 == bch_c2;
assign bch_ne  = bch_c1 != bch_c2;
assign bch_lt  = $signed(bch_c1) <  $signed(bch_c2);
assign bch_ge  = $signed(bch_c1) >= $signed(bch_c2);
assign bch_ltu = $unsigned(bch_c1) <  $unsigned(bch_c2);
assign bch_geu = $unsigned(bch_c1) >= $unsigned(bch_c2);

assign bch_tk = bch_taken;

always@(*) begin
    case({bch_op, bch_fn})
        {1'b1, 3'b000} : bch_taken = bch_eq ;
        {1'b1, 3'b001} : bch_taken = bch_ne ;
        {1'b1, 3'b100} : bch_taken = bch_lt ;
        {1'b1, 3'b101} : bch_taken = bch_ge ;
        {1'b1, 3'b110} : bch_taken = bch_ltu;
        {1'b1, 3'b111} : bch_taken = bch_geu; 
        default        : bch_taken = 1'b0;
    endcase
end

endmodule