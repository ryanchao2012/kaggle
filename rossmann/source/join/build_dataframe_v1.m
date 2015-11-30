clc; clear;

load 'refine_basket/train.ref'; % store_index day_week sale_cust bool_feat state_hday date_seq date_base
load 'refine_basket/store.ref'; % type_assort comp_dist comp_open_since promo2 promo_month

store.type_assort = type_assort;
store.comp_dist = comp_dist;
store.comp_open_since = comp_open_since;
store.promo2 = promo2;
store.promo_month = promo_month;

train.store_index = store_index;
train.date_seq = date_seq;
train.day_week = day_week;
train.sale_cust = sale_cust;
train.bool_feat = bool_feat;
train.state_hday = state_hday;
train.date_base = date_base;


save -binary 'data_frame/store.df' store;
save -binary 'data_frame/train.df' train;

clc; clear;