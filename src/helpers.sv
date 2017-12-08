////////////////////////////////////////////////////////////
// Joshua Reed
////////////////////////////////////////////////////////////


package helperPKG;

    // Char type.
    typedef struct{
        logic [7:0] data;
        logic       val;
        } char;
    
    // Char array.
    typedef char char_arr [7:0];
    
    // Insert an element at the right side of a register. 
    task insert_right(inout char_arr arr, input logic [7:0] data, input logic val );
        arr[7:1] = arr[6:0];
        arr[0].data = data;
        arr[0].val = val;
        return;
        endtask
        
    // Insert an element at the left side of a register. 
    task insert_left(inout char_arr arr, input logic [7:0] data, input logic val );
        arr[6:0] =  arr[7:$right(arr)+1];
        arr[7].data = data;
        return;
        endtask

endpackage

