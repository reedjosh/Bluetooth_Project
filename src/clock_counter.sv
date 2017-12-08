////////////////////////////////////////////////////////////
// clock counter
////////////////////////////////////////////////////////////
module clk_cntr( input  logic clk, reset,
                 input  int   cnt_to,
                 output logic clk_o );

    logic unsigned [20:0] cnt;

    always_ff @(posedge clk, negedge reset) 
        if (~reset) cnt <= 0; 
        else if (cnt == 0) cnt <= cnt_to-1; 
        else cnt <= cnt - 1;

    // alternate the clock
    always_ff @(posedge clk, negedge reset) 
        if (~reset) clk_o <= 0;
        else if (cnt == 0) clk_o <= ~clk_o;

    endmodule

    //////////
    // instantiation template
    //////////
    // clk_cntr cc(
    //     .clk      ( ), 
    //     .reset    ( ),
    //     .cnt_to   ( ),
    //     .clk_o    ( )  );
    //

