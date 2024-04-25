`ifndef hbus_seq_list_sv
`define hbus_seq_list_sv
class hbus_base_seq extends uvm_sequence # (hbus_seq_item);
    `uvm_object_utils(hbus_base_seq)
    function new (string name="hbus_base_seq");
        super.new(name);
    endfunction
endclass

class hbus_write_seq extends hbus_base_seq;
    `uvm_object_utils(hbus_write_seq)
    function new (string name="hbus_write_seq");
        super.new(name);
    endfunction
    task body();
        `uvm_do_with(req, {req.kind==UVM_WRITE;})
    endtask
endclass

class hbus_write_ctrl_p0 extends hbus_base_seq;
    `uvm_object_utils(hbus_write_ctrl_p0)
    function new (string name="hbus_write_ctrl_p0");
        super.new(name);
    endfunction
    task body();
        `uvm_do_with(req, {req.kind==UVM_WRITE; req.addr==0;})
    endtask
endclass

class hbus_write_ctrl_p1 extends hbus_base_seq;
    `uvm_object_utils(hbus_write_ctrl_p1)
    function new (string name="hbus_write_ctrl_p1");
        super.new(name);
    endfunction
    task body();
        `uvm_do_with(req, {req.kind==UVM_WRITE; req.addr==1;})
    endtask
endclass

class hbus_write_ctrl_p2 extends hbus_base_seq;
    `uvm_object_utils(hbus_write_ctrl_p2)
    function new (string name="hbus_write_ctrl_p2");
        super.new(name);
    endfunction
    task body();
        `uvm_do_with(req, {req.kind==UVM_WRITE; req.addr==2;})
    endtask
endclass

class hbus_write_ctrl_p3 extends hbus_base_seq;
    `uvm_object_utils(hbus_write_ctrl_p3)
    function new (string name="hbus_write_ctrl_p3");
        super.new(name);
    endfunction
    task body();
        `uvm_do_with(req, {req.kind==UVM_WRITE; req.addr==3;})
    endtask
endclass

class hbus_cycle_read_id extends hbus_base_seq;
    `uvm_object_utils(hbus_cycle_read_id)
    function new (string name="hbus_cycle_read_id");
        super.new(name);
    endfunction
    task body();
        repeat (18) `uvm_do_with(req, {req.kind==UVM_READ; req.addr==hbus_types::DEF_ID;})
    endtask
endclass
`endif //hbus_seq_list_sv





