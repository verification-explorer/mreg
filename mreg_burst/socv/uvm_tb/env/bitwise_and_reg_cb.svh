`ifndef bitwise_and_reg_cb_sv
`define bitwise_and_reg_cb_sv
class bitwise_and_reg_cb extends uvm_reg_cbs;
    
    `uvm_object_utils(bitwise_and_reg_cb)
    
    function new (string name="bitwise_and_reg_cb");
        super.new(name);
    endfunction
    
    function void post_predict (
        input uvm_reg_field fld,
        input uvm_reg_data_t previous,
        inout uvm_reg_data_t value,
        input uvm_predict_e kind,
        input uvm_path_e path,
        input uvm_reg_map map
        );
        `uvm_info(get_name(), $sformatf("@post_predict before value change value=%0h, previous=%0h",value,previous), UVM_MEDIUM)
        value=value & previous;
        `uvm_info(get_name(), $sformatf("@post_predict after value change value=%0h, previous=%0h",value,previous), UVM_MEDIUM)
    endfunction
    
endclass: bitwise_and_reg_cb

`endif //bitwise_and_reg_cb_sv






