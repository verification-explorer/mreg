`ifndef hbus_reg_pkg_sv
`define hbus_reg_pkg_sv
package hbus_reg_pkg;
    
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import hbus_types_pkg::*;

    // Fields
    //`include "uvm_reg_field_ext.svh"
    `include "id_register_field.svh"

    // Main Registers    
    `include "ctrl_p0_reg.svh"
    `include "ctrl_p1_reg.svh"
    `include "ctrl_p2_reg.svh"
    `include "ctrl_p3_reg.svh"
    `include "status_reg.svh"
    `include "ro_reg.svh"
    `include "bitwise_and_reg.svh"
    `include "id_register_reg.svh"

    // Secondary register
    `include "gp_one_reg.svh"
    `include "shadow_reg.svh"

    // Register block
    `include "hbus_reg_block.svh"

endpackage
`endif //hbus_reg_pkg_sv