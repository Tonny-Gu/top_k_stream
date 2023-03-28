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


module top_k_unit_tb;

    reg clk, rst, tx_data_TREADY, rx_data_TVALID, rx_data_TLAST;
    reg [31:0] rx_data_TDATA;
    wire [31:0] tx_data_TDATA;
    wire tx_data_TLAST;
    wire rx_data_TREADY, tx_data_TVALID;
    

    top_k_unit UUT ( .clk(clk), .rst(rst), .rx_data_TDATA(rx_data_TDATA), .rx_data_TVALID(rx_data_TVALID), .rx_data_TREADY(rx_data_TREADY), .rx_data_TLAST(rx_data_TLAST),
     .tx_data_TDATA(tx_data_TDATA), .tx_data_TVALID(tx_data_TVALID), .tx_data_TREADY(tx_data_TREADY), .tx_data_TLAST(tx_data_TLAST));
    
    localparam period = 20;
    
    //clk
    always 
    begin
        clk = 1'b1; 
        #10; // high for 20 * timescale = 20 ns

        clk = 1'b0;
        #10; // low for 20 * timescale = 20 nss
    end
    
    //test
    initial // initial block executes only once
    begin
        
        rst = 1;
        tx_data_TREADY  = 0;
        rx_data_TVALID = 0;
        shift = 0;
        rx_data_TDATA = 0;
        rx_data_TLAST = 0;
        #period; // wait for period 
                
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        shift = 0;
        rx_data_TDATA = 32'b100;
        rx_data_TLAST = 0;
        
        #period;

        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        shift = 0;
        rx_data_TDATA = 32'b1100;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 1;
        shift = 0;
        rx_data_TDATA = 32'b10;
        rx_data_TLAST = 0;
        #period;
        
        rst = 0;
        tx_data_TREADY  = 1;
        rx_data_TVALID = 0;
        shift = 1;
        rx_data_TDATA = 32'b10;
        rx_data_TLAST = 0;
        #period;
        
    end
    
        
endmodule
