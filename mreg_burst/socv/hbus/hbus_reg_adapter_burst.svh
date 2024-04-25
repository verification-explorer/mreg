`ifndef hbus_reg_adapter_burst_sv
`define hbus_reg_adapter_burst_sv
class hbus_reg_adapter_burst extends hbus_reg_adapter;
    
    `uvm_object_utils(hbus_reg_adapter_burst)
    
    function new (string name="hbus_reg_adapter_burst");
        super.new(name);
    endfunction

    function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
        
        hbus_seq_item trans_h = hbus_seq_item::type_id::create("trans_h");
        
        uvm_reg_item item = get_item();
		
        hbus_extension ext;
		
        uvm_reg regs[];
		
        uvm_reg_addr_t offset;
		
        uvm_reg_data_t data[];
        
        if (item.extension == null || !$cast(ext, item.extension)) return super.reg2bus(rw);
        
        regs = new[ext.burst_size];
		
        if (!$cast(regs[0], item.element)) `uvm_fatal("CASTERR", "Expecting a reg")

        offset = regs[0].get_offset(item.map);
		
        data = new[ext.burst_size];
		
        `uvm_info(get_name(),$sformatf("ext.burst_size=%0d",ext.burst_size),UVM_HIGH)
		
        for (int i = 0; i < ext.burst_size; i++) begin
			regs[i] = item.map.get_reg_by_offset(offset + i);
		end

		foreach (regs[i]) data[i] = regs[i].get();
        
        trans_h.burst_size=ext.burst_size;
        trans_h.kind=rw.kind;
        trans_h.addr=rw.addr;
        trans_h.data=new[ext.burst_size];

        foreach(trans_h.data[i]) trans_h.data[i] = data[i];
        
        return trans_h;
    endfunction: reg2bus

endclass: hbus_reg_adapter_burst
`endif //hbus_reg_adapter_burst_sv