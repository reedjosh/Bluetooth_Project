////////////////////////////////////////////////////////////
// uart 
////////////////////////////////////////////////////////////
module uart(input  logic                baud_clk, rx_clk, reset, rx, send,
            input  logic unsigned [7:0] to_send,
            output logic                rx_drdy, tx, tx_done,
            output logic unsigned [7:0] received );

    // uart receiver 
    rx rx_1( 
        .clk            ( rx_clk ), // faster clock for data recovery
        .reset          ( reset        ),
        .rx             ( rx           ),
        .rx_drdy        ( rx_drdy      ),
        .received       ( received     ) );

    // uart transmitter
    tx tx_1( 
        .clk      ( baud_clk ), 
        .reset    ( reset    ),
        .send     ( send     ),
        .to_send  ( to_send  ),
        .tx       ( tx       ),
        .tx_done  ( tx_done  ) );

    endmodule

    //////////
    // instantiation template
    //////////
    // uart uart_inst( 
    //     .baud_clk(),
    //     .rx_clk(),
    //     .reset(),
    //     .rx(),
    //     .go(),
    //     .to_send()
    //     .tx(),
    //     .tx_done(),
    //     .received() );
    //





 
      
      












