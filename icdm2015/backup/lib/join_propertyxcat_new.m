clc;
close all;

if(!exist('property', 'var'))
	load 'new_join/property.join'; % property property_df
end


if(!exist('prop_array', 'var'))
	load 'refine/all_in_propxcat.ref'; % prop_array cat_list
end



prop_num = length(property);
[bool prop_idx] = ismember(property, prop_array(1, :));

cat_member = cell(prop_num, 1);


for i = 1 : prop_num
	if(prop_idx(i) == 0)
		continue;
	end

	cat_member{i} = int16(cat_list{prop_array(2, prop_idx(i)) - 1});

	if(mod(i, 1000) == 0)
		fprintf('... %d-th cat_member joined...\r', i);
		fflush(stdout);
	end

end
fprintf('\n');

[category, ~, J] = unique([cat_member{:}]);
category_df = accumarray(J', 1);


save -binary 'new_join/property.join' property property_df cat_member;
save -binary 'new_join/category.join' category category_df;

  % cat_df	category
  %  2536      1
  %  1841      2
  %  2926      3
  %   588      4
  %   312      5
  %   333      6
  %  2382      7
  %  2304      8
  %   189      9
  %  5471     10
  %  2456     11
  %  2059     12
  %   410     13
  % 25133     14
  %   484     15
  %  1636     16
  % 30134     17
  %   217     18
  %   281     19
  %   505     20
  %   642     21
  % 32767     22
  %   415     23
  %  1320     24
  %   568     25
  %   286     26
  %   176     27
  %   252     28
  %  1425     29
  %   215     30
  %   282     31
  %   790     32
  %   214     33
  %  2604     34
  % 17943     35
  %   956     36
  %   187     37
  %   186     38
  %  5333     39
  %  3259     40
  %   239     41
  %  4547     42
  %   294     43
  %  2645     44
  %   193     45
  %  3639     46
  %   515     47
  %  1479     48
  %   178     49
  %  4554     50
  %   188     51
  %   504     52
  %   216     53
  %  8736     54
  %  9690     55
  %   307     56
  % 31985     57
  %   244     58
  % 19710     59
  %  8875     60
  %   745     61
  %   693     62
  %   197     63
  %   208     64
  %   767     65
  %   191     66
  %  2350     67
  %   938     68
  %   239     69
  %   286     70
  %   191     71
  %  2066     72
  %   351     73
  %   444     74
  %   175     75
  %   461     76
  %  1924     77
  %   427     78
  %   867     79
  %   550     80
  %  1096     81
  % 32767     82
  %   483     83
  %   396     84
  %   497     85
  %  2298     86
  %  2571     87
  %  3541     88
  %  1044     89
  %  2184     90
  %  2171     91
  %  8231     92
  %   193     93
  %  2042     94
  %  1332     95
  %   407     96
  %   445     97
  %   202     98
  %  2034     99
  %   200    100
  %   252    101
  %   225    102
  %   335    103
  %   848    104
  % 28883    105
  %  1342    106
  %   426    107
  %  2211    108
  %   358    109
  %  1253    110
  %   187    111
  %   494    112
  %   252    113
  %  2801    114
  %  8141    115
  %   665    116
  %   178    117
  %   345    118
  % 32767    119
  %  2027    120
  %  4764    121
  %   161    122
  %   177    123
  % 32767    124
  % 32767    125
  %   462    126
  %   225    127
  %   150    128
  %   192    129
  %   301    130
  %  2166    131
  %   324    132
  %   423    133
  % 22993    134
  %   599    135
  %   727    136
  %  2064    137
  % 32767    138
  %   201    139
  %  1599    140
  %   179    141
  %   218    142
  %   177    143
  %   172    144
  %  5449    145
  %   179    146
  %   432    147
  % 21752    148
  %  1494    149
  %   205    150
  %  2148    151
  %  1921    152
  %   521    153
  %   472    154
  %   461    155
  %   232    156
  %   360    157
  %   705    158
  %  1808    159
  %  1219    160
  %  1896    161
  %   314    162
  %  2569    163
  % 32767    164
  %  4675    165
  %   215    166
  %   298    167
  %   378    168
  %  2743    169
  %  1280    170
  %   552    171
  %   304    172
  %  1296    173
  % 26083    174
  %   379    175
  %  2078    176
  %  7788    177
  %  1752    178
  %  1368    179
  %   180    180
  %   181    181
  %   841    182
  %  1315    183
  %   411    184
  %   185    185
  %  6606    186
  %   181    187
  %  3876    188
  %  1225    189
  %  2471    190
  %   213    191
  %  4213    192
  %  2284    193
  %  1902    194
  %  6698    195
  % 32767    196
  % 25347    197
  %   192    198

