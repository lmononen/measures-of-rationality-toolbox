%    dfs_critical_cycles_search - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [cycles,cycle_sizes] = dfs_critical_cycles_search(neighbors, vertex_to_index, weights, removals)
% A depth-first search for critical cycles that removals missed. The
% algorithm does a depth-first search for cycles in the revealed preference 
% graph after removals and breaks each found cycle by the lowest additional 
% removal cost. The algorithm looks for any cycles including ones without 
% any strict trades. 

% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The additional cost of removing the edge i. 
%   removals: Indicators for already removed edges.

% Variables:
%   visited: visited vertices
%   unstacked: visited vertices that are not part of any additional cycles. 
%   min_cycle_cost: the cheapest trade for a found cycle.
%   min_cost_index: the index corresponding to the cheapest trade.
%   cycle_beginning_index: the first trade of a found cycle.
%   cycles: Vector of indices belonging to cycles.
%   cycle_sizes: Vector of cycle lengths. 
%     By moving in cycles by cycle_sizes, we can recover all the cycles.



cycles = uint32([]);
cycle_sizes = uint32([]);

no_vertex = size(vertex_to_index,2)-1;
visited = false(1,no_vertex);
unstacked = false(1,no_vertex);


for v=1:no_vertex 
   if (~visited(v)) % Unvisited vertex
       visited(v) = 1;
       [cycles, cycle_sizes, visited, unstacked, removals, ~, ~, ~] = ...
           dfs_critical_cycles_search_sub(v, visited, unstacked, neighbors, vertex_to_index, weights, cycles, cycle_sizes, removals);
       unstacked(v) = 1;
   end
end
end


% A recursive depth-first search function for critical cycles. The function returns if found
% a cycle that includes earlier vertices than v or there are no more cycles
% that include v. 
function [cycles, cycle_sizes, visited, unstacked, removals, min_cost_index, min_cycle_cost, cycle_beginning_index] = ...
    dfs_critical_cycles_search_sub(v, visited, unstacked, neighbors, vertex_to_index, weights, cycles, cycle_sizes, removals)
    for i = vertex_to_index(v):(vertex_to_index(v+1)-1)
        if (~removals(i)) 
            w = neighbors(i); 
            if (~visited(w)) % Move along the graph from v to w if w is not visited
                visited(w) = 1;
                while (~unstacked(w) && ~removals(i)) % Search until no more cycles that include w or the edge v->w is removed. 
                    % Search the vertex w
                    [cycles, cycle_sizes, visited, unstacked, removals, min_cost_index, min_cycle_cost, cycle_beginning_index] = ...
                        dfs_critical_cycles_search_sub(w, visited, unstacked, neighbors, vertex_to_index, weights, cycles, cycle_sizes, removals);
                    if (cycle_beginning_index > -1) % If found a cycle
                            % Add i to the cycle
                            cycles(end + 1) = i;
                            cycle_sizes(end) = cycle_sizes(end) + 1;                                  
                            
                        if (cycle_beginning_index == v) % If v the beginning of the cycle
                            cycle_beginning_index = -1; % Stop the rollback
                            
                            % Reverse the order of the new cycle to proper
                            cycles((end-cycle_sizes(end) + 1):end) = flip(cycles((end-cycle_sizes(end) + 1):end));
                            
                            % Update the lowest breaking cost and index
                            if (weights(i) < min_cycle_cost)
                                min_cost_index = i;
                                visited(w) = 0; % If i is the lowest cost edge, rollback the search from w
                                % Do not search w again in this case
                            end
                            % Break the cycle at the lowest cost and add the
                            % minimum index to the removals
                            removals(min_cost_index) = true;
                            % Search w again unless the edge i was removed                           
                        else % Not at the beginning of the cycle
                            % Update the lowest breaking cost and index                            
                            if (weights(i) < min_cycle_cost) 
                                min_cost_index = i;
                                min_cycle_cost = weights(i);
                            end
                            visited(w) = 0; % Rollback the search    
                            return;
                        end
                    else % Did not find more cycles that include w so unstack w
                        unstacked(w) = 1;
                    end
                end
            elseif (~unstacked(w)) % w visited and not unstacked: w is the beginning of a cycle
                % Add i to the new cycle
                cycles(end + 1) = i;
                cycle_sizes(end + 1) = 1;
                if (v == w)  %1-cycle: Remove the edge i. 
                    removals(i) = true;
                else 
                    cycle_beginning_index = w; % Mark the beginning of the cycle to stop the rollback. 
                    % Return the current minimum element and cost
                    min_cost_index = i;
                    min_cycle_cost = weights(i);
                    return; % Rollback the search
                end
            end
        end
    end
    % No cycles. Return null values
    min_cost_index = -1;
    min_cycle_cost = 0;
    cycle_beginning_index = -1;
end



