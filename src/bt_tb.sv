////////////////////////////////////////////////////////////
// testbench
////////////////////////////////////////////////////////////

import helperPKG::*;

module top_tb( ); // no signals -- tb

    logic clk, reset, go;
    logic loopback1;
    logic loopback2;

    initial begin
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " << Sim Starting >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        $display(       " <<              >> ");
        clk = 0;
        reset = 0;
        #20ns reset = 1;
        go = 0; 
        #12ns go = 1;
        end

    always #10ns clk = ~clk; // 50 MHz

    const char init1 [7:0] = '{ default:'{"Z", 0}, 0:'{"A", 1}, 1:'{"B",1}, 2:'{"C",1} };  
    const char init2 [7:0] = '{ default:'{"", 0}, 0:'{"R", 1'b1} , 1:'{"B",1}, 2:'{"C",1}};

    Bluetooth uut1(
        .clk      ( clk         ), 
        .reset    ( reset       ), 
        .tx       ( loopback1   ),
        .rx       ( loopback2   ) );

    Bluetooth uut2(
        .clk     ( clk         ), 
        .reset   ( reset       ), 
        .tx      ( loopback2   ),
        .rx      ( loopback1   ) );

    endmodule
