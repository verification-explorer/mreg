`ifndef status_reg_cb_sv
`define status_reg_cb_sv
class status_reg_cb extends uvm_reg_cbs;
    
    status_reg status;
    
    bit [1:0] bit_to_change;
    
    `uvm_object_utils(status_reg_cb)
    
    function new (string name="status_reg_cb");
        super.new(name);
    endfunction
    
    virtual task post_write(uvm_reg_item rw);
        `uvm_info("post_write", rw.convert2string(), UVM_HIGH)
        status.en_port[bit_to_change].predict(rw.value[0][0]);
    endtask
    
    virtual function void set_bit_to_change(bit [1:0] bit_to_change);
        this.bit_to_change=bit_to_change;
    endfunction
    
endclass: status_reg_cb

`endif //status_reg_cb_sv






