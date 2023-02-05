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

module bspi_bif(

    input         io_bcf,
    input         io_scs,

    output        bcsb,
    output [3:0]  bweb,
    output [10:0] badr,
    output [31:0] bdti,
    input  [31:0] bdto,

    output       ren,
    input  [7:0] rdt,
    input        rey,

    output       wen,
    output [7:0] wdt,
    input        wfl,

    input rstn,
    input clk
);

reg opw, opr;
reg [10:0] bad;
reg [7:0] bwd;
reg [3:0] bwb;
reg [7:0] brd;

reg [3:0] mwb;

reg       baf;
reg [1:0] bof;

reg       bcb;

reg [1:0] bcf;
reg [1:0] scs;

wire      bxfr;

parameter ST_WTD=2'h0;
parameter ST_CFA=2'h1;
parameter ST_DTR=2'h2;
parameter ST_UNK=2'h3;

reg [1:0] st_cr, st_nx;

always@(*) begin
    case(st_cr)
        ST_WTD : st_nx = (bxfr&!rey) ? ST_CFA : st_cr ;
        ST_CFA : st_nx = (!bxfr) ? ST_WTD : (bxfr&!rey&baf) ? ST_DTR : st_cr ;
        ST_DTR : st_nx = (!bxfr) ? ST_WTD : st_cr ;
        default: st_nx = ST_UNK;
    endcase
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        st_cr <= 2'h0;
    end
    else begin
        st_cr <= st_nx;
    end
end

assign bxfr = bcf[1]&!scs[1];

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bcf <= 2'h0;
        scs <= 2'h0;
    end
    else begin
        bcf <= {bcf[0], io_bcf};
        scs <= {scs[0], io_scs};
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        baf <= 1'b0;
    end
    else begin
        baf <= (!bxfr) ? 1'b0 : ((st_cr==ST_WTD)&ren) ? 1'b1 : baf;
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bof <= 2'h0;
    end
    else begin
        bof <= (!bxfr) ? 2'h0 : ((st_cr==ST_DTR)&((opw&!bcb)|(opr&wen))) ? bof+1 : bof;
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        {opw, opr} <= {1'b0, 1'b0};
    end
    else begin
        {opw, opr} <= (!bxfr) ? {1'b0, 1'b0} : (bxfr&ren&(st_cr == ST_CFA)) ? {bad[7], bad[6]} : {opw, opr};
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bad <= 11'h0;
    end
    else begin
        bad <= (bxfr&ren&((st_cr == ST_CFA)|(st_cr == ST_WTD))) ? {bad[2:0], rdt} :
               ((st_cr == ST_DTR)&opw&!bcb&(bof==2'h3))         ? bad+1           :
               ((st_cr == ST_DTR)&opr&!bcb)                     ? bad+1           :
                                                                  bad             ;
    end
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bwd <= 8'h0;
    end
    else begin
        bwd <= (opw&ren) ? rdt : bwd ;
    end
end

always@(*) begin
    case({opw, bof})
        {1'b1, 2'h0} : mwb = 4'h7;
        {1'b1, 2'h1} : mwb = 4'hB;
        {1'b1, 2'h2} : mwb = 4'hD;
        {1'b1, 2'h3} : mwb = 4'hE;
        default      : mwb = 4'hF;
    endcase
end

always@(*) begin
    case({opr, bof})
        {1'b1, 2'h0} : brd = bdto[8*3+:8];
        {1'b1, 2'h1} : brd = bdto[8*2+:8];
        {1'b1, 2'h2} : brd = bdto[8*1+:8];
        {1'b1, 2'h3} : brd = bdto[8*0+:8];
        default      : brd = 8'h0;
    endcase
end

always@(posedge clk or negedge rstn) begin
    if(!rstn) begin
        bcb <= 1'b1;
        bwb <= 4'hF;
    end
    else begin
        bcb <= !(((st_cr == ST_DTR)&opw&ren)                |
                 ((st_cr == ST_CFA)&bad[6]&ren)             | 
                 ((st_cr == ST_DTR)&opr&wen&(bof==2'b11))   );
        bwb <= (!bcb) ? 4'hF : mwb;
    end
end

//======

assign bcsb = bcb;
assign badr = bad;
assign bweb = bwb;
assign bdti = {4{bwd}};

assign ren = !rey;
assign wen = opr&!wfl&bcb;
assign wdt = brd;

endmodule