%    find_removals - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [removals,value] = find_removals(weights, constraint_matrix, power) 
% Find the optimal removals for breaking all the cycles as defined by constraint_matrix
% when the costs of removals are weights^power.

% Variables: 
%   weights: The cost of removals of edges/vertices depending on the problem. 
%   power: The power order of the index. 
%   constraint_matrix: A constraint matrix for the binary linear programming 
%   problem of removing all the found critical cycles. 

    no_rel = size(weights,2);
    
    options = optimoptions('intlinprog','Display','off');
    [x,value,~,~] = intlinprog((weights').^(power),1:no_rel,constraint_matrix,-ones(size(constraint_matrix,1),1),[],[], zeros(no_rel,1),ones(no_rel,1),[],options);
    
    % Transform removals from doubles to logical values.
    removals = (x > 0.5)';
end

