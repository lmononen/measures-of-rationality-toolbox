%    dfs_cycle_search - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function cycle_flag = dfs_cycle_search(neighbors,vertex_to_index)
% A depth-first search for a cycle in the graph. The search stops as soon as
% a cycle is found.  The algorithm looks for any cycles including ones 
% without any strict trades. 

% Input: 
%   The graph represented vertex_to_index and neighbors:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 

% Variables:
%   visited: Visited vertices.
%   unstacked: Visited vertices that are not part of any additional cycles. 
%   cycle_flag: Global cycle indicator.

    no_vertex = size(vertex_to_index,2)-1;
    visited = false(1,no_vertex);
    unstacked = false(1,no_vertex);

    for v=1:no_vertex 
       if (~visited(v))  % Unvisited vertex
           visited(v) = 1;
           [cycle_flag, unstacked, visited] = dfs_cycle_search_sub(v, neighbors, vertex_to_index, unstacked, visited);
           unstacked(v) = 1;
           if (cycle_flag)
               break;
           end
       end
    end
end


function [cycle_flag, unstacked, visited] = dfs_cycle_search_sub(v, neighbors, vertex_to_index, unstacked, visited)
% A recursive depth-first search function for cycles. The function returns if found
% a cycle or there are no cycles that include v. 
    for i = vertex_to_index(v):(vertex_to_index(v+1)-1)
        w = neighbors(i);
        if (~visited(w)) % Move along the graph from v to w if w is not visited
            visited(w) = 1;            
            % Search the vertex w
            [cycle_flag, unstacked, visited] = dfs_cycle_search_sub(w, neighbors, vertex_to_index, unstacked, visited);
            if (cycle_flag) % If found a cycle return
                return;
            else % Did not find a cycle that includes w
                unstacked(w) = 1;
            end
        elseif (~unstacked(w)) % w visited and not unstacked: w is the beginning of a cycle
            cycle_flag = true; % Found a cycle and return
            return;
        end
    end
    cycle_flag = false; % Search completed without finding cycles
end

