`ifndef hbus_test_sv
`define hbus_test_sv
class hbus_test extends hbus_base_test;

    hbus_write_ctrl_p0 write_ctrl_p0;
    hbus_write_ctrl_p1 write_ctrl_p1;
    hbus_write_ctrl_p2 write_ctrl_p2;
    hbus_write_ctrl_p3 write_ctrl_p3;
    hbus_cycle_read_id cycle_read_id;

    `uvm_component_utils(hbus_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        write_ctrl_p0=hbus_write_ctrl_p0::type_id::create("write_ctrl_p0", this);
        write_ctrl_p1=hbus_write_ctrl_p1::type_id::create("write_ctrl_p1", this);
        write_ctrl_p2=hbus_write_ctrl_p2::type_id::create("write_ctrl_p2", this);
        write_ctrl_p3=hbus_write_ctrl_p3::type_id::create("write_ctrl_p3", this);
        cycle_read_id=hbus_cycle_read_id::type_id::create("hbus_cycle_read_id", this);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        write_ctrl_p0.start(env.agnt_main.seqr);
        // write_ctrl_p1.start(env.agnt_main.seqr);
        // write_ctrl_p2.start(env.agnt_main.seqr);
        // write_ctrl_p3.start(env.agnt_main.seqr);
        // cycle_read_id.start(env.agnt_main.seqr);
        repeat (2) @ (posedge env.agnt_main.drv.m_hbus_if.clk);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_test_sv