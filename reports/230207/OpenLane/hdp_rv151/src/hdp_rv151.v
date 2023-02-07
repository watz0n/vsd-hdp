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

module hdp_rv151  (
    input  io_bcf,
    input  io_scs,
    input  io_sdi,
    output io_sdo,
    input  io_sck,

    output io_hlt,
    output io_irc,

    input  serial_in,
    output serial_out,

    input  [7:0] gpio_in,
    output [7:0] gpio_out,
    output [7:0] gpio_oeb,
    
    input io_cslt,
    input io_clk,
    input io_rst,

    input  clk,
    input  rst
);

wire mxck;
wire mxrt;

assign mxck = io_cslt ? io_clk : clk ;
assign mxrt = io_cslt ? io_rst : rst ;

rv151_soc soc (
    .io_bcf(io_bcf),
    .io_scs(io_scs),
    .io_sdi(io_sdi),
    .io_sdo(io_sdo),
    .io_sck(io_sck),
    .io_hlt(io_hlt),
    .io_irc(io_irc),
    .serial_in(serial_in),
    .serial_out(serial_out),
    .gpio_in(gpio_in),
    .gpio_out(gpio_out),
    .gpio_oeb(gpio_oeb),
    .clk(mxck),
    .rst(mxrt)
);

endmodule