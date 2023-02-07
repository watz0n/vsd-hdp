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

module rv151_ctl(

    input          ctl_ifv,
    input   [31:0] ctl_ins,

    output  [3:0]  ctl_afn,
    output  [2:0]  ctl_bfn,
    output  [2:0]  ctl_itp,
    output  [2:0]  ctl_mfn,
    output  [2:0]  ctl_csf,

    output         ctl_cso, //[10]
    output         ctl_rfw, //[9]
    output         ctl_mre, //[8]
    output         ctl_mwe, //[7]
    output         ctl_djp, //[6]
    output         ctl_dbr, //[5]
    output         ctl_ds1, //[4]
    output         ctl_ds2, //[3]
    output  [1:0]  ctl_drs, //[2:1]
    output         ctl_ivd  //[0]
);

wire [6:0] iop;
wire [2:0] ifn;

reg  [10:0] ctl;
reg  [3:0]  afn;
reg  [2:0]  itp;

assign iop = ctl_ins[6:0];
assign ifn = ctl_ins[14:12];

assign ctl_afn = afn;
assign ctl_bfn = ifn;
assign ctl_itp = itp;
assign ctl_mfn = ifn;
assign ctl_csf = ifn;

assign {
        ctl_cso, //[10]
        ctl_rfw, //[9]
        ctl_mre, //[8]
        ctl_mwe, //[7]
        ctl_djp, //[6]
        ctl_dbr, //[5]
        ctl_ds1, //[4]
        ctl_ds2, //[3]
        ctl_drs, //[2:1]
        ctl_ivd  //[0]
    } = ctl;

//ds1: 0(rs1)/1(pc0)
//ds2: 0(rs1)/1(imm)
//drf: 0(alu)/1(mem)/2(pc4)

always@(*) begin
    case({ctl_ifv, iop})
                                  //{ cso, rfw, mre, mwe, djp, dbr, ds1, ds2, drf, ivd}
        {1'b1, 7'b0110111} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,2'h0,1'b1}; //lui
        {1'b1, 7'b0010111} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,2'h0,1'b1}; //auipc
        {1'b1, 7'b1101111} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b1,1'b0,1'b1,1'b1,2'h2,1'b1}; //jal
        {1'b1, 7'b1100111} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,2'h2,1'b1}; //jalr
        {1'b1, 7'b1100011} : ctl =  {1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b1,2'h0,1'b1}; //branch-group
        {1'b1, 7'b0000011} : ctl =  {1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,2'h1,1'b1}; //load-group
        {1'b1, 7'b0100011} : ctl =  {1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b0,1'b1,2'h0,1'b1}; //store-group
        {1'b1, 7'b0010011} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,2'h0,1'b1}; //alu-imm-group
        {1'b1, 7'b0110011} : ctl =  {1'b0,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,2'h0,1'b1}; //alu-reg-group
        {1'b1, 7'b1110011} : ctl =  {1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,2'h3,1'b1}; //csr
        default    : ctl =  {1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,2'h0,1'b0}; //non-valid nop
    endcase
end

always@(*) begin
    case({ctl_ifv, iop})
        {1'b1, 7'b0110111} : afn =  4'b1010; //lui
        {1'b1, 7'b0010111} : afn =  4'b0000; //auipc
        {1'b1, 7'b1101111} : afn =  4'b0000; //jal
        {1'b1, 7'b1100111} : afn =  4'b0000; //jalr
        {1'b1, 7'b1100011} : afn =  4'b0000; //branch-group
        {1'b1, 7'b0000011} : afn =  4'b0000; //load-group
        {1'b1, 7'b0100011} : afn =  4'b0000; //store-group
        {1'b1, 7'b0010011} : afn =  {ctl_ins[30]&(ifn==3'b101), ifn}; //alu-imm-group
        {1'b1, 7'b0110011} : afn =  {ctl_ins[30]&((ifn==3'b000)|(ifn==3'b101)), ifn}; //alu-reg-group
        {1'b1, 7'b1110011} : afn =  4'b0000; //csr
        default            : afn =  4'b0000; //non-valid nop
    endcase
end

always@(*) begin
    case({ctl_ifv, iop})
        {1'b1, 7'b0110111} : itp =  3'h4; //lui
        {1'b1, 7'b0010111} : itp =  3'h4; //auipc
        {1'b1, 7'b1101111} : itp =  3'h5; //jal
        {1'b1, 7'b1100111} : itp =  3'h1; //jalr
        {1'b1, 7'b1100011} : itp =  3'h3; //branch-group
        {1'b1, 7'b0000011} : itp =  3'h1; //load-group
        {1'b1, 7'b0100011} : itp =  3'h2; //store-group
        {1'b1, 7'b0010011} : itp =  3'h1; //alu-imm-group
        {1'b1, 7'b0110011} : itp =  3'h0; //alu-reg-group
        {1'b1, 7'b1110011} : itp =  3'h0; //csr
        default            : itp =  3'h0; //non-valid nop
    endcase
end

endmodule