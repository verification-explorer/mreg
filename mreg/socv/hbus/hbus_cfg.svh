`ifndef hbus_cfg_sv
`define hbus_cfg_sv
class hbus_cfg extends uvm_object;
    
    virtual hbus_if m_hbus_if;
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    `uvm_object_utils(hbus_cfg)
    
    function new (string name="hbus_cfg");
        super.new(name);
    endfunction
    
endclass
`endif //hbus_cfg_sv