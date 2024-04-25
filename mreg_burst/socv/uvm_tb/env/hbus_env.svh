`ifndef hbus_env_sv
`define hbus_env_sv
class hbus_env extends uvm_env;

    virtual hbus_if m_hbus_main_if;
    
    // Objects
    hbus_env_cfg m_hbus_env_cfg;

    // Components
    hbus_agnt agnt_main;
    hbus_agnt agnt_secondary;
    
    // RAL
    hbus_reg_block hbus_rm;
    hbus_reg_adapter hbus2reg;
    hbus_reg_adapter hbus2reg_s;
    uvm_reg_predictor#(hbus_seq_item) hbus2reg_predictor;
    uvm_reg_predictor#(hbus_seq_item) hbus2reg_predictor_s;

    // Callback
    bitwise_and_reg_cb m_bitwise_and_reg_cb;
    status_reg_cb status_reg_callback_p0;
    status_reg_cb status_reg_callback_p1;
    status_reg_cb status_reg_callback_p2;
    status_reg_cb status_reg_callback_p3;
    shadow_reg_cb shadow_reg_callback;
    
    `uvm_component_utils_begin(hbus_env)
    `uvm_field_object(hbus_rm,UVM_ALL_ON)
    `uvm_component_utils_end
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);

        set_type_override_by_type(hbus_reg_adapter::get_type(),hbus_reg_adapter_burst::get_type());

        // Get virtual interface
        if(!uvm_config_db#(hbus_env_cfg)::get(this,"","m_hbus_env_cfg",m_hbus_env_cfg)) `uvm_fatal(get_name(), "Failed to get hbus env cfg object")
        m_hbus_main_if=m_hbus_env_cfg.m_hbus_cfg_main.m_hbus_if;
        
        // Create agent
        uvm_config_db#(hbus_cfg)::set(this, "agnt_main*", "m_hbus_cfg", m_hbus_env_cfg.m_hbus_cfg_main);
        agnt_main = hbus_agnt::type_id::create("agnt_main", this);
        
        uvm_config_db#(hbus_cfg)::set(this, "agnt_secondary*", "m_hbus_cfg", m_hbus_env_cfg.m_hbus_cfg_secondary);
        agnt_secondary = hbus_agnt::type_id::create("agnt_secondary", this);

        // Create adapter
        hbus2reg=hbus_reg_adapter::type_id::create("hbus2reg", this);
        hbus2reg_s=hbus_reg_adapter::type_id::create("hbus2reg_s", this);

        // Create Predictor
        hbus2reg_predictor = new("hbus2reg_predictor", this);
        hbus2reg_predictor_s = new("hbus2reg_predictor_s", this);

        // Register model integration implicit mode
        hbus_rm=hbus_reg_block::type_id::create("hbus_rm", this);
        hbus_rm.build();
        hbus_rm.hbus_reg_block_main_map.set_auto_predict(0);
        hbus_rm.hbus_reg_block_secondary_map.set_auto_predict(0);
        uvm_config_db#(hbus_reg_block)::set(null, "*", "hbus_rm", hbus_rm);

        // Bitwise and register callbacks
        m_bitwise_and_reg_cb=bitwise_and_reg_cb::type_id::create("m_bitwise_and_reg_cb");
        uvm_reg_field_cb::add(hbus_rm.bitwise_and.result,m_bitwise_and_reg_cb);
        
        // Status register call back
        status_reg_callback_p0=status_reg_cb::type_id::create("status_reg_callback_p0");
        status_reg_callback_p0.set_bit_to_change(0);
        status_reg_callback_p0.status=hbus_rm.status;
        uvm_reg_cb::add(hbus_rm.ctrl_p0,status_reg_callback_p0);

        status_reg_callback_p1=status_reg_cb::type_id::create("status_reg_callback_p1");
        status_reg_callback_p1.set_bit_to_change(1);
        status_reg_callback_p1.status=hbus_rm.status;
        uvm_reg_cb::add(hbus_rm.ctrl_p1,status_reg_callback_p1);

        status_reg_callback_p2=status_reg_cb::type_id::create("status_reg_callback_p2");
        status_reg_callback_p2.set_bit_to_change(2);
        status_reg_callback_p2.status=hbus_rm.status;
        uvm_reg_cb::add(hbus_rm.ctrl_p2,status_reg_callback_p2);

        status_reg_callback_p3=status_reg_cb::type_id::create("status_reg_callback_p3");
        status_reg_callback_p3.set_bit_to_change(3);
        status_reg_callback_p3.status=hbus_rm.status;
        uvm_reg_cb::add(hbus_rm.ctrl_p3,status_reg_callback_p3);

        shadow_reg_callback=shadow_reg_cb::type_id::create("shadow_reg_callback");
        shadow_reg_callback.shadow=hbus_rm.shadow;
        uvm_reg_cb::add(hbus_rm.ctrl_p1,shadow_reg_callback);

    endfunction

    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        hbus_rm.hbus_reg_block_main_map.set_sequencer(agnt_main.seqr,hbus2reg);
        hbus_rm.hbus_reg_block_secondary_map.set_sequencer(agnt_secondary.seqr,hbus2reg_s);
        hbus2reg_predictor.adapter = hbus2reg;
        hbus2reg_predictor_s.adapter = hbus2reg_s;
        hbus2reg_predictor.map = hbus_rm.hbus_reg_block_main_map;
        hbus2reg_predictor_s.map = hbus_rm.hbus_reg_block_secondary_map;
        agnt_main.mntr.mon_ap.connect(hbus2reg_predictor.bus_in);
        agnt_secondary.mntr.mon_ap.connect(hbus2reg_predictor_s.bus_in);

    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        hbus_rm.hbus_reg_block_main_map.print();
        hbus_rm.hbus_reg_block_secondary_map.print();
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_reg_model();
        join_none;
    endtask

    task reset_reg_model();
        forever begin
            wait(m_hbus_main_if.rstn==0);
            `uvm_info(get_name(), "reset main registers", UVM_MEDIUM)
            hbus_rm.reset();
            wait(m_hbus_main_if.rstn==1);
        end
    endtask
    
endclass
`endif //hbus_env_sv