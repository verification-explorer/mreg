`ifndef hbus_reg_access_test_sv
`define hbus_reg_access_test_sv
class hbus_reg_access_test extends hbus_base_test;

    uvm_reg_access_seq access_seq;

    hbus_reg_block hbus_rm;

    `uvm_component_utils(hbus_reg_access_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
        access_seq=uvm_reg_access_seq::type_id::create("access_seq");
    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".id_register"},"NO_REG_TESTS", 1, this);
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".bitwise_and"},"NO_REG_TESTS", 1, this);
        // uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".id_register"},"NO_REG_HW_RESET_TEST", 1, this);
    endfunction

    function void start_of_simulation_phase (uvm_phase phase);
        super.start_of_simulation_phase(phase);
        hbus_rm=env.hbus_rm;
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        access_seq.model=env.hbus_rm;
        access_seq.start(null);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_reg_access_test_sv