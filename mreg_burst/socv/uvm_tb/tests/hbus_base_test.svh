`ifndef hbus_base_test_sv
`define hbus_base_test_sv
class hbus_base_test extends uvm_test;
    
    hbus_cfg m_hbus_cfg_main;
    hbus_cfg m_hbus_cfg_secondary;
    hbus_env_cfg m_hbus_env_cfg;
    hbus_env env;

    string head="\n******************************************************************";
    
    `uvm_component_utils(hbus_base_test)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        m_hbus_env_cfg = hbus_env_cfg::type_id::create("m_hbus_env_cfg");
        m_hbus_cfg_main = hbus_cfg::type_id::create("m_hbus_cfg_main");
        m_hbus_cfg_secondary = hbus_cfg::type_id::create("m_hbus_cfg_secondary");
        
        if(!uvm_config_db#(virtual hbus_if)::get(this, "", "m_hbus_if_main", m_hbus_cfg_main.m_hbus_if)) `uvm_fatal(get_name(), "Failed to get main interface")
        if(!uvm_config_db#(virtual hbus_if)::get(this, "", "m_hbus_if_secondary", m_hbus_cfg_secondary.m_hbus_if)) `uvm_fatal(get_name(), "Failed to get secondary interface")

        m_hbus_env_cfg.m_hbus_cfg_main=m_hbus_cfg_main;
        m_hbus_env_cfg.m_hbus_cfg_secondary=m_hbus_cfg_secondary;

        uvm_config_db#(hbus_env_cfg)::set(this, "env", "m_hbus_env_cfg", m_hbus_env_cfg);

        env = hbus_env::type_id::create("env", this);
    endfunction
    
    function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction
    
    virtual function void compare_regs (uvm_reg_data_t expected_reg,real_reg, string str="");
        if (expected_reg != real_reg) begin 
            `uvm_error(get_name(), 
            $sformatf("\n\n%s\n%s\nexpected register value %0H is different than real register value %0H\n%s\n",head,str,expected_reg,real_reg,head))
        end else begin
            `uvm_info(get_name(), $sformatf("\n\n%s\n%s\nexpected register value %0H is equal to real register value %0H\n%s\n",head,str,expected_reg,real_reg,head), UVM_NONE)
        end
    endfunction
    
endclass
`endif //hbus_base_test_sv