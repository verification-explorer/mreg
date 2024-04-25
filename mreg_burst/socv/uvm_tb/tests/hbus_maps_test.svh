`ifndef hbus_maps_test_sv
`define hbus_maps_test_sv
class hbus_maps_test extends hbus_base_test;

    hbus_reg_block hbus_rm;

    uvm_status_e status;

    bit [7:0] value;

    uvm_reg ctrl_p0;
    uvm_reg ctrl_p1;
    uvm_reg gp_one;

    uvm_reg_hw_reset_seq reset_seq;
    uvm_reg_bit_bash_seq bit_bash_seq;
    uvm_reg_access_seq access_seq;

    `uvm_component_utils(hbus_maps_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        reset_seq=uvm_reg_hw_reset_seq::type_id::create("reset_seq");
        bit_bash_seq=uvm_reg_bit_bash_seq::type_id::create("bit_bash_seq");
        access_seq=uvm_reg_access_seq::type_id::create("access_seq");
    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".id_register"},"NO_REG_TESTS", 1, this);
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".bitwise_and"},"NO_REG_TESTS", 1, this);
    endfunction

    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
        ctrl_p0=hbus_rm.ctrl_p0;
        ctrl_p1=hbus_rm.ctrl_p1;
        gp_one=hbus_rm.gp_one;
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);

        @ (posedge env.agnt_main.drv.m_hbus_if.rstn);
        @ (posedge env.agnt_main.drv.m_hbus_if.clk);

        reset_seq.model=env.hbus_rm;
        reset_seq.start(null);

        bit_bash_seq.model=env.hbus_rm;
        bit_bash_seq.start(null);

        access_seq.model=env.hbus_rm;
        access_seq.start(null);
        
        hbus_rm.ctrl_p0.write(status,8'hAA);
        hbus_rm.ctrl_p0.read(status,value,UVM_FRONTDOOR,hbus_rm.hbus_reg_block_secondary_map);
        compare_regs(8'h0AA,value);

        hbus_rm.ctrl_p0.write(status,8'hBA,UVM_FRONTDOOR,hbus_rm.hbus_reg_block_secondary_map);
        hbus_rm.ctrl_p0.read(status,value);
        compare_regs(8'hBA,value);

        hbus_rm.gp_one.write(status,8'hC2);
        hbus_rm.gp_one.read(status,value,UVM_BACKDOOR);
        compare_regs(8'hC2,value);

        hbus_rm.ctrl_p1.write(status,8'hAA);
        value=hbus_rm.shadow.get_mirrored_value();
        compare_regs(8'hAA,value);

        repeat (2) @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_maps_test_sv