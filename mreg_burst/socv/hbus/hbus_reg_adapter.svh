`ifndef hbus_reg_adapter_sv
`define hbus_reg_adapter_sv
class hbus_reg_adapter extends uvm_reg_adapter;
    
    `uvm_object_utils(hbus_reg_adapter)
    
    function new (string name="hbus_reg_adapter");
        super.new(name);
        // Does the protocol the Agent is modeling support byte enables?
        // 0 = NO
        // 1 = YES
        supports_byte_enable = 0;
        
        // Does the Agent's Driver provide separate response sequence items?
        // i.e. Does the driver call seq_item_port.put()
        // and do the sequences call get_response()?
        // 0 = NO
        // 1 = YES
        provides_responses = 1;
    endfunction

    function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
        hbus_seq_item trans_h = hbus_seq_item::type_id::create("trans_h");
        trans_h.kind=rw.kind;
        trans_h.addr=rw.addr;
        trans_h.data=new[1];
        trans_h.data[0]=rw.data;
        return trans_h;
    endfunction: reg2bus

    function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        hbus_seq_item trans_h;
        if (!$cast(trans_h, bus_item)) begin
            `uvm_fatal("NOT_BUS_TYPE", "Provided bus_item is not of correct type")
            return;
        end
        `uvm_info(get_name(), $sformatf("\n%s",trans_h.convert2string()), UVM_MEDIUM)
        
        rw.kind=trans_h.kind;
        rw.addr=trans_h.addr;
        rw.data=trans_h.data[0];
        rw.status=UVM_IS_OK;
    endfunction: bus2reg
    
endclass: hbus_reg_adapter
`endif //hbus_reg_adapter_sv