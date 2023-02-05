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