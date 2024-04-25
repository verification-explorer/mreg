`ifndef sys_pkg_sv
`define sys_pkg_sv
package sys_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import hbus_types_pkg::*;
    import hbus_reg_pkg::*;
    import hbus_pkg::*;

    // CALLBACKS
    `include "env/bitwise_and_reg_cb.svh"
    `include "env/status_reg_cb.svh"
    `include "env/shadow_reg_cb.svh"

    `include "env/hbus_env_cfg.svh"
    `include "env/hbus_env.svh"
    `include "tests/hbus_base_test.svh"
    `include "tests/hbus_test.svh"
    `include "tests/hbus_reg_test.svh"
    `include "tests/hbus_reg_reset_test.svh"
    `include "tests/hbus_reg_bit_bash_test.svh"
    `include "tests/hbus_reg_access_test.svh"
    `include "tests/hbus_reg_api_test.svh"
    `include "tests/hbus_status_reg_cbs_test.svh"
    `include "tests/hbus_quirky_reg_test.svh"
    `include "tests/hbus_bitwise_and_test.svh"
    `include "tests/hbus_maps_test.svh"
    `include "tests/hbus_burst_seq_test.svh"
endpackage
`endif //sys_pkg_sv