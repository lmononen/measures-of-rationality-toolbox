%    rationality_measures_symmetric - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function values_vec = rationality_measures_symmetric(P, Q, power_vec)
% Calculate measures of rationality from prices and quantities when
% rationality includes the assumption that the utility is symmetric.
% Especially, if the goods are risky assets where one of them pays off with
% equal probability, then this corresponds to rationalization by a utility
% that satisfies first-order stochastic dominance.

% Input:
%   P: A matrix of prices where rows correspond to different goods and columns
%   to different time periods. The column vector at t gives the vector of
%   prices that the consumer faced in the period t. 
%   Q: A matrix of purchased quantities where rows correspond to different 
%   goods and columns to different time periods. The column vector at t gives 
%   the purchased bundle at period t. 
%   power_vec: A vector of power variations to calculate for Varian's index, 
%   inverse Varian's index, and normalized minimum cost index. 
%
% Output:
%   values_vec(1): Afriat's index: The smallest e such that after adjusting 
%   all the incomes to (1-e)*income, the revealed preferences can be 
%   rationalized by a symmetric utility function. 
%
%   values_vec(2): Houtman-Maks index: The minimum fraction of observation
%   needed to remove so that the revealed preferences can be rationalized 
%   by a symmetric utility function. 
%
%   values_vec(3): Swaps index: The smallest number of revealed preferences 
%   required to be removed so that the revealed preferences can be 
%   rationalized by a symmetric utility function. Additionally, this number
%   is normalized by the number of observations. As shown in Mononen (2022),
%   "Computing and Comparing Measures of Rationality", this is equivalent 
%   to the swaps index as defined in Apesteguia and Ballester (2015), "A 
%   Measure of Rationality and Welfare" when extended to a symmetric 
%   utility. 

%	For each power_vec(j):
%     values_vec(3*j + 1): Varian's index of degree power_vec(j): The minimum 
%     over sum_t e_t^p such that after adjusting the income at each 
%     observation t to income*(1-e_t), the revealed preferences can be 
%     rationalized by a symmetric utility function. This is normalized by 
%     the number of observations. 
%
%     values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j): 
%     The minimum over sum_t e_t^p such that after adjusting the cost of 
%     each bundle t to cost/(1-e_t), the revealed preferences can be 
%     rationalized by a symmetric utility function. This is normalized by 
%     the number of observations. 
%
%     values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j):
%     The minimum over sum_{t,u} e_{t,u}^p such that after adjusting the 
%     income at the revealed preference comparison of t over u, the 
%     revealed preferences can be rationalized by a symmetric utility 
%     function. This is normalized by the number of observations. 

% Variables:
%   The revealed graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): For an edge i from v to w, weights(i) denotes the fraction 
%     of income that could have been saved by purchasing w instead of v in
%     the original or in any of the permuted data. 

% Create the reduced revealed preference graph for the permuted data.
[vertex_to_index,neighbors,weights] = find_neighbors_symmetric(P, Q);

% The measures of rationality are calculated in this revealed preference
% graph
values_vec = rationality_measures_from_graph(vertex_to_index, neighbors, weights, power_vec);

end


