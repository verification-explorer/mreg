`ifndef uvm_reg_field_ext_sv
`define uvm_reg_field_ext_sv
class uvm_reg_field_ext extends uvm_reg_field;
    
    `uvm_object_utils(uvm_reg_field_ext)
    
    function new (string name="uvm_reg_field_ext");
        super.new(name);
    endfunction
    
    task pre_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_read hook was activate in field %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_read(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_read hook was activate in field %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask
    
    task pre_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("pre_write hook was activate in field %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

    task post_write(uvm_reg_item rw);
        `uvm_info(get_name(), $sformatf("post_write hook was activate in field %s\n uvm_reg_item %s\n", get_name(), rw.convert2string()), UVM_MEDIUM)
    endtask

endclass

`endif //uvm_reg_field_ext_sv