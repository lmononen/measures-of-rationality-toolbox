%    strong_component_min - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [components] = strong_component_min(neighbors, vertex_to_index, current_vertex, removals)
% First, this function uses a subgraph by only including vertices with an index
% higher than current_vertex and removing edges in removals. This function
% searches for the non-trivial strong component of the subgraph that
% includes the lowest vertex index using Tarjan's strongly connected 
% components algorithm (1972), "Depth-first search and linear graph 
% algorithms. Here, the search for additional strong components is stopped
% after the non-trivial strong component with the lowest index is found. 

% Input: 
%   The graph represented vertex_to_index and neighbors:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%   current_vertex: The vertices with an index higher than current_vertex are
%   included in the subgraph
%   removals: removed edges from the subgraph 

% Variables:
%   components: The SCC that contains the smallest vertex v that is a part of
%   a nontrivial SCC. The smallest vertex is the last element of the
%   component. 
%   stack: Visited vertices without designated strongly connected components
%   index: Time of the discovery of the vertex, -1 if unvisited, -2 if not in
%   stack i.e. found the strongly connected component for the vertex
%   lowlink_v: The root of the strongly connected component i.e. the lowest index that v has a cycle to.  
%   component_min_v: The smallest vertex in v's strongly connected
%   component

    no_vertex = size(vertex_to_index,2) - 1;    
    stack = uint32([]);
    components = uint32([]);
    index = int32(-ones(1,no_vertex));    
    index(1:current_vertex -1) = -2;
    

    for v=1:no_vertex
        if ((~isempty(components)) && (components(end) < v)) % if cannot find a smaller component anymore, stop the search
            break;
        end
        if (index(v) == -1) % Unvisited vertex
            [index, stack, components, ~, ~] = strong_component_min_sub(v, index, stack, components, neighbors, vertex_to_index, removals);
        end
    end
end

% Recursive depth-first search function for strong_components starting from 
% v. Returns lowlink_v that is the lowest time index such that there are paths 
% to and from v i.e. is the root of v's strong component and component_min_v
% that is the lowest vertex index that is a part of the SCC																	  
function [index, stack, components, lowlink_v, component_min_v] = strong_component_min_sub(v, index, stack, components, neighbors, vertex_to_index, removals)
    % The time of finding the vertex is marked by the stack size
    index(v) = size(stack,2);
    lowlink_v = size(stack,2);
    stack(end + 1) = v;
    component_min_v = v;
    
    for i = vertex_to_index(v):(vertex_to_index(v + 1) - 1)
        if (~removals(i))
            w = neighbors(i);
            if (index(w) == -1) % If w unvisited, then search starting from w
                [index, stack, components, lowlink_w, component_min_w] = strong_component_min_sub(w, index, stack, components, neighbors, vertex_to_index, removals);
                if (index(v) >= lowlink_w) % If w and v in the same SCC update the minimum component
                    component_min_v = min([component_min_v, component_min_w]);
                end
                lowlink_v = min([lowlink_v, lowlink_w]); % If lowlink_w > lowlink_v, then w and v are not in the same SCC
				% Update the root, if w had a path to an earlier visited vertex
				% than v.																						
            elseif (~(index(w) == -2)) % If w is on stack, then found a cycle involving v and w and so in the same SCC. Update the root of v's SCC by w's index. 
                lowlink_v = min([lowlink_v, index(w)]);
            end
        end
    end

    % If v is a root node, the stack from v to end forms a SCC
    if (lowlink_v == index(v)) 
        if (stack(end) == v) % If singular component then skip
            stack(end) = [];
            index(v) = -2; % Visited and unstacked
        else 
            % Check if the new component is smaller than the previous one
            % If smaller make the new SCC the smallest found SCC
            if (isempty(components) || components(end) > component_min_v)    
                first_index = find(stack == v);          
                scc = stack(first_index:end);
                % Swap the last element and component_min_v
                scc(scc == component_min_v) = scc(end);
                scc(end) = component_min_v;
                index(scc) = -2;
                components = scc;
            else % If the new component is not smaller, then skip it
                first_index = find(stack == v);   
                index(stack(first_index:end)) = -2; % Visited and unstacked
                stack(first_index:end) = []; % Remove from the stack 
            end
        end
    end
    return;
end