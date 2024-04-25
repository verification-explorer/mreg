`ifndef hbus_extension_sv
`define hbus_extension_sv
class hbus_extension extends uvm_object;
    
    int burst_size;
    
    `uvm_object_utils(hbus_extension)
    
    function new (string name="hbus_extension");
        super.new(name);
    endfunction
    
endclass
`endif //hbus_extension_sv