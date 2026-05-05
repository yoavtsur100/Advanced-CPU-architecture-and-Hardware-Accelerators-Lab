onerror {resume}
add list -width 13 /tb_top/rst
add list /tb_top/ena
add list /tb_top/clk
add list /tb_top/x
add list /tb_top/DetectionCode
add list /tb_top/detector
configure list -usestrobe 0
configure list -strobestart {0 ps} -strobeperiod {0 ps}
configure list -usesignaltrigger 1
configure list -delta collapse
configure list -signalnamewidth 0
configure list -datasetprefix 0
configure list -namelimit 5
