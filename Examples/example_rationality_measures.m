%    Example - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
% Two goods and three observations
% x_1=(1,2), x_2=(2,1), x_3 = (2,2)
% p_1=(1,2), p_2=(2,1), p_3 = (1,1)

% Include the main folder and all the subfolders to the path
addpath(genpath('../')) 

% The columns index observations and the rows index goods
Q=[[1;2], [2;1], [2;2]];
P=[[1;2], [2;1], [1;1]];

% Use variations of measures where the size of errors is measured in l^1
% norm and in l^{0.5} norm raised to the power of 0.5.
power_vec=[1, 0.5];

% Calculate the measures of rationality for the data
rat_measures_values = rationality_measures(P, Q, power_vec);

Afriats_index = rat_measures_values(1);
Houtman_Maks_index = rat_measures_values(2);
Swaps_index = rat_measures_values(3);

Varians_index = rat_measures_values(4);
InvVarians_index = rat_measures_values(5);
NMCI = rat_measures_values(6);

Varians_index0_5 = rat_measures_values(7);
InvVarians_index0_5 = rat_measures_values(8);
NMCI0_5 = rat_measures_values(9);



