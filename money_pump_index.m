%    money_pump_index - Rat_Measures Copyright (C) 2024  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [values_vec] = money_pump_index(P,Q)
% Calculates money pump indices from prices and quantities. 
% Input:
%   P: A matrix of prices where rows correspond to different goods and columns
%   to different time periods. The column vector at t gives the vector of
%   prices that the consumer faced in the period t. 
%   Q: A matrix of purchased quantities where rows correspond to different 
%   goods and columns to different time periods. The column vector at t gives 
%   the purchased bundle at period t. 
%
% Output:
%   values_vec(1): Average money pump index: The average amount of money one can extract 
%	from a consumer across money pump cycles. 
%	values_vec(2): Normalized money pump index: The average fraction of income one 
%	can extract from a consumer across money pump cycles. 
%   values_vec(3): The number of money pump cycles.
%
% Variables:
%   The revealed graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): For an edge i from v to w, weights(i) denotes the amount 
%     of income that could have been saved by purchasing w instead of v. 
%     weight_norm(i): For an edge i from v to w, weights(i) denotes the fraction 
%     of income that could have been saved by purchasing w instead of v. 
%     Income(i): Income when the trade i was available. 

sum_costs = 0;
sum_costs_norm = 0;
no_cycles = 0;

[vertex_to_index,neighbors,weights_norm] = find_neighbors(P,Q);

%Calculate incomes at each revealed preference
incomes_vertices = diag(P'*Q);
incomes = zeros(1,size(neighbors,2));
for i = 1:size(P,2)
    incomes(vertex_to_index(i):(vertex_to_index(i + 1)-1)) = incomes_vertices(i);
end      


%For MPI use non-normalized weights instead of fractions of income
%So multiply weights by income to get rid of the normalization
weights = weights_norm .* incomes;

%Test if there are cycles in the revealed preference graph
cycle_flag = dfs_cycle_search(neighbors,vertex_to_index);

if (cycle_flag)
	%calculate the sum of money pump index and normalized money pump index
    [sum_costs, sum_costs_norm, no_cycles] = johnsons_cycle_search_MPI(neighbors, vertex_to_index, weights, weights_norm, incomes);
	
	%Transform sum into average
    if (no_cycles > 0)
        sum_costs = sum_costs / double(no_cycles);
		sum_costs_norm = sum_costs_norm / double(no_cycles);
    end
end

%Collect output to a vector
values_vec(1) = sum_costs;
values_vec(2) = sum_costs_norm;
values_vec(3) = no_cycles;

end


% A depth-first search for cycles with at least one strict trade and
% calculation of average cost of cycle for money pump index and normalized
% money pump index. The algorithm is from Johnson (1975) "Finding All the 
% Elementary Circuits of a Directed Graph". 
%
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
% it did not find a cycle involving the vertex. After this a vertex u 
% can become unblocked again if the algorithm finds a cycle involving 
% a vertex v such that there is a path of blocked elements from u to v.

% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. 
%     weight_norm(i): The normalized weight of the edge i. 
%     incomes(i): Income at the edge i. 
% Output:
%	sum_costs: The sum of cost of cycles for the money pump index
%	sum_costs_norm: The sum of normlized average cost of cycles for
%	the normalized money pump index
%	no_cycles: The number of cycles
%
% Variables:
%   s: The lowest vertex that has unfound cycles. The cycle search searches
%   for cycles that start from s and goes through vertices in 
%   s,s+1,s+2,...
%   component: The strongly connected component of s.
%   removals_sc: The removed edges that lead to the outside of component.

function [sum_costs, sum_costs_norm, no_cycles] = johnsons_cycle_search_MPI(neighbors, vertex_to_index, weights, weights_norm, incomes) 


    sum_costs = 0;
	sum_costs_norm = 0;
    no_cycles = 0;

	%Use null removals for strong_component_min
    removals = false(1,size(neighbors,2));

    no_vertices = size(vertex_to_index,2) - 1;
	
    % The lowest vertex that has unfound cycles	
    s = 1;

    while (s < no_vertices) 

        % Update s to be the lowest vertex that has unfound cycles
        % This is done by searching for the strong component with the lowest
        % vertex index in the subgraph that includes only vertices with
        % index higher than s     
        component = strong_component_min(neighbors, vertex_to_index, s, removals);

        if (isempty(component)) % If no non-trivial strong components,
            s = no_vertices; % then stop search
        else 

            % Update s:
            % By strong_component_min minimum element is in the back
            s = component(end);

            % Make the subgraph induced by the strong component of s
            % This is done by removing all the edges from vertices in the
            % strong component to outside the strong component
            removals_vertex = true(1,no_vertices);
            removals_vertex(component) = false;
            
            
            % Remove edges leading to outside the strong component
            removals_sc = false(1,size(neighbors,2));

            for i = component
                removals_sc([false(1,vertex_to_index(i)-1),removals_vertex(neighbors(vertex_to_index(i):(vertex_to_index(i + 1) - 1)))]) = true;					
            end


            % initialize variables
            B = false(no_vertices,no_vertices);
            blocked = false(1,no_vertices);
            stack = uint32([]);
            [~, ~, ~, ~, sum_costs, sum_costs_norm, no_cycles] = CIRCUIT_SUBCYCLES_MPI(sum_costs, sum_costs_norm, no_cycles, stack, blocked, B, s, s, removals_sc, neighbors, vertex_to_index, weights, weights_norm, incomes);

        end
            %move on to the next element
            s = s + 1;

    end % while (s < no_vertices-1)
end

% J: logical procedure CIRCUIT (integer value v);
function [found_cycle, stack, blocked, B, sum_costs, sum_costs_norm, no_cycles] = CIRCUIT_SUBCYCLES_MPI(sum_costs, sum_costs_norm, no_cycles, stack, blocked, B, s, v, removals_sc, neighbors, vertex_to_index, weights, weights_norm, incomes)
	% Set cycle found flags 
    found_cycle = false; 
	
    blocked(v) = true; % Block v after visiting it
	
	% Search the neighbors if not removed and not blocked
    for i = vertex_to_index(v):(vertex_to_index(v + 1) - 1)
        if (~removals_sc(i))
            w = neighbors(i); % w: The next vertex in the search. 
            stack(end + 1) = i; % Add i to the search path
            if (w == s)  % If w = s, then found a cycle
                found_cycle = true;  % Flag the found cycle
                weights_sum_temp = sum(weights(stack)); % Sum of weights for MPI
				weights_norm_sum_temp = sum(weights_norm(stack)); % Sum of normalized weights for NMPI
                incomes_sum_temp = sum(incomes(stack)); %Total income for MPI
                if (weights_sum_temp > 0) % Found a cycle with a strict trade
				%Update the sums and number of cycles
                    sum_costs = sum_costs + weights_sum_temp / incomes_sum_temp; %Normalize sum by income
					sum_costs_norm = sum_costs_norm + weights_norm_sum_temp / length(stack); %Normalize sum by the size of cycle
                    no_cycles = no_cycles + 1; 
                end
            elseif (~blocked(w)) %If w not blocked, continue search
                [found_cycle_w, stack, blocked, B, sum_costs, sum_costs_norm, no_cycles] = CIRCUIT_SUBCYCLES_MPI(sum_costs, sum_costs_norm, no_cycles, stack, blocked, B, s, w, removals_sc, neighbors, vertex_to_index, weights, weights_norm, incomes);
                if (found_cycle_w) % Found a cycle in the current graph
                    found_cycle = true;
                end
            end
            stack(end) = []; % unstack v;
        end
    end

	% If found a cycle, then unblock v and all blocked paths leading to v
    if (found_cycle)
        [blocked, B] = UNBLOCK(blocked, B, v); 
    else 
		% If did not find a cycle, then add all the neighbors to B(v,:)
		B(v,neighbors(vertex_to_index(v):(vertex_to_index(v + 1) - 1))) = true;
    end
    return; 
end


% Unblock v and unblock all paths of blocked vertices leading to v 
function [blocked, B] = UNBLOCK(blocked, B, v)
    blocked(v) = false; % Unblock v
    for w = find(B(:,v)' & blocked) % Unblock all the blocked paths to v 
        [blocked, B] = UNBLOCK(blocked, B, w); 
    end
    B(:,v)=false;
end






