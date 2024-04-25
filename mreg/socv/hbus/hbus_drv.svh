`ifndef hbus_drv_sv
`define hbus_drv_sv
class hbus_drv extends uvm_driver #(hbus_seq_item);
    
    hbus_cfg m_hbus_cfg;
    
    virtual hbus_if m_hbus_if;

    hbus_seq_item rsp;

    `uvm_component_utils(hbus_drv)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(hbus_cfg)::get(this,"","m_hbus_cfg",m_hbus_cfg)) `uvm_fatal(get_name(), "Failed to get hbus interface")
        m_hbus_if=m_hbus_cfg.m_hbus_if;
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        wait_for_reset();
        drive();
    endtask

    task wait_for_reset();
        @ (posedge m_hbus_if.rstn);
        @ (posedge m_hbus_if.clk);
    endtask

    task drive ();
        forever begin
            seq_item_port.get_next_item(req);
            req.source=$sformatf("%s_req",get_name());
            
            // seq_item_port.get(req);
            // if(!$cast(rsp,req.clone())) `uvm_fatal(get_name(), "failed to cast response")
            // rsp.set_id_info(req);
            // rsp.data=8'hFF;
            // rsp.source=$sformatf("%s_rsp",get_name());
            // req.source=$sformatf("%s_req",get_name());

            `uvm_info(get_name(), $sformatf("driver start transaction %s",req.convert2string()), UVM_HIGH)
            
            @ (negedge m_hbus_if.clk);
            if (req.kind==UVM_WRITE) begin
                m_hbus_if.hen <= 1'b1;
                m_hbus_if.hwr_rd <= 1'b1;
                m_hbus_if.haddr <= req.addr;
                m_hbus_if.hdata_reg <= req.data;
                @ (negedge m_hbus_if.clk);
                m_hbus_if.hen <= 1'b0;
                m_hbus_if.hwr_rd <= 1'b0;
                m_hbus_if.haddr <= 'h0;
            end 
            else if (req.kind==UVM_READ) begin
                m_hbus_if.hen <= 1'b1;
                m_hbus_if.haddr <= req.addr;
                m_hbus_if.hwr_rd <= 1'b0;
                @ (negedge m_hbus_if.clk);
                @ (posedge m_hbus_if.clk);
                req.data <= m_hbus_if.hdata;
                @ (negedge m_hbus_if.clk);
                m_hbus_if.hen <= 1'b0;
                m_hbus_if.haddr <= 'h0;
            end
            else begin
                `uvm_info(get_name(), $sformatf("%s is not allowd",req.kind.name()), UVM_HIGH)
            end
            @ (posedge m_hbus_if.clk);
            
            // seq_item_port.put(rsp);
            seq_item_port.item_done();
        end
    endtask
endclass
`endif //hbus_drv_sv