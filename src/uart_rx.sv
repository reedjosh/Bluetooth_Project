////////////////////////////////////////////////////////////
// rx module
////////////////////////////////////////////////////////////
module rx(input  logic                clk, reset, rx,
          output logic                rx_drdy,
          output logic unsigned [7:0] received );
    
    logic trg, msg_trg, start, stop;
    logic [175:0] sipo; // serial in par out
    logic unsigned [7:0] cnt, prev_cnt;
    logic [13:0] ones   = '{14{1'b1}};
    logic [13:0] zeroes = '{14{1'b0}};

    // shift in rx values
    always_ff@(posedge clk, negedge reset)
        if (~reset) sipo <= '{default:1'b0};
        else sipo <= {sipo[174:0], rx};

    // countdown timer to prevent re-triggering
    always_ff@(posedge clk, negedge reset)
        if (~reset) cnt <= 0;
        else if (trg) cnt <= 158; // hold off -- msg triggered
        else if (cnt != 0) cnt <= cnt - 8'b1;

    always_ff@(posedge clk, negedge reset)
        if (~reset) prev_cnt <= 0;
        else prev_cnt <= cnt; // track countdown reached

    // register data
    // TODO build in a voting system
    always_ff@(posedge clk, negedge reset) 
        if (~reset) received <= 0;
        else if (trg) 
            for(int i=0; i<8; i++) received[7-i] <= sipo[i*16+23]; // 23, 39, 55, etc...
                
    // 'hold off' trg enable
    always_comb
        if (cnt == 0) trg <= msg_trg; // allow message triggering
        else          trg <= 0; // 'hold off' message triggering

    // valid start bit 
    always_comb 
        if (sipo[174:161] == ones  &&  
            sipo[158:145] == zeroes)  start = 1;
        else                          start = 0; 

    // valid stop bit    
    always_comb
        if (sipo[14:1] == ones) stop <= 1;
        else                    stop <= 0;

    // trigger message
    always_comb
        if (start && stop) msg_trg <= 1;
        else               msg_trg <= 0;

    // trigger message
    always_comb
        if (cnt == 0 && prev_cnt == 1) rx_drdy <= 1;
        else                           rx_drdy <= 0;

    endmodule

    //////////
    // instantiation template
    //////////
    // rx rx_1( 
    //     .clk      ( ), // faster clock for data recovery
    //     .reset    ( ),
    //     .rx       ( ),
    //     .received ( )  );
    //
