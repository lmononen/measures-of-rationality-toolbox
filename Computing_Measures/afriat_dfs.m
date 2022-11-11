%    afriat_dfs - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function afriat = afriat_dfs(neighbors, vertex_to_index, weights)
% A depth-first search for Afriat's index. Starting with estimate 0 for 
% Afriat's index, the algorithm removes all trades with a lower cost than the
% current estimate. Then the algorithm searches for cycles by depth-first 
% search and breaks each found cycle by increasing the estimate for 
% Afriat's index to the minimum trade of the cycle. When the search finishes
% there are no cycles with minimum trade higher than the estimate for
% Afriat's index. 

% Input: 
%  The graph represented vertex_to_index, neighbors, and weights:
%    vertex_to_index: The edge indices between vertex_to_index(v) and 
%    vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%    neighbors(i): The in-vertex of the edge i. 
%    weight(i): The weight of the edge i. 

% Variables:
%  visited: Visited vertices.
%  unstacked: Visited vertices that are not part of any additional cycles. 
%  min_cycle_cost: The cheapest trade for a found cycle.
%  cycle_beginning_index: The first trade of a found cycle.
%  afriat: Current estimate for Afriat's index.

    afriat = 0;
    
    no_vertex = size(vertex_to_index,2)-1;
    visited = false(1,no_vertex);
    unstacked = false(1,no_vertex);
    
    for v=1:no_vertex 
       if (~visited(v))  % Unvisited vertex
           visited(v) = 1;
           [visited, unstacked, afriat, ~,  ~] = afriat_dfs_sub(v, visited, unstacked, afriat, neighbors, vertex_to_index, weights);
           unstacked(v) = 1;
        end
    end
    return;
end


function [visited, unstacked, afriat, cycle_beginning_index,  min_cycle_cost] = afriat_dfs_sub(v, visited, unstacked, afriat, neighbors, vertex_to_index, weights)
% A recursive depth-first search function for Afriat's index. The function returns if found
% a cycle that includes earlier vertices than v or there are no more cycles
% that include v. 
    for i=vertex_to_index(v):(vertex_to_index(v + 1)-1)
        if (weights(i) > afriat) 
            w = neighbors(i);
            if (~visited(w)) % Move along the graph from v to w if w is not visited
                visited(w) = 1; 
                while (~unstacked(w) && (weights(i) > afriat)) % Search until no more cycles that include w or the edge v->w is removed. 
                    % Search the vertex w
                    [visited, unstacked, afriat, cycle_beginning_index,  min_cycle_cost] = afriat_dfs_sub(w, visited, unstacked, afriat, neighbors, vertex_to_index, weights);
                    if (cycle_beginning_index > -1) % If found a cycle
                            % Update the minimum cost of the cycle
                            min_cycle_cost = min([weights(i), min_cycle_cost]);                        
                            
                        if (cycle_beginning_index == v) % If v the beginning of the cycle
                            cycle_beginning_index = -1; % Stop the rollback
                            
                            % Update the estimate for Afriat's index
                            afriat = max([afriat, min_cycle_cost]);
                            if (weights(i) <= afriat)
                                visited(w) = 0; % If i is the lowest cost edge, rollback the search from w
                                % Do not search w again in this case
                            end
                            % Search w again unless the edge i was removed    
                        else  % Not at the beginning of the cycle
                            visited(w) = 0; % Rollback the search
                            return;
                        end
                    else % Did not find more cycles that include w so unstack w
                        unstacked(w) = 1; 
                    end
                end
            elseif (~unstacked(w)) % w visited and not unstacked: w is the beginning of a cycle
                if (v == w) %1-cycle. Update the estimate
                    afriat = max([afriat, weights(i)]);
                else 
                    min_cycle_cost = weights(i); % The minimum cost of the cycle                    
                    cycle_beginning_index = w; % Rollback to w
                    return;
                end
            end
        end
    end
    % No cycles. Return null values
    min_cycle_cost = 0;
    cycle_beginning_index = -1;
end

