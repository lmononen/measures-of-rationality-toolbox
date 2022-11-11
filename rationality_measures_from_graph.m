%    rationality_measures_from_graph - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function values_vec = rationality_measures_from_graph(vertex_to_index, neighbors, weights, power_vec)
% Calculates graph versions of measures of rationality from the weighted revealed preference graph. 
% Each measure of rationality is a sum of the measures of rationality for the
% subgraphs induced by each strongly connected component. 

% Input: 
%   The graph represented vertex_to_index, neighbors, and weights:
%     vertex_to_index: The edge indices between vertex_to_index(v) and 
%     vertex_to_index(v+1)-1 give the out-edges for the vertex v.
%     neighbors(i): The in-vertex of the edge i. 
%     weight(i): The weight of the edge i. %
%   power_vec: A vector of power variations to calculate for Varian's index, 
%   inverse Varian's index, and normalized minimum cost index. 
%
% Output:
%   values_vec(1): Afriat's index: The minimum cost of the largest edge 
%   needed to remove to make the graph acyclical
%
%   values_vec(2): Houtman-Maks index: The minimum fraction of vertices 
%   needed to remove so that there are no cycles with at least one strictly
%   positive edge. 
%
%   values_vec(3): Swaps index: The minimum number of edges needed to remove
%   so that there are no cycles with at least one strictly positive edge 
%   normalized by the number of vertices. 
%
%	For each power_vec(j):
%     values_vec(3*j + 1): Varian's index of degree power_vec(j): The 
%     minimum cost of removals of out-edges for each vertex to make the 
%     graph acyclical when removing out-edges at cost e_t at the vertex t 
%     remove all the out-edges from the vertex with a cost lower than 
%     e_t.  Additionally,  the costs are raised to the power of p and the 
%     minimum cost is normalized by the number of vertices.
%
%     values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j): 
%     The minimum cost of removals of in-edges for each vertex to make the 
%     graph acyclical when removing in-edges at cost e_t at the vertex t 
%     removes all the in-edges to the vertex with a cost lower than e_t. 
%     Additionally, the costs are raised to the power of p and the minimum 
%     cost is normalized by the number of vertices.
%
%     values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j): 
%     The minimum cost of removals of edges to make the graph acyclical 
%     when the costs of removals are raised to the power of p. The minimum 
%     cost is normalized by the number of vertices.

% Variables:
%   component: The index of the non-trivial strong component for each 
%   vertex. Trivial strong components have an index -1. 
%   vertex_to_comp_vertex: A mapping from the vertex index to the reduced
%   vertex index in the strong component when vertices not in the strong
%   component are ignored.
%   A reduced subgraph for the currently studied strong component
%   represented vertex_to_index_comp, neighbors_comp, and weights_comp

% Index numbers for the measures
afriat_index = 1;
hm_index = 2;
swaps_index = 3;
varian_index = 4;
invvarian_index = 5;
nmci_index = 6;
no_variations_measures = 3;
no_other_measures = 3;
    
% Container for the measures of rationality values
values_vec = zeros(1,size(power_vec,2) * no_variations_measures + no_other_measures);

% Check if any cycles. 
cycle_flag = dfs_cycle_search(neighbors,vertex_to_index);


if (cycle_flag)
    %%%%%%%%%%%%%%%%%%%%%%
    %%  Afriat's Index  %%
    %%%%%%%%%%%%%%%%%%%%%%
    
    values_vec(afriat_index) = afriat_dfs(neighbors, vertex_to_index, weights);
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %% Find strong components  %%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   % The measures of rationality can be computed independently within each strong component of the revealed preference graph.
   % Calculate to which strong component each vertex belongs. Skip trivial
   % singular components. 
   no_vertex = size(vertex_to_index,2) - 1;
   [num_components, component] = strong_component(neighbors, vertex_to_index);
   
   vertex_to_comp_vertex = uint32(zeros(1,no_vertex));
 
   % Calculate vertex index reductions for each strong component
    for comp = 1:num_components 
        comp_found = (component == comp);
        vertex_to_comp_vertex(comp_found) = 1:nnz(comp_found);
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Calculate measures of rationality for singleton strong           %% 
    %% components in case of 1-cycles                                   %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find all the trivial 1-cycles in singleton strong components
    trivial_cycles = uint32([]);
    for i = find(component == 0)
        self_cycles = find(neighbors(vertex_to_index(i):(vertex_to_index(i+1)-1)) == i);
        if (~isempty(self_cycles)) 
            trivial_cycles = [trivial_cycles, vertex_to_index(i) - 1 + uint32(self_cycles)];
        end
    end
    % For a trivial cycle formed by the edge i, the optimal solution removes
    % this edge at the cost 1 for swaps and hm_index and at the cost 
    % weight(i)^p for measure variation of degree p. 
    if (~isempty(trivial_cycles)) 
        values_vec(hm_index) = values_vec(hm_index) + size(trivial_cycles,2);
        values_vec(swaps_index) = values_vec(swaps_index) + size(trivial_cycles,2);
        for i = 1:size(power_vec,2)
            values_vec((4 + (i - 1) * no_variations_measures):(4 + i * no_variations_measures - 1)) = values_vec((4 + (i - 1) * no_variations_measures):(4 + i * no_variations_measures - 1)) + sum(weights(trivial_cycles).^(power_vec(i)));
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%  Do calculations separately within each component  %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for comp = 1:num_components 

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Reduce the revealed preference graph to the strong component %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        % Calculate the reduced revealed preference graph within the strong
        % component. 
        % Reduce neighbors, vertex_to_index, and weights to the component.
        weights_comp = [];
        neighbors_comp = uint32([]); 
        vertex_to_index_comp = uint32(1);

        for i = find(component == comp)
            neighbors_index_set = false(size(neighbors));
            neighbors_index_set(vertex_to_index(i):(vertex_to_index(i + 1) - 1)) = (component(neighbors(vertex_to_index(i):(vertex_to_index(i + 1) - 1))) == comp);
            neighbors_comp = [neighbors_comp, vertex_to_comp_vertex(neighbors(neighbors_index_set))];
            weights_comp = [weights_comp, weights(neighbors_index_set)];
            % in component
            vertex_to_index_comp(end + 1) = size(neighbors_comp,2) + 1;
        end
              
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% Compute Measures of rationality in the component %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Start the cycle search by two-cycles.
        [cycles_two, cycle_sizes_two] = two_cycles_search(neighbors_comp,vertex_to_index_comp);
		
		% Use the previously found cycles with all the future powers
        cycles_varian = cycles_two;
        cycle_sizes_varian = cycle_sizes_two;
        
        cycles_invvarian = cycles_two;
        cycle_sizes_invvarian = cycle_sizes_two;
        
        % Calculate Varian's index in the subgraph
        for i = 1:size(power_vec,2)
            power = power_vec(i);
            [value, cycles_varian, cycle_sizes_varian] = calculate_varian(neighbors_comp, vertex_to_index_comp, weights_comp, power, cycles_varian, cycle_sizes_varian);
            values_vec((i - 1) * no_variations_measures + varian_index) = values_vec((i - 1) * no_variations_measures + varian_index) + value;
        end
        
        % Calculate InvVarian index in the subgraph
        for i = 1:size(power_vec,2)
            power = power_vec(i);
            [value, cycles_invvarian, cycle_sizes_invvarian] = calculate_invvarian(neighbors_comp, vertex_to_index_comp, weights_comp, power, cycles_invvarian, cycle_sizes_invvarian);
            values_vec((i - 1) * no_variations_measures + invvarian_index) = values_vec((i - 1) * no_variations_measures + invvarian_index) + value;
        end
        
        % Calculate NMCI in the subgraph
        % Use Varian's cycles as a starting point
        cycles_nmci = cycles_varian;
        cycle_sizes_nmci = cycle_sizes_varian;
        for i = 1:size(power_vec,2)
            power = power_vec(i);
            [value, cycles_nmci, cycle_sizes_nmci] = calculate_nmci(neighbors_comp, vertex_to_index_comp, weights_comp, power, cycles_nmci, cycle_sizes_nmci);
            values_vec((i - 1) * no_variations_measures + nmci_index) = values_vec((i - 1) * no_variations_measures + nmci_index) + value;
        end
        
        % Calculate Houtman-Maks in the subgraph
        % If zero trades, then find all two-cycles with at least one strict
        % trade. Otherwise, use Varian's found cycles as a starting point. 
        zeros_flag = (~all(weights_comp));
        if(zeros_flag)
            [cycles_two_zeros, cycle_sizes_two_zeros] = two_cycles_search_zeros(neighbors_comp, vertex_to_index_comp, weights_comp);
            cycles_hm = cycles_two_zeros;
            cycle_sizes_hm = cycle_sizes_two_zeros;
        else
            cycles_hm = cycles_varian;
            cycle_sizes_hm = cycle_sizes_varian;
        end
        [value, cycles_hm, cycle_sizes_hm] = calculate_houtman_maks(neighbors_comp, vertex_to_index_comp, weights_comp, cycles_hm, cycle_sizes_hm);
        values_vec(hm_index) = values_vec(hm_index) + value;
        
        
        % Calculate Swaps in the subgraph
        % If zero trades, then use Houtman-Maks' cycles as a starting
        % point. Otherwise, use NMCI's cycles. 
       if(zeros_flag)
            cycles_swaps = cycles_hm;
            cycle_sizes_swaps = cycle_sizes_hm;
        else
            cycles_swaps = cycles_nmci;
            cycle_sizes_swaps = cycle_sizes_nmci;
       end
       [value, ~, ~] = calculate_swaps(neighbors_comp, vertex_to_index_comp, weights_comp, cycles_swaps, cycle_sizes_swaps);
       values_vec(swaps_index) = values_vec(swaps_index) + value;
    end % For each component

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Normalize the measures by the number of periods %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Skip Afriat's index
values_vec(2:end) = values_vec(2:end) / no_vertex;

end

