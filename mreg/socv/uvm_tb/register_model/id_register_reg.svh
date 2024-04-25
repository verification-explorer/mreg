`ifndef id_register_reg_sv
`define id_register_reg_sv
class id_register_reg extends uvm_reg;
    
    id_register_field F1;

    `uvm_object_utils(id_register_reg)

    function new(string name = "id_register_reg");
        super.new(name, 8, UVM_NO_COVERAGE);
    endfunction: new

    virtual function void build();
        F1 = id_register_field::type_id::create("F1",,get_full_name());
        F1.configure( 
            .parent                 ( this ),
            .size                   ( 8    ),
            .lsb_pos                ( 0    ),
            .access                 ( "RW" ),
            .volatile               ( 0    ),
            .reset                  ( hbus_types::ST0),
            .has_reset              ( 1    ),
            .is_rand                ( 0    ),
            .individually_accessible( 0    ) );
    endfunction: build
    
endclass : id_register_reg
`endif //id_register_reg_sv