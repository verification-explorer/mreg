`ifndef hbus_types_pkg_sv
`define hbus_types_pkg_sv
package hbus_types_pkg;
    parameter int IfWidth = 8;
    class hbus_types;
        typedef enum bit {DIS, EN} en_dis_e;
        typedef enum bit [1:0] {AF, AT, BT, HT} climit_e;
        typedef enum bit [1:0] {T32, T34, T42, T47} vlimit_e;
        typedef enum bit [2:0] {ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7} status_e;
        typedef enum {DEF_CTRL_P0,DEF_CTRL_P1,DEF_CTRL_P2,DEF_CTRL_P3,DEF_STATUS,DEF_ID} reg_e;
    endclass
endpackage
`endif //hbus_types_pkg_sv