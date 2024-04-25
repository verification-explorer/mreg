`ifndef hbus_agnt_sv
`define hbus_agnt_sv
class hbus_agnt extends uvm_agent;
    
    hbus_drv drv;
    hbus_seqr seqr;
    hbus_mntr mntr;
    hbus_cfg m_hbus_cfg;
    
    `uvm_component_utils(hbus_agnt)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(hbus_cfg)::get(this,"","m_hbus_cfg",m_hbus_cfg)) `uvm_fatal(get_name(), "Failed to get hbus cfg object")
        mntr=hbus_mntr::type_id::create("mntr", this);
        if (m_hbus_cfg.is_active==UVM_ACTIVE) begin
            drv=hbus_drv::type_id::create("drv", this);
            seqr=hbus_seqr::type_id::create("seqr", this);
        end
    endfunction
    
    function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        if (m_hbus_cfg.is_active==UVM_ACTIVE) begin
            drv.seq_item_port.connect(seqr.seq_item_export);
        end
    endfunction
endclass
`endif //hbus_agnt_sv