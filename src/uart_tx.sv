////////////////////////////////////////////////////////////
// tx module
////////////////////////////////////////////////////////////
module tx(input  logic          clk, reset, send, 
          input  unsigned [7:0] to_send, 
          output logic          tx, tx_done ); 
    
    logic unsigned [3:0] cnt;
    logic unsigned [7:0] send_reg;

    // data send_reg control
    always_ff@(posedge clk, negedge reset)
        if (~reset) send_reg <= 0;
        else if (cnt == 9) send_reg <= to_send; // load 
        else send_reg <= {send_reg[0], send_reg[7:1]};  // rotate

    // count down timer 
    always_ff@(posedge clk, negedge reset)
        if (~reset) cnt <= 0; // tx_done countdown timer
        else if (send && cnt == 0) cnt <= 9; // reload count down timer
        else if (cnt != 4'b0) cnt <= cnt - 4'b1; // count down

    // data out (tx) enabling
    always_comb  
        case(cnt) 
            0 : tx <= 1; // stop bit
            9 : tx <= 0; // start bit
            default : tx <= send_reg[0];
            endcase

    //always_comb  
    //    if (cnt != 0) sending <= 1;
    //    else          sending <= 0;

    always_comb 
        if (cnt == 0) tx_done <= 1;
        else          tx_done <= 0;

    endmodule

    //////////
    // instantiation template
    //////////
    // tx tx_1( 
    //     .clk      ( ), 
    //     .reset    ( ),
    //     .go       ( ),
    //     .to_send  ( ),
    //     .tx       ( ),
    //     .tx_done     ( ) );
    //
