`ifndef id_register_field_sv
`define id_register_field_sv
class id_register_field extends uvm_reg_field;
    
    int id_register_pointer=0;
    int id_register_pointer_max=8;
    int id_register_value[]='{hbus_types::ST0, hbus_types::ST1, hbus_types::ST2, hbus_types::ST3, hbus_types::ST4, hbus_types::ST5, hbus_types::ST6, hbus_types::ST7};
    int current_value;
    
    `uvm_object_utils(id_register_field)
    
    function new (string name="id_register_field");
        super.new(name);
        current_value=id_register_value[0];
    endfunction
    
    task post_read(uvm_reg_item rw);
        if(value != current_value) begin
            `uvm_error("ID_REG_CHECK", $sformatf("Wrong ID value: id_ptr:%0d id_val:%0h read_value:%0h", id_register_pointer, current_value, value))
        end
        id_register_pointer++;
        if (id_register_pointer >= id_register_pointer_max) begin
            id_register_pointer = 0;
        end
        current_value = id_register_value[id_register_pointer];
    endtask
    
    task post_write(uvm_reg_item rw);
        `uvm_info("post_write", rw.convert2string(), UVM_MEDIUM)
        id_register_pointer = value;
        if (id_register_pointer >= id_register_pointer_max) begin
            id_register_pointer = 0;
        end
        current_value = id_register_value[id_register_pointer];
    endtask
    
endclass

`endif //id_register_field_sv