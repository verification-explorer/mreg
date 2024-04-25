`ifndef hbus_seqr_sv
`define hbus_seqr_sv
class hbus_seqr extends uvm_sequencer #(hbus_seq_item);

    `uvm_component_utils(hbus_seqr)

    function new (string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass
`endif //hbus_seqr_sv