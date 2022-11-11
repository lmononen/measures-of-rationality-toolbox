%    johnsons_critical_cycle_search - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [cycles, cycle_sizes] = johnsons_critical_cycle_search(neighbors, vertex_to_index, weights, removals) 

% A depth-first search for critical cycles with at least one strict trade 
% that removals missed and all the weak cycles without any strict trades. 
% The algorithm is based on Johnson (1975). "Finding All the Elementary
% Circuits of a Directed Graph". 

% The algorithm searches for all the weak cycles in the graph. A cycle is
% weak if it does not have any strict trades. In a modification to Johnson's
% algorithm, when a cycle is found, this is broken by removing the last
% non-zero edge and the search is returned to the beginning of this
% removed edge. 

% Johnson's algorithm looks sequentially first for all the cycles that 
% start at 1. Then all cycles that start at 2 but do not include 1 and 
% so forth. This is established by removing the previously searched 
% vertices and then  looking for a strongly connected component that 
% includes the lowest index. Then cycles are looked at within this lowest 
% strongly connected component starting from the lowest index. 
%
% Johnson's algorithm is based on searching through all the paths in the
% graph in a depth-first manner. However, Johnson's algorithm improves on
% searching through all the paths by blocking a vertex after visiting it if
% it did not find a weak cycle involving the vertex. After this a vertex u 
% can become unblocked again if the algorithm finds a cycle involving 
% a vertex v such that there is a path of blocked elements from u to v and
% either 1) the cycle is not weak and the edge removed to break the cycle
% is on the path to v (i.e. before visiting v) or 2) the cycle is weak. 

% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. 
%   removals: Indicators for already removed edges

% Variables:
%   s: The lowest vertex that has unfound cycles. The cycle search searches
%   for cycles that start from s and goes through vertices in 
%   s,s+1,s+2,...
%   component_s: The strongly connected component of s.
%   removals_comp_s: The removed edges that lead to the outside of component_s.
%   cycles: Vector of indices belonging to cycles.
%   cycle_sizes: Vector of cycle lengths. 
%     By moving in cycles by cycle_sizes, we can recover all the cycles.

    cycles = uint32([]); 
    cycle_sizes = uint32([]);      
    no_vertices = size(vertex_to_index,2) - 1;
    
    % The lowest vertex that has unfound cycles
    s = 1; 

    while (s < no_vertices) 

        % Update s to be the lowest vertex that has unfound cycles
        % This is done by searching for the strong component with the lowest
        % vertex index in the subgraph that includes only vertices with
        % index higher than s and removing edges in removals        
        component_s = strong_component_min(neighbors, vertex_to_index, s, removals);
        
        if (isempty(component_s))  % If no non-trivial strong components,
            s = no_vertices; % then stop search
        else                             
            % Update s:
            % By strong_component_min minimum element is in the back
            s = component_s(end);
            
            % Make the subgraph induced by the strong component of s
            % This is done by removing all the edges from vertices in the
            % strong component to outside the strong component
            
            removals_vertex = true(1,no_vertices);
            removals_vertex(component_s) = false;
            
            % Remove edges leading to outside the strong component
            removals_comp_s = false(1,size(neighbors,2));
            for i = component_s
                removals_comp_s([false(1,vertex_to_index(i)-1),removals_vertex(neighbors(vertex_to_index(i):(vertex_to_index(i + 1) - 1)))]) = true;
            end
                            
            % Initialize variables
            B = false(no_vertices,no_vertices);
            blocked = false(1,no_vertices);
            stack = uint32([]);
            [~, ~, ~, ~, ~, removals, cycles, cycle_sizes] = CIRCUIT_SUBCYCLES(stack, blocked, B, removals, cycles, cycle_sizes, s, s, removals_comp_s, neighbors, vertex_to_index, weights);
            
        end
            % Move on to the next element
            s = s + 1;

    end % While (s < no_vertices-1)
end


% A recursive depth-first search function for zero or critical cycles 
% starting from s, when the current search path is stack and the search is
% at v. The function returns if there are no more zero or critical cycles 
% that start with stack. 
%
% Variables:
%   stack: The current search path of edges.
%   blocked: Indicator for blocked vertices from searching again.
%   B: For each vertex v, the collection of neighbors of v after visiting and
%   blocking v. 
%   v: The current vertex location of the cycle search.
%   found_zero_cycle_v: A flag at vertex v, if found a cycle involving v.
%   found_critical_cycle: A flag for finding a critical cycle and the index
%   for the removed edge from the cycle. 
function [found_zero_cycle_v, found_critical_cycle, stack, blocked, B, removals, cycles, cycle_sizes] = CIRCUIT_SUBCYCLES(stack, blocked, B, removals, cycles, cycle_sizes, s, v, removals_comp_s, neighbors, vertex_to_index, weights)
    % Set cycle found flags 
    found_critical_cycle = 0;
    found_zero_cycle_v = false; 
    
    blocked(v) = true; % Block v after visiting it
    
    % Search the neighbors if not removed and not blocked
    for i = vertex_to_index(v):(vertex_to_index(v + 1) - 1)
        if (~removals(i)) && (~removals_comp_s(i))
            w = neighbors(i); % w: The next vertex in the search. 
            if (w == s || ~blocked(w)) % Move the search to w
                stack(end + 1) = i; % Add i to the search path
                if (w == s)  % If w = s, then found a zero cycle or a critical cycle
                    remove_index = find(weights(stack),1,'last'); % Check if a non-zero cycle
                    if (~isempty(remove_index)) % Found a cycle with a strict trade
                        cycles = [cycles,stack]; % Save the found critical cycle
                        cycle_sizes = [cycle_sizes, size(stack,2)]; 

                        removals(stack(remove_index)) = 1; % Remove the last nonzero trade
                        found_critical_cycle = stack(remove_index); % Unblock the current vertex and go back in the search
                    else % Found a zero cycle
                        found_zero_cycle_v = true; 
                    end
                else % Else if not blocked(w)
                    [found_zero_cycle_w, found_critical_cycle, stack, blocked, B, removals, cycles, cycle_sizes] = CIRCUIT_SUBCYCLES(stack, blocked, B, removals, cycles, cycle_sizes, s, w, removals_comp_s, neighbors, vertex_to_index, weights);
                    if (found_zero_cycle_w && ~found_critical_cycle) % If found_critical_cycle then the current stack path was removed from the graph
                        found_zero_cycle_v = true; % If found a weak cycle in the current graph
                    end
                end      
                stack(end) = []; % Unstack v;
                if (found_critical_cycle) 
                    if (found_critical_cycle == i) % Removed the current edge 
                        found_critical_cycle = 0; % Continue the search
                    else  
                        break; % Unblock the current vertex and go back in the search
                    end
                end
            end
        end
    end

    % If found a cycle, then unblock v and all blocked paths leading to v
    if (found_zero_cycle_v || found_critical_cycle)
        [blocked, B] = UNBLOCK(blocked, B, v); 
    else
        % If did not find a cycle, then add all the neighbors to B(v,:)
        B(v,neighbors(vertex_to_index(v):(vertex_to_index(v + 1) - 1))) = (~removals(vertex_to_index(v):(vertex_to_index(v + 1) - 1))) & (~removals_comp_s(vertex_to_index(v):(vertex_to_index(v + 1) - 1)));
    end
end


% Unblock v and unblock all paths of blocked vertices leading to v 
function [blocked, B] = UNBLOCK(blocked, B, v)
    blocked(v) = false; % Unblock v
    for w = find(B(:,v)' & blocked) % Unblock all the blocked paths to v 
        [blocked, B] = UNBLOCK(blocked, B, w); 
    end
    B(:,v)=false;
end




