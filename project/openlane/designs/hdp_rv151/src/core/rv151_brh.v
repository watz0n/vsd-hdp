// MIT License
// -----------
// 
// Copyright (c) 2023 Watson Huang (watson.edx@gmail.com)
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.
// -----------
// SPDX-License-Identifier: MIT

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