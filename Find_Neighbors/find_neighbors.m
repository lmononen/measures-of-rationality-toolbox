%    find_neighbors - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [vertex_to_index,neighbors,weights] = find_neighbors(P,Q)
% Finds the revealed preference graph between chosen bundles.
% The chosen bundles are the vertices in the graph. 
% A revealed preference x_v > x_w corresponds to a directed edge from vertex
% v to w, v -> w. The edges or revealed preferences are indexed by i. 
%
% Variables:
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weights(i): For an edge i from v to w, weights(i) denotes the fraction 
%     of income that could have been saved by purchasing w instead of v, 
%     (p_v.(x_v-x_w))/(p_v.x_w).
% 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Find the revealed preference graph in the data  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    periods = size(P,2);
    % Calculate the costs of all bundles at all the different prices
    E = P'*Q;
    incomes = diag(E);
    % Compute which bundles were available at each period
    E = incomes - E ; % p_v.(x_v-x_w))
    E = E-eye(size(E,2)); % Make the diagonal to -1 to skip these trivial revealed preferences
    incomes = repmat(incomes,1,size(E,2));
    
    % Normalize the savings from other bundles by the income
    E = E ./ incomes; % Off-diagonal: (p_v.(x_v-x_w))/(p_v.x_v) in row v, column w. 
    E = E'; % Transpose so that in the below find return sequentially all the out-edges for each vertex     
    V = (E>=0); % If positive in row w, column v: x_v is weakly preferred over x_w. 
    [neighbors,~] = find(V); % The rows of non-zero elements give the in-vertices
    sum_V = sum(V,1); % Number of out-edges for each vertex
    
    % Make a cumulative out-edge index counter
    vertex_to_index = uint32(ones(1,periods+1));
    for i=1:periods
        vertex_to_index(i + 1) = vertex_to_index(i) + sum_V(i);
    end
    neighbors = uint32(neighbors);
    weights = E(V); % Weights of edges i.e. the fractions of income that could have saved
    
    % Transpose to row vectors
    neighbors = neighbors';
    weights = weights';
end