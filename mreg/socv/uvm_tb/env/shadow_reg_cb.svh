`ifndef shadow_reg_cb_sv
`define shadow_reg_cb_sv
class shadow_reg_cb extends uvm_reg_cbs;
    
    shadow_reg shadow;
    
    `uvm_object_utils(shadow_reg_cb)
    
    function new (string name="shadow_reg_cb");
        super.new(name);
    endfunction
    
    virtual task post_write(uvm_reg_item rw);
        `uvm_info("post_write", rw.convert2string(), UVM_HIGH)
        shadow.shadow.predict(rw.value[0][7:0]);
    endtask

endclass: shadow_reg_cb

`endif //shadow_reg_cb_sv






