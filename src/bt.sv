////////////////////////////////////////////////////////////
// Bluetooth HC-05 Implementation
// By Joshua Reed
////////////////////////////////////////////////////////////
//
// DE0 Information
// 
// LEDS are active high.

import helperPKG::*;

/////////////////////////////////////////////////////////////
// TOP
////////////////////////////////////////////////////////////
module Bluetooth(input  logic clk, reset, rx, increment,
           output logic unsigned [7:0] leds,
           output logic tx);

    logic rx_clk, baud_clk;
    logic tx_done, prev_tx_done;
    logic rx_drdy, prev_rx_drdy;
    logic send_next_byte;
    logic load_next_byte;
    logic send;
    const char init [7:0] = '{default:'{"Z", 0}, 2:'{"C", 1'b1}, 3:'{"B", 1'b1}, 4:'{"A", 1'b1} };

        
    char_arr receive_buffer;
    char_arr send_buffer;
    logic [7:0] received_byte;

    assign leds = receive_buffer[7].data;

    // sequential logic 
    always_ff@(posedge rx_clk, negedge reset) begin
        if (~reset) 
            send_buffer = init;
        else if (receive_buffer[7].data == "R") begin
            send_buffer = init;
            insert_right(receive_buffer, 0, 1'b0);
            end
        else if (send_next_byte || send_buffer[7].val == 1'b0) insert_right(send_buffer, 0, 1'b0);
          
        if (~reset) receive_buffer = '{ default:'{" ", 1'b0} };
        else if (load_next_byte) insert_left(receive_buffer, received_byte, 1'b1);
       
        if(~reset) prev_tx_done <= 0;
        else prev_tx_done <= tx_done;

        if(~reset) prev_rx_drdy <= 0;
        else prev_rx_drdy <= rx_drdy;

        if(~reset) send <= 0;
        else if (send_buffer[6].val == 1) send <= 1;
        else if (tx_done == 0) send <= 0;

        end

    // combinational logic 
    always_comb begin
        if (tx_done == 1 && prev_tx_done == 0) send_next_byte <= 1;
        else                                   send_next_byte <= 0;
        if (rx_drdy == 1 && prev_rx_drdy == 0) load_next_byte <= 1;
        else                                   load_next_byte <= 0;
        end
    

    // uart pll
    baud_gen pll(
	    .inclk0 ( clk      ), //   50 Mhz DE0-Nano Crystal Oscillator Clock
	    .c0     ( baud_clk ), //   9600hz baud Clock
	    .c1     ( rx_clk ) ); // 153600hz rx Clock
	  
    // 9600 baud uart 
    uart uart_inst( 
        .baud_clk ( baud_clk ),
        .rx_clk   ( rx_clk   ),
        .reset    ( reset    ),
        .send     ( send     ), // set to 1 to send data
        .rx_drdy  ( rx_drdy  ),
        .rx       ( rx       ),
        .tx       ( tx       ),
        .to_send  ( send_buffer[7].data ),
        .tx_done  ( tx_done  ),
        .received ( received_byte ) );

    endmodule
