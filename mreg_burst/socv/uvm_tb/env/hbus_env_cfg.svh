`ifndef hbus_env_cfg_sv
`define hbus_env_cfg_sv
class hbus_env_cfg extends uvm_object;
    
    hbus_cfg m_hbus_cfg_main;
    hbus_cfg m_hbus_cfg_secondary;
    
    `uvm_object_utils(hbus_env_cfg)
    
    function new (string name="hbus_env_cfg");
        super.new(name);
    endfunction
    
endclass
`endif //hbus_env_cfg_sv
