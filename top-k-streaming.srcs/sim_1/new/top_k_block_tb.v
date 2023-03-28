`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 11:50:53 AM
// Design Name: 
// Module Name: top_k_unit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_k_block_tb;

    reg clk, rst, tx_data_TREADY, rx_data_TVALID, rx_data_TLAST;
    reg [31:0] rx_data_TDATA;
    wire [31:0] tx_data_TDATA;
    wire rx_data_TREADY, tx_data_TVALID;
    

    top_k_block UUT ( .clk(clk), .rst(rst), .rx_data_TDATA(rx_data_TDATA), .rx_data_TVALID(rx_data_TVALID), .rx_data_TREADY(rx_data_TREADY), .rx_data_TLAST(rx_data_TLAST),
     .tx_data_TDATA(tx_data_TDATA), .tx_data_TVALID(tx_data_TVALID), .tx_data_TREADY(tx_data_TREADY));
    
    localparam period = 20;
    
    //clk
    always 
    begin
        clk = 1'b1; 
        #5; // high for 20 * timescale = 20 ns

        clk = 1'b0;
        #5; // low for 20 * timescale = 20 ns
    end
    
    //test
    initial // initial block executes only once
    begin
        
        rst = 1;
        tx_data_TREADY  = 0;
        rx_data_TVALID = 0;
        rx_data_TDATA = 0;
        rx_data_TLAST = 0;
        #period; // wait for period 
                
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd1;
        rx_data_TLAST = 0;
        #period;

        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd2;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd3;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd4;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd5;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd6;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd7;
        rx_data_TLAST = 1;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        rx_data_TDATA = 32'd0;
        rx_data_TLAST = 0;
    end
    
        
endmodule
