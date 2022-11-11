%    find_neighbors_symmetric - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [vertex_to_index,neighbors,weights] = find_neighbors_symmetric(P,Q)
% Finds the revealed preference graph between chosen bundles or any 
% permuted bundles with permuted indices for the goods. 
% The chosen bundles are the vertices in the graph. 
% A revealed preference x_v > x_w corresponds to a directed edge from vertex
% v to w, v -> w. The edges or revealed preferences are indexed by i. 
%
% Variables:
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weights(i): For an edge i from v to w, weights(i) denotes the fraction of income that
%     could have been saved by purchasing w instead of v, max_pi(p_v.(x_v-x^pi_w))/(p_v.x_w)
%     where the max is taken over all permuted bundles for w, x^pi_w.
% 

goods = size(P,1);
periods = size(P,2);
permutations = perms(1:goods);
no_permutations = size(permutations,1);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Create mirrored data where the order of the goods is reversed %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    P_mirrored = zeros(size(P,1), no_permutations * size(P,2));
    Q_mirrored = zeros(size(P,1), no_permutations * size(P,2));
    
    for i=1:no_permutations
        P_mirrored(:,((i-1)*periods+1):i*periods)=P(permutations(i,:),:);
        Q_mirrored(:,((i-1)*periods+1):i*periods)=Q(permutations(i,:),:);  
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Find the revealed preference graph in the mirrored data  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate the costs of all bundles at all the different prices
    E = P_mirrored'*Q_mirrored;
    incomes = diag(E);
    E = incomes - E; % p_v.(x_v-x_w)) for the mirrored data
    E = E-eye(size(E,2)); % Make diagonal to -1
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Reduce the permuted trades into standard trades by taking the
    %% largest of the fractions of income could have saved by trading
    %% v for w or v for any permuted w.
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Here it is sufficient to permute only the indices of the bundles or
    % the indices of the prices. So focus on only permuting indices of
    % bundles and take only the first periods of rows of E. Then to find
    % the maximum trade of i-> j take max_n(E(i,(n-1)*periods + j)) where
    % 1 <= n <= no_permutations. 
    
    % Reshape the first periods rows of E into a 3-dimensional matrix by 
    % cutting it by every periods of columns. Then to find the maximum
    % trade look for the maximum in the third dimension.
    E_alt= E(1:periods, :);
    E_alt= reshape(E_alt,periods,periods,no_permutations);
    E_alt = max(E_alt,[],3);
    % E_alt(i,j) gives the amount of money in period i that could have saved 
    % by purchasing a bundle from period j
    
    % Remove weak 1-cycles that do not affect the measures
    E_alt = E_alt - eye(periods) .* (diag(E_alt) == 0); 
    
    % Calculate the revealed preference graph from the reduced trades
    incomes = repmat(incomes(1:periods),1,periods);
    
    % Normalize the savings by the income in each period
    E_alt = E_alt ./ incomes; % max_pi((p_v.(x_v-x^pi_w))/(p_v.x_v),) in row v, column w, where x^pi is any permuted data.  
    E_alt = E_alt'; % Transpose so that in the below find return sequentially all the out-edges for each vertex  
    V = (E_alt>=0); % If positive in row w, column v: x_v is weakly preferred over x_w. 
    [neighbors,~] = find(V); % The rows of non-zero elements give neighbors
    sum_V = sum(V,1); % Number of out-edges for each vertex
    
    % Make a cumulative out-edge index counter
    vertex_to_index = uint32(ones(1,periods+1));
    for i=1:periods
        vertex_to_index(i + 1) = vertex_to_index(i) + sum_V(i);
    end
    neighbors = uint32(neighbors);
    weights = E_alt(V); % Weights of edges i.e. the fractions of income that could have saved
    
    % Transpose to row vectors
    neighbors = neighbors';
    weights = weights';
end
