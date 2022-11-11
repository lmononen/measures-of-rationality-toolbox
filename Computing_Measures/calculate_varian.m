%    calculate_varian - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [value, cycles_in, cycle_sizes_in] = calculate_varian(neighbors,...
    vertex_to_index, weights, power, cycles_in, cycle_sizes_in)
% Non-normalized Varian's index of order p: The minimum cost of removals of out-edges
% for each vertex to make the graph acyclical when removing out-edges at cost
% e_t at the vertex t removes all the out-edges from the vertex with a cost 
% lower than e_t. Additionally, the costs are raised to the power of p. 
%
% Calculates non-normalized Varian's index of order p for the graph 
% given by neighbors, vertex_to_index, and weights starting from the set of 
% critical cycles given by cycles_in, cycle_sizes_in. 
% The index is calculated iteratively by finding the optimal levels of
% out-edge removals e_t to remove all the current critical cycles and then 
% checking if there are any other critical cycles that the removals missed 
% until there are no cycles left. 
%
% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. 
%   power: The power order of Varian's index. 
%   The starting set of critical cycles represented by cycles_in: vector of edge
%   indices in the cycles and by cycle_sizes_in: vector of cycle lengths.

% Variables: 
%   index_to_ordered_index: A mapping from edge indices to a ranking of edges 
%   by first the index of out-vertex and secondly by the cost of the edge. 
%   ordered_index_to_index: A mapping from a ranking of edges as above to
%   the index of the edge. 
%   X_first: A mapping from edge to the first out-edge of the same vertex
%   X_last: A mapping from edge to the last out-edge of the same vertex
%   cycles: Vector of indices belonging to new critical cycles at each
%   iteration
%   cycle_sizes: Vector of cycle lengths for new critical cycles at each
%   iteration 
%   weights_dfs: The additional cost of removing each edge from the current
%   optimal solution 
%   constraint_matrix: A constraint matrix for the binary linear programming 
%   problem of removing all the found critical cycles by removing out-edges at
%   costs e_t
%   removals: Indicator vector for optimal levels set for e_ts based on the
%   weight of the edge that the e_t is set at 
%   removals_full: The induced removals in the graph from removing in-edges at
%   levels e_t
%   value: Optimal cost of removals


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Reorder relations so that removing relations corresponds to
    %% removing all more expensive trades for Varian's index
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    no_vertex = size(vertex_to_index,2) - 1;
    
    % For each vertex, calculate a reordering of the vertex's neighbors' to
    % an increasing order i.e. order indices between vertex_to_index(i) and
    % vertex_to_index(i+1) for each vertex i. 
    identity_fct = uint32(1:size(weights,2));        
    [index_to_ordered_index, ordered_index_to_index] = calc_ordered_index_trans(vertex_to_index, weights,identity_fct);

    % X_first & X_last are mappings from the neighbor's indices to the
    % vertex's first and last neighbors.
    % Here, for Varian's index, removing the relation i, means removing all
    % the less expensive relations that are 
    % X_ordered_to_index(index_to_X_ordered(i):X_last(i))
    X_first = uint32(zeros(1, size(neighbors,2)));
    X_last = uint32(zeros(1, size(neighbors,2)));
    for i = 1:no_vertex
        X_first(vertex_to_index(i):(vertex_to_index(i + 1)-1)) = vertex_to_index(i);
        X_last(vertex_to_index(i):(vertex_to_index(i + 1)-1)) = vertex_to_index(i + 1) - 1;
    end        

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%   Calculate Varian's index   %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    value = 0;
    
    % Exit flag if no more cycles
    has_cycle = true;
    
    iteration_counter = 0; 

    % Constraint matrix for the programming problem
    constraint_matrix=zeros(0,size(neighbors,2));
    
    % Initialize null removals
    removals_full = false(1,size(neighbors,2));
    weights_dfs = weights;

    % Iteratively find new critical cycles and do optimal removals until removed all of the cycles
    while (has_cycle) 
        iteration_counter = iteration_counter + 1;

        if (iteration_counter == 1) % In the first iteration, use the given set of cycles
            cycles = cycles_in;
            cycle_sizes = cycle_sizes_in;
        else 
            % Check if previous removals solved the problem and check for missing critical cycles 
            [cycles, cycle_sizes] = dfs_critical_cycles_search(neighbors, vertex_to_index, weights_dfs, removals_full);

            % If iteration_index > 1 and don't find cycles then removals
            % removed all the cycles 
            if (isempty(cycle_sizes)) 
                has_cycle = false;
            end
        end


        % If found cycles, then find new optimal removals
        if (~isempty(cycle_sizes)) 


            % Expand the constraint_matrix with the new critical cycles
            % See below for the function
            constraint_matrix = min_const_matrix_varian(index_to_ordered_index, ordered_index_to_index, X_last, cycles, cycle_sizes, constraint_matrix);

            % Find the optimal method to remove the new found cycles and all
            % the previous cycles 
            [removals,value] = find_removals(weights, constraint_matrix, power);
            
            % Calculate the additional cost of removing each relation from
            % the current optimal solution 
            weights_dfs = weights_adjustment_varian(index_to_ordered_index,ordered_index_to_index, X_last, removals, weights_dfs);

            % Find the induced edge removals from removing all the less
            % expensive out-edges
            removals_full = removals_reduction_varian(index_to_ordered_index, ordered_index_to_index, X_first, removals);

        end %(!cycles.empty())
        % Debug % In case of non-convergence pause. 
        if (iteration_counter > 5 * size(neighbors,2)) 
            disp("removing cycles non-convergence")
            return;
        end
        
        % Save the found cycles
        if (iteration_counter ~= 1) 
            cycles_in = [cycles_in, cycles];
            cycle_sizes_in = [cycle_sizes_in, cycle_sizes];
        end
        
        
    end % While (has_cycle)

end

function constraint_matrix = min_const_matrix_varian(index_to_ordered_index, ordered_index_to_index, X_last, cycles, cycle_sizes, constraint_matrix)
% Expand the constraint matrix by the new critical cycles given by cycles
% and cycle_sizes. The constraint matrix requires that for each cycle for at
% least one edge in the cycle a more expensive out-edge is removed. 
%
% That is, the constraint matrix consists of columns for each edge and 
% has a row for each cycle. The row for a cycle in the constraint matrix is
% defined as follows: For each edge x->y in the cycle, the matrix has -1 for
% all the out-edges from x that are more expensive than the edge x->y.
% Otherwise, the matrix has 0. This is combined with the requirement that 
% the sum of each row is below -1. For an edge i, these more expensive 
% out-edges are 
% ordered_index_to_index(index_to_ordered_index(i):X_last(i))

% Input: 
%  As above and
%  cycles: Vector of indices belonging to the new cycles added to the constraint
%  matrix
%  cycle_sizes: Vector of cycle lengths for the new cycles added to the constraint
%  matrix


% Expand the constraint_matrix with the new cycles in cycles
% Constraint matrix is created by the requirement that for each
% cycle at least one more expensive out-trade than a trade in the
% cycle is removed. That is there is a trade i in the cycle such that a
% trade in ordered_index_to_index(index_to_ordered_index(i):X_last(i)) is
% removed

    old_size = size(constraint_matrix,1);
    % Add a new row for each cycle
    constraint_matrix = [constraint_matrix;zeros(size(cycle_sizes,2),size(constraint_matrix,2))];

    no_new_cycles = size(cycle_sizes,2);
    
    cycle_index_counter = 1;
    for i = 1:no_new_cycles
        cycle_size = cycle_sizes(i);
        for j = 1:cycle_size
            % The ranking of the edge in the cycle
            ind = index_to_ordered_index(cycles(cycle_index_counter));
            % The ranking of the last edge from the same vertex             
            last = X_last(ind);
            % Add constraints for all the more expensive out-edges
            constraint_matrix(old_size + i,ordered_index_to_index(ind:last)) = -1;  
            cycle_index_counter = cycle_index_counter + 1;
        end
    end
    
end

function weights_dfs = weights_adjustment_varian(index_to_ordered_index,ordered_index_to_index, X_last, removals, weights)
% Calculate the additional cost of removing each edge from the current
% optimal solution. This is the additional amount of e_t required to remove 
% the edge. That is for the edges that correspond to the optimal levels of e_t,
% subtract the weight of these edges from all the more expensive out-edges. 

    weights_dfs = weights;

    removals_index = find(removals); % Removed edges
    for i = removals_index
        % The ranking of the edge that the e_t is set at
        ind = index_to_ordered_index(i);
        % The ranking of the last out-edge to the vertex
        last = X_last(ind);
        % Subtract the cost of the removed edge from all the more expensive
        % out-edges
        weights_dfs(ordered_index_to_index((ind + 1):last)) = weights_dfs(ordered_index_to_index((ind + 1):last)) - weights(ordered_index_to_index(ind));
    end
end


function removals_full = removals_reduction_varian(index_to_ordered_index, ordered_index_to_index, X_first, removals)
% Calculate the induced edge removals from the optimal levels of e_t. That
% is find the edges that correspond to the optimal e_t levels and remove all
% the cheaper out-edges also. 
    
    removals_full = removals;
    
    removals_index = find(removals); % Removed edges
    for i = removals_index
        % The ranking of the edge that the e_t is set at
        ind = index_to_ordered_index(i);
        % The ranking of the first out-edge to the vertex
        first = X_first(ind);
        % Remove all the cheaper out-edges also
        removals_full(ordered_index_to_index((first):(ind-1))) = true;
    end
    
end



