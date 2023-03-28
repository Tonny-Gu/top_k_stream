`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2023 10:50:48 AM
// Design Name: 
// Module Name: top_k_unit
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


module top_k_unit#(
    parameter INTEGER_SIZE = 32

)(
    input wire clk,
    input wire rst,
    input wire [INTEGER_SIZE - 1:0] rx_data_TDATA,
    input wire rx_data_TVALID,
    input wire rx_data_TLAST,
    output wire rx_data_TREADY,
    output wire [INTEGER_SIZE - 1:0] tx_data_TDATA,
    output wire tx_data_TVALID,
    output wire [INTEGER_SIZE - 1:0] register_TDATA,
    output wire register_TVALID,
    input wire tx_data_TREADY,
    output wire tx_data_TLAST
    );
    
    reg [INTEGER_SIZE:0] current_value_TDATA = 0;
    reg current_value_TVALID;
    reg [INTEGER_SIZE:0] tx_data_TDATA_reg = 0;
    reg tx_data_TVALID_reg = 0;
    reg tx_data_TLAST_reg;
    reg rx_data_TREADY_reg;
    
    
    
    always @(posedge clk) begin 
      if(rst == 1) begin
          current_value_TDATA = 0;
          current_value_TVALID = 0;
      end
      
      else begin
    
           if(rx_data_TVALID == 1 && tx_data_TREADY == 1) begin   //receive valid input
           
               tx_data_TLAST_reg = rx_data_TLAST;
               rx_data_TREADY_reg = tx_data_TREADY;   
                     
               if(rx_data_TDATA > current_value_TDATA) begin //input is larger than current value
                    tx_data_TDATA_reg = current_value_TDATA;
                    tx_data_TVALID_reg = 1;
                    current_value_TDATA = rx_data_TDATA;
                    current_value_TVALID = rx_data_TVALID;
               end
               else begin    //input is smaller than current value
                    tx_data_TDATA_reg = rx_data_TDATA;
                    tx_data_TVALID_reg = 1;
               end
                
           end
           
           else begin
             tx_data_TVALID_reg = 0;
           end
    
            
      end
      
    end
    
    assign tx_data_TDATA = tx_data_TDATA_reg;
    assign tx_data_TVALID = tx_data_TVALID_reg;
    assign register_TDATA = current_value_TDATA;
    assign register_TVALID = current_value_TVALID;
    assign tx_data_TLAST = tx_data_TLAST_reg;
    assign rx_data_TREADY = rx_data_TREADY_reg;
    
endmodule
