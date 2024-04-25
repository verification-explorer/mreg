`ifndef hbus_mntr_sv
`define hbus_mntr_sv
class hbus_mntr extends uvm_monitor;

    hbus_cfg m_hbus_cfg;
    
    virtual hbus_if m_hbus_if;
    
    hbus_seq_item monitem;
    
    uvm_analysis_port #(hbus_seq_item) mon_ap;
    
    `uvm_component_utils(hbus_mntr)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
        mon_ap=new("mon_ap", this);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(hbus_cfg)::get(this,"","m_hbus_cfg",m_hbus_cfg)) `uvm_fatal(get_name(), "Failed to get hbus interface")
        m_hbus_if=m_hbus_cfg.m_hbus_if;
        monitem = hbus_seq_item::type_id::create("monitem");
        monitem.source=get_name();
    endfunction
    
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        wait_for_reset();
        get_trans();
    endtask
    
    task wait_for_reset();
        @ (posedge m_hbus_if.rstn);
        @ (posedge m_hbus_if.clk);
    endtask
    
    task get_trans();
        forever begin
            @ (posedge m_hbus_if.hen);
            @ (posedge m_hbus_if.clk);
            if (m_hbus_if.hwr_rd) begin
                monitem.kind = UVM_WRITE;
                monitem.data = m_hbus_if.hdata;
                monitem.addr = m_hbus_if.haddr;
            end else begin
                @ (posedge m_hbus_if.clk);
                monitem.kind = UVM_READ;
                monitem.data = m_hbus_if.hdata;
                monitem.addr = m_hbus_if.haddr;
            end
            @ (negedge m_hbus_if.hen);
            `uvm_info(get_name(), $sformatf("monitor collected \n %s",monitem.convert2string()), UVM_HIGH)
            mon_ap.write(monitem);
        end
    endtask
endclass
`endif //hbus_mntr_sv