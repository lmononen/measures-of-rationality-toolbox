%    strong_component - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [num_components,components] = strong_component(neighbors, vertex_to_index)
% Tarjan's strongly connected components algorithm (1972), 
% "Depth-first search and linear graph algorithms". 
% A depth-first search for the partition of the graph such that there is 
% directed paths between any vertices in the same part.  

% Input: 
%   The graph represented vertex_to_index and neighbors:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 

% Variables:
%   components: SCC component index for each vertex ignoring trivial singular 
%   components. Index 0 corresponds to a singular component. 
%   stack: Visited vertices without designated strongly connected components.
%   index: Time of the discovery of the vertex, -1 if unvisited, -2 if not in
%   stack i.e. found the strongly connected component for the vertex.
%   lowlink_v: The root of the strongly connected component i.e. the lowest index that v has a cycle to.  


    component_counter = 0;
    no_vertex = size(vertex_to_index,2) - 1;    
    stack = uint32([]);
    components = uint32(zeros(1,no_vertex));
    index = int32(-ones(1,no_vertex));   
    
    for v=1:no_vertex
        if (index(v) == -1) % Unvisited vertex
            [index, stack, components, component_counter] = strong_component_sub(v, index, stack, components, component_counter, neighbors, vertex_to_index);
        end
    end
    num_components = component_counter;
end

% Recursive depth-first search function for strong_components starting from 
% v. Returns lowlink_v that is the lowest index such that there are paths 
% to and from v i.e. is the root of v's strong component. 		
function [index, stack, components, component_counter, lowlink_v] = strong_component_sub(v, index, stack, components, component_counter, neighbors, vertex_to_index)
    % The time of finding the vertex is marked by the stack size
    index(v) = size(stack,2);
    lowlink_v = size(stack,2);
    stack(end + 1) = v;
    
    for i = vertex_to_index(v):(vertex_to_index(v + 1) - 1)
        w = neighbors(i);
        if (index(w) == -1) % If w unvisited, then search starting from w
            [index, stack, components, component_counter, lowlink_w] = strong_component_sub(w, index, stack, components, component_counter, neighbors, vertex_to_index);
            lowlink_v = min([lowlink_v, lowlink_w]); % If lowlink_w > lowlink_v, then w and v are not in the same SCC
            % Update the root, if w had a path to an earlier visited vertex
            % than v.
            
        elseif (~(index(w) == -2)) % If w is on stack, the found a cycle involving v and w and so in the same SCC. Update the root of v's SCC by w's index. 
            lowlink_v = min([lowlink_v, index(w)]);
        end
    end
    
    % If v is a root node, the stack from v to end forms a SCC
    if (lowlink_v == index(v)) 
        if (stack(end) == v) % If a singular component, then skip
            stack(end) = [];
            index(v) = -2; % Visited and unstacked
        else 
            % Assign component_counter to the found SCC
            component_counter = component_counter + 1;
            first_index = find(stack == v);      
            % stack(first_index:end) is the found SCC
            components(stack(first_index:end)) = component_counter;
            index(stack(first_index:end)) = -2; % Visited and unstacked
            stack(first_index:end) = []; % Remove from the stack 
        end
    end
    return;
end

