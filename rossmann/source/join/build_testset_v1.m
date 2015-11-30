clc; clear;

load 'refine_basket/test.ref'; % test_id store_index day_week bool_feat state_hday date_seq

test.test_id = test_id;
test.store_index = store_index;
test.date_seq = date_seq;
test.day_week = day_week;
test.bool_feat = bool_feat;
test.state_hday = state_hday;

save -binary 'data_frame/test.df' test;

clc; clear;