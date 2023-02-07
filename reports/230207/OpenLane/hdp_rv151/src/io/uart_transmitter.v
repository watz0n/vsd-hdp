//From UCB EECS-151 FPGA Lab/Project

module uart_transmitter #(
    parameter CLOCK_FREQ = 125_000_000,
    parameter MIN_BDRT = 9_600,
    parameter BAUD_BITS = $clog2((CLOCK_FREQ+(MIN_BDRT/2)-1) / (MIN_BDRT/2))
)(
    input clk,
    input reset,

    input [BAUD_BITS-1:0] baud_edge,

    input [7:0] data_in,
    input data_in_valid,
    output data_in_ready,

    output serial_out
);
    //with baud_edge input
    localparam CLOCK_COUNTER_WIDTH = BAUD_BITS;

    //--|Declare|--

    wire cb_symbol_edge;
    wire cb_start;
    wire cb_tx_running;

    reg [9:0] rg_tx_shfit;
    reg [3:0] rg_bit_counter;
    reg [CLOCK_COUNTER_WIDTH-1:0] rg_clock_counter;
    
    reg rg_din_rdy;

    //--|CB Assign|--
    
    assign serial_out = rg_tx_shfit[0];
    assign data_in_ready = rg_din_rdy;

    //assign cb_symbol_edge   = rg_clock_counter == SYMBOL_EDGE_TIME;
    assign cb_symbol_edge   = rg_clock_counter == baud_edge; //with baud_edge input

    assign cb_start         = data_in_valid & data_in_ready;
    assign cb_tx_running    = rg_bit_counter != 4'h0;

    //--|SQ Always|--

    always @ (posedge clk) begin
        if(reset) begin
            rg_clock_counter <= 0;
        end
        else begin 
            rg_clock_counter <= (cb_start || cb_symbol_edge) ? 0 : rg_clock_counter + 1;
        end
    end

    always@(posedge clk) begin
        if(reset) begin
            rg_bit_counter <= 'h0;
        end
        else begin
            if(cb_start) begin
                rg_bit_counter <= 'd10;
            end
            else if(cb_symbol_edge&cb_tx_running) begin
                rg_bit_counter <= rg_bit_counter - 4'h1;
            end
        end
    end

    always@(posedge clk) begin
        if(reset) begin
            rg_tx_shfit <= 10'h3FF;
        end
        else begin
            if(cb_start) begin
                rg_tx_shfit <= {1'b1, data_in, 1'b0};
            end
            else if(cb_symbol_edge&cb_tx_running) begin
                rg_tx_shfit <= {1'b1, rg_tx_shfit[1+:9]};
            end
        end
    end

    always@(posedge clk) begin
        if(reset) begin
            rg_din_rdy <= 1'b1;
        end
        else begin
            if(cb_start || cb_tx_running) begin
                rg_din_rdy <= 1'b0;
            end
            else begin
                rg_din_rdy <= 1'b1;
            end
        end
    end

endmodule
