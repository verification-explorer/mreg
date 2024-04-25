`ifndef hbus_seq_item_sv
`define hbus_seq_item_sv
class hbus_seq_item extends uvm_sequence_item;
    
    rand logic [IfWidth-1:0] data[];
    rand logic [IfWidth-1:0] addr;
    rand uvm_access_e kind;
    int burst_size=1;
    string source="";

    constraint addr_c {addr inside {[0:5]};}

    `uvm_object_utils_begin(hbus_seq_item)
    `uvm_field_array_int(data,UVM_ALL_ON)
    `uvm_field_int(addr,UVM_ALL_ON)
    `uvm_field_enum(uvm_access_e,kind,UVM_ALL_ON)
    `uvm_field_int(burst_size,UVM_ALL_ON)
    `uvm_object_utils_end
    
    function new (string name="hbus_seq_item");
        super.new(name);
    endfunction

    function string convert2string();
        string s="";
        $sformat(s,"\n%s values for hbus seq item %s\n",s,get_name());
        foreach (data[idx]) $sformat(s,"%s data[%0d] %h\n",s,idx,data[idx]);
        $sformat(s,"%s address %h\n",s,addr);
        $sformat(s,"%s kind    %s\n",s,kind.name());
        $sformat(s,"%s burst_size %0d\n",s,burst_size);
        $sformat(s,"%s source  %s\n",s,source);
        return s;
    endfunction
endclass
`endif //hbus_item_sv