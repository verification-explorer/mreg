`ifndef hbus_status_reg_cbs_test_sv
`define hbus_status_reg_cbs_test_sv
class hbus_status_reg_cbs_test extends hbus_base_test;
    
    hbus_reg_block hbus_rm;
    
    uvm_status_e status;
    rand bit [7:0] exp_value;
    rand bit [7:0] real_value;
    
    uvm_reg ctrl_p0;
    uvm_reg ctrl_p1;
    uvm_reg ctrl_p2;
    uvm_reg ctrl_p3;
    uvm_reg status_reg;

    bit ok;
    
    `uvm_component_utils(hbus_status_reg_cbs_test)
    
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
    endfunction
    
    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
        ctrl_p0=hbus_rm.ctrl_p0;
        ctrl_p1=hbus_rm.ctrl_p1;
        ctrl_p2=hbus_rm.ctrl_p2;
        ctrl_p3=hbus_rm.ctrl_p3;
        status_reg=hbus_rm.status;
    endfunction
    
    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        
        ctrl_p0.write(status,0);
        $display(head);
        compare_regs(8'h0e,status_reg.get_mirrored_value());

        ctrl_p1.write(status,0);
        $display(head);
        compare_regs(8'h0c,status_reg.get_mirrored_value());

        ctrl_p2.write(status,0);
        $display(head);
        compare_regs(8'h08,status_reg.get_mirrored_value());

        ctrl_p3.write(status,0);
        $display(head);
        compare_regs(8'h00,status_reg.get_mirrored_value());
        
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_status_reg_cbs_test_sv