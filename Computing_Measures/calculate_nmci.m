%    calculate_nmci - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [value, cycles_in, cycle_sizes_in] = calculate_nmci(neighbors, ...
    vertex_to_index, weights, power, cycles_in, cycle_sizes_in)
% Non-normalized normalized minimum cost index of order p: The minimum cost 
% of removals of edges to make the graph acyclical. Additionally, the costs 
% are raised to the power of p. 
%
% Calculates the non-normalized normalized minimum cost index of order p 
% for the graph given by neighbors, vertex_to_index, and weights starting 
% from the set of critical cycles given by cycles_in, cycle_sizes_in. 
% The index is calculated iteratively by finding the optimal edge removals
% to remove all the current critical cycles and then checking if there are 
% any other critical cycles that the removals missed until there are no 
% cycles left. 
%
% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. 
%   power: The power order of NMCI index. 
%   The starting set of critical cycles represented by cycles_in: vector of edge
%   indices in the cycles and by cycle_sizes_in: vector of cycle lenghts.

% Variables: 
%   cycles: Vector of indices belonging to new critical cycles at each
%   iteration.
%   cycle_sizes: Vector of cycle lenghts for new critical cycles at each
%   iteration.
%   constraint_matrix: A constraint matrix for the binary linear programming 
%   problem of removing all the found critical cycles by removing edges 
%   removals: Indicator vector for optimal levels set for e_ts based on the
%   weight of the edge that the e_t is set at.
%   value: Optimal cost of removals.

    value = 0;
    
    % Exit flag if no more cycles
    has_cycle = true;

    iteration_counter = 0;

    % Constraint matrix for the programming problem
    constraint_matrix=zeros(0,size(neighbors,2));
    
    % Initialize null removals
    removals = false(1,size(neighbors,2));


    % Iteratively find new critical cycles and do optimal removals until removed all of the cycles
    while (has_cycle) 
        iteration_counter = iteration_counter + 1;

        if (iteration_counter == 1) % In the first iteration, use the given set of cycles
            cycles = cycles_in;
            cycle_sizes = cycle_sizes_in;
        else 
            % Check if previous removals solved the problem and check for missing critical cycles 
            [cycles, cycle_sizes] = dfs_critical_cycles_search(neighbors, vertex_to_index, weights, removals);

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
            constraint_matrix = min_const_matrix_nmci(cycles, cycle_sizes, constraint_matrix);

            % Find the optimal method to remove the new found cycles and all
            % the previous cycles 
            [removals,value] = find_removals(weights, constraint_matrix, power);
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


function constraint_matrix = min_const_matrix_nmci(cycles,cycle_sizes,constraint_matrix)
% Expand the constraint matrix by the new critical cycles given by cycles
% and cycle_sizes. The constraint matrix requires that for each cycle at
% least one edge in the cycle is removed. 
%
% That is, the constraint matrix consists of columns for each edge and 
% has a row for each cycle. The row for a cycle in the constraint matrix 
% has -1 for each edge in the cycle and 0 otherwise. This is combined with 
% the requirement that the sum of each row is below -1. 

% Input: 
%  As above and
%  cycles: Vector of indices belonging to the new cycles added to the constraint
%  matrix
%  cycle_sizes: Vector of cycle lenghts for the new cycles added to the constraint
%  matrix

    old_size = size(constraint_matrix,1);
    % Add a new row for each cycle
    constraint_matrix = [constraint_matrix;zeros(size(cycle_sizes,2),size(constraint_matrix,2))];

    cycle_index_counter = 1;
    for i = 1:size(cycle_sizes,2)
        constraint_matrix(old_size + i,cycles(cycle_index_counter:(cycle_index_counter + cycle_sizes(i) - 1))) = -1;
        cycle_index_counter = cycle_index_counter + cycle_sizes(i);
    end
end



