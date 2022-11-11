%    data_rationalizable - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function rationalizable = data_rationalizable(P,Q)
% Check if the purchases made at the prices P for the quantities Q are
% rationalizable by a utility function. 
%  
% Input: 
%   P: A matrix of prices where rows correspond to different goods and columns
%   to different time periods. The column vector at t gives the vector of
%   prices that the consumer faced in the period t. 
%   Q: A matrix of purchased quantities where rows correspond to different 
%   goods and columns to different time periods. The column vector at t gives 
%   the purchased bundle at period t. 

% Variables:
%   The revealed graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): For an edge i from v to w, weights(i) denotes the fraction 
%     of income that could have been saved by purchasing w instead of v. 
  
% Create the revealed preference graph.
[vertex_to_index,neighbors,weights] = find_neighbors(P,Q);

% Check for cycles in the revealed preference graph by a depth-first
% search. 
% This could be a weak cycle with only zero trades. 
found_cycle = dfs_cycle_search(neighbors,vertex_to_index);
rationalizable = 1 - found_cycle;

% Test if there are zero trades
zeros_flag = (~all(weights)); 

%In case weak cycles are possible, confirm that has a GARP violation
if (found_cycle && zeros_flag)
        periods = size(Q,2);
        E = P'*Q;
        % Compute which bundles were available at each period
        E = diag(E) - E ; % p_v.(x_v-x_w))
        % The weak revealed preference
        E_path = (E >= 0);
        % Calculate the closure of the revealed preference by transitivity
        % as the power of the adjacency matrix.
        E_path_closure = sign(mpower(E_path,periods));
        % Check that closure has a weak revealed preference and there is a
        % strict in the opposite direction
        found_cycle = any((E' > 0) & E_path_closure,'all');
        rationalizable = 1 - found_cycle;
end
end

