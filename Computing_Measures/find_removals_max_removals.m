%    find_removals_max_removals - Rationality_Measures Copyright (C) 2023  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [removals,value] = find_removals_max_removals(weights, constraint_matrix, max_removals) 
% Find the optimal removals for breaking all the cycles as defined by constraint_matrix
% when the costs of removals are weights and at most max_removals removals
% are done.

% Variables: 
%   weights: The cost of removals of edges/vertices depending on the problem. 
%   power: The power order of the index. 
%   constraint_matrix: A constraint matrix for the binary linear programming 
%   problem of removing all the found critical cycles. 

    no_rel = size(weights,2);
    
    options = optimoptions('intlinprog','Display','off');
    [x,value,~,~] = intlinprog((weights'),1:no_rel,[ones(1,size(constraint_matrix,2));constraint_matrix],[max_removals;-ones(size(constraint_matrix,1),1)],[],[], zeros(no_rel,1),ones(no_rel,1),[],options);
    
    % Transform removals from doubles to logical values.
    removals = (x > 0.5)';
end

