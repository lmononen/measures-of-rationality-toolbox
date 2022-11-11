%    calc_ordered_index_trans - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [index_to_ordered_index, ordered_index_to_index]  = calc_ordered_index_trans(vertex_to_index, weights, transformation)
% A helper function for ordering edges within each vertex to an increasing
% order according to weights when the edges with indices 
%{transformation(vertex_to_index(v)),transformation(vertex_to_index(v)+1),...,
% transformation(vertex_to_index(v+1)-1)} belong to vertex v. Returns a
% mapping for edge indices that are sorted within in vertex and its inverse
% function. 

% First, with identity transformation, this orders the out-edges to an
% increasing order. Second, if vertex_to_index is a cumulative function for 
% the number of in-edges and transformation maps indices to in-edges for 
% each vertex, then this orders in-edges to an increasing order. 

% Input: 
%   vertex_to_index: A cumulative function for the number of edges for each
%   vertex
%   weights: The weights for each edge used for sorting
%   transformation: A permutation for edge indices so that the edges in the set
%   {transformation(vertex_to_index(v)),transformation(vertex_to_index(v)+1),...,
%   transformation(vertex_to_index(v+1)-1)} belong to the vertex v

% Variables:
%   ordered_index_to_index: A mapping from the ranking of edges to the original
%   edge indices where the ranking is first done based on the indices of the
%   vertices that the edges belong to and second by the weights of the edges
%   within each vertex. 
%   index_to_ordered_index: A mapping from edge indices to the ranking of the
%   edges where the ranking is as above. 


% Sort the indices within each vertex for a mapping from ranking to edge
% indices
    ordered_index_to_index = uint32(zeros(1,size(weights,2)));
    for i = 1:(size(vertex_to_index,2)-1)
        [~, I] = sort(weights(transformation(vertex_to_index(i):(vertex_to_index(i + 1)-1))));
        I = uint32(I);
        I = I + vertex_to_index(i) - 1;
        ordered_index_to_index(vertex_to_index(i):(vertex_to_index(i + 1)-1)) = I;
    end    
    ordered_index_to_index = transformation(ordered_index_to_index);
    
    % Invert the mapping from ranking to edge indices
    index_to_ordered_index(ordered_index_to_index) = uint32(1:size(ordered_index_to_index,2));
        
end
