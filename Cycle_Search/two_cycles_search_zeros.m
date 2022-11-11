%    two_cycles_search_zeros - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [cycles,cycle_sizes] = two_cycles_search_zeros(neighbors,vertex_to_index, weights)
% A brute-force algorithm for searching for all cycles of length 1 or 2 with at least one strict trade. 
% Checks all paths of length 2 for cycles where move up in vertex
% indices in the first edge of the cycle

% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. 

% Variables: 
%   cycles: Vector of indices belonging to cycles/
%   cycle_sizes: Vector of cycle lengths. 
%     By moving in cycles by cycle_sizes, we can recover all the cycles.

    % initialize variables
    cycles = uint32([]);
    cycle_sizes = uint32([]);
    
    % Find two-cycles where in the first trade move up in the vertices. 
    no_vertices = size(vertex_to_index,2) - 1;
    for s = 1:no_vertices
        % Use the fact that indices ordered by the neighbors to do a reverse
        % search for possible cycles where move up in the first trade
        for i = flip(vertex_to_index(s):(vertex_to_index(s + 1) - 1))
            if (neighbors(i) < s) % If move down, no more possible cycles
                break;
            elseif (neighbors(i) == s) % 1-cycle
                if (weights(i) > 0)
                    cycles(end + 1) = i;
                    cycle_sizes(end + 1) = 1;
                end
            else 
                v = neighbors(i);
                % Vectorize partially finding new cycles
                % Search if can get from v to s         
                cycles_j = vertex_to_index(v) - 1 + uint32(find(neighbors(vertex_to_index(v):(vertex_to_index(v + 1) - 1)) == s));
                if (~isempty(cycles_j)) % Can find at most one index 
                    if ((weights(cycles_j) > 0) || (weights(i) > 0)) % Skip zero cycles
                        cycles = [cycles, i, cycles_j];
                        cycle_sizes = [cycle_sizes, 2];
                    end
                end
            end
        end
    end % While (s < no_vertices)
end

