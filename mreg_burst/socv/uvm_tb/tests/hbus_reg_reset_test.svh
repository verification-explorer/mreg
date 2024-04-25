`ifndef hbus_reg_reset_test_sv
`define hbus_reg_reset_test_sv
class hbus_reg_reset_test extends hbus_base_test;

    uvm_reg_hw_reset_seq reset_seq;

    `uvm_component_utils(hbus_reg_reset_test)

    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        uvm_reg::include_coverage("*", UVM_NO_COVERAGE);
        reset_seq=uvm_reg_hw_reset_seq::type_id::create("reset_seq");
    endfunction

    function void end_of_elaboration_phase (uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info(get_name(), $sformatf("%s",env.hbus_rm.get_full_name()), UVM_MEDIUM)
        `uvm_info(get_name(), $sformatf("%s%s",env.hbus_rm.get_full_name(),env.hbus_rm.id_register.get_full_name()), UVM_MEDIUM)
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".id_register"},"NO_REG_TESTS", 1, this);
        uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".bitwise_and"},"NO_REG_TESTS", 1, this);
        // uvm_resource_db#(bit)::set({"REG::",env.hbus_rm.get_full_name(),".id_register"},"NO_REG_HW_RESET_TEST", 1, this);
    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_name(), "Start run phase", UVM_MEDIUM)
        phase.phase_done.set_drain_time(this, 5);
        phase.raise_objection(this);
        reset_seq.model=env.hbus_rm;
        reset_seq.start(null);
        phase.drop_objection(this);
    endtask
endclass
`endif //hbus_reg_reset_test_sv