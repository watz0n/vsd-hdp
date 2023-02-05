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

module bspi_aff(

    input        wen,
    input  [7:0] wdt,
    output       wfl,

    input        ren,
    output [7:0] rdt,
    output       rey,

    input wck, 
    input rck,

    input rstn
);

//======

reg [7:0] mbf [0:1];

//===

reg  [1:0] wbc;
wire [1:0] wbn;
wire [1:0] wgc;

reg  [1:0] wrg [1:0];
wire [1:0] wrb;

//===

reg  [1:0] rbc;
wire [1:0] rbn;
wire [1:0] rgc;

reg  [1:0] rwg [1:0];
wire [1:0] rwb;

//======

assign wbn = wbc+1;
assign wgc = wbc^(wbc>>1);

assign wrb = {wrg[1][1], wrg[1][1]^wrg[1][0]};

assign wfl = (wbc[1]!=wrb[1])&(wbc[0]==wrb[0]);

always@(posedge wck) begin
    if(wen) mbf[wbc[0]] <= wdt;
end

always@(posedge wck or negedge rstn) begin
    if(!rstn) begin
        wbc <= 2'h0;
    end
    else begin
        wbc <= (wen&!wfl) ? wbn : wbc;
    end
end

always@(posedge wck or negedge rstn) begin
    if(!rstn) begin
        {wrg[1], wrg[0]} <= {2'h0, 2'h0};
    end
    else begin
        {wrg[1], wrg[0]} <= {wrg[0], rgc};
    end
end

//===

assign rbn = rbc+1;
assign rgc = rbc^(rbc>>1);

assign rwb = {rwg[1][1], rwg[1][1]^rwg[1][0]};

assign rey = (rbc==rwb);

assign rdt = mbf[rbc[0]];

always@(posedge rck or negedge rstn) begin
    if(!rstn) begin
        rbc <= 2'h0;
    end
    else begin
        rbc <= (ren&!rey) ? rbn : rbc;
    end
end

always@(posedge rck or negedge rstn) begin
    if(!rstn) begin
        {rwg[1], rwg[0]} <= {2'h0, 2'h0};
    end
    else begin
        {rwg[1], rwg[0]} <= {rwg[0], wgc};
    end
end

//======

endmodule