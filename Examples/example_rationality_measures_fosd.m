%    example_fosd - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
% Two goods and one observation
% x_1=(1,2)
% p_1=(1,2)
% Here, we interpret that the goods are two risky assets where one of them
% pays out with an equal 50% probability. We look for a rationalization by a
% utility function that satisfies first-order stochastic dominance over these
% two assets. This is equivalent to rationalization by a symmetric
% utility function over these two assets. 

% Include the main folder and all the subfolders to the path
addpath(genpath('../')) 

% The columns index observations and the rows index goods
Q=[1; 2];
P=[1; 2];

% Use variations of measures where the size of errors is measured in l^1
% norm and in l^{0.5} norm raised to the power of 0.5.
power_vec=[1, 0.5];

% Look for a rationalization by a symmetric utility i.e. utility that
% satisfies fosd
rat_measure_fosd_values = rationality_measures_symmetric(P, Q, power_vec);

Afriats_index_fosd = rat_measure_fosd_values(1);
Houtman_Maks_index_fosd = rat_measure_fosd_values(2);
Swaps_index_fosd = rat_measure_fosd_values(3);

Varians_index_fosd = rat_measure_fosd_values(4);
InvVarians_index_fosd = rat_measure_fosd_values(5);
NMCI_fosd = rat_measure_fosd_values(6);

Varians_index0_5_fosd = rat_measure_fosd_values(7);
InvVarians_index0_5_fosd = rat_measure_fosd_values(8);
NMCI0_5_fosd = rat_measure_fosd_values(9);