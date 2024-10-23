%    percentile_score - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.

function [prob_strictly_less_rational_than_random, prob_weakly_less_rational_than_random, prob_random_satisfies_garp] = percentile_score(P, Q, power_vec, sample_size)    
% Compares the measure of rationality from the data to the measure of 
% rationality of choosing uniformly randomly on the budget line. This gives
% the probability that the data has a strictly or weakly higher measure of 
% rationality than choosing randomly. 
% This provides a predictive power adjustment for the measures of 
% rationality following Dean and Martin (2016). 

% Input:
%   P: A matrix of prices where the rows index goods and the columns index
%   time periods. The column vector at t gives the vector of prices that 
%   the consumer faced in the period t. 
%   Q: A matrix of purchased quantities where the rows index
%   goods and the columns index time periods. The column vector at t gives 
%   the purchased bundle at the period t. 
%   power_vec: A vector of power variations to calculate for Varian's index, 
%   inverse Varian's index, and normalized minimum cost index. 
%   sample_size: The number of draws from the budget line used to estimate the
%   probabilities. 

% Output:
%   prob_strictly_less_rational_than_random: For each measure of rationality, 
%   the probability that the data has a strictly higher measure of rationality 
%   than choosing uniformly on the budget line.
%   prob_weakly_less_rational_than_random: For each measure of rationality, 
%   the probability that the data has a weakly higher measure of rationality 
%   than choosing uniformly on the budget line.
%   prob_random_satisfies_garp: Probability that uniform choices on the
%   budget line satisfy GARP.

% The order of indices:
%   1: Afriat's index
%   2: Houtman-Maks index
%   3: Swaps index
%   For each power_vec(j):
%     (3*j + 1): Varian's index of degree power_vec(j)
%     values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j)
%     values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j)

periods = size(P,2);
% The number of different measures
no_power_measure_variations = 3;
total_no_measures = 3 + size(power_vec,2) * no_power_measure_variations;
% Ordinal counting measures use integer values for comparison and simulations and
% data might have equal values with positive probability
ordinal_measures = [2,3];
% For cardinal measures, simulations and the data have equal values with zero
% probability
cardinal_measures = [1,4:total_no_measures];

% Counter for tracking how often simulated choices have a strictly lower 
% and higher measure than the observed data
data_strictly_less_rational_than_simulation = zeros(1,total_no_measures);
data_weakly_less_rational_than_simulation = zeros(1,total_no_measures);

% Counter for how many of the simulations satisfy GARP
simulation_satisfies_garp = 0;

% Calculate the measures for the data
measure_data = rationality_measures(P, Q, power_vec);

% Get rid of the normalization
measure_data = measure_data .* periods;

% Calculate income at each period
incomes = diag(P'*Q)';

% Simulate quantities uniformly on the budget line
% These are drawn before the parallel loop to ensure that they are
% independent
simQ_vec = sample_uniform_choice_on_budget_plane(P, incomes, sample_size);

% Run the simulations in parallel
parfor s = 1:sample_size
    % Use simulated quantities and the observed prices
    simQ = squeeze(simQ_vec(s,:,:));
    
    % Calculate the simulated measures of rationality
    measures_sim = rationality_measures(P, simQ, power_vec);
    
    % Get rid of the normalization
    measures_sim = measures_sim .* periods;    
    
    % Check if the data satisfies GARP and update the counter
    % This is done by checking for SARP since zero trades have a zero
    % probability
    simulation_satisfies_garp = simulation_satisfies_garp + data_rationalizable(P, simQ);
    
    data_strictly_less_rational_than_simulation_temp = zeros(1,total_no_measures);
    data_weakly_less_rational_than_simulation_temp = zeros(1,total_no_measures);
    
    %Check if the simulated choices have a lower or higher measure of rationality    
    data_strictly_less_rational_than_simulation_temp(cardinal_measures) = (measures_sim(cardinal_measures) < measure_data(cardinal_measures));
    data_weakly_less_rational_than_simulation_temp(cardinal_measures) = (measures_sim(cardinal_measures) <= measure_data(cardinal_measures));
    
    
    % For ordinal indices values integer so use rounding to get rid of
    % precision problems
    data_strictly_less_rational_than_simulation_temp(ordinal_measures) = (round(measures_sim(ordinal_measures)) < round(measure_data(ordinal_measures)));
    data_weakly_less_rational_than_simulation_temp(ordinal_measures) = (round(measures_sim(ordinal_measures)) <= round(measure_data(ordinal_measures)));
    
    % Update the counters    
    data_strictly_less_rational_than_simulation = data_strictly_less_rational_than_simulation + data_strictly_less_rational_than_simulation_temp;
    data_weakly_less_rational_than_simulation = data_weakly_less_rational_than_simulation + data_weakly_less_rational_than_simulation_temp;    
   
end

% Transform the counters to fractions that give the probability that
% simulated choices have a strictly or weakly lower measure of rationality
% than the observed data
prob_strictly_less_rational_than_random = double(data_strictly_less_rational_than_simulation) / sample_size;
prob_weakly_less_rational_than_random = double(data_weakly_less_rational_than_simulation) / sample_size;

% Calculate the probability that random choice satisfies garp
prob_random_satisfies_garp = double(simulation_satisfies_garp) / sample_size;
end

% Simulate choosing uniformly on the budget line defined by prices P and
% incomes for sample_size simulations. 
function simQ = sample_uniform_choice_on_budget_plane(P, incomes, sample_size)
% The output has dimension [sample_size,goods,periods]
% Sample uniform choice on G-dimensional probability simplex i.e. uniform
% choice on income shares  by sampling Gamma(1,1) G-times and normalizing 
% these to sum to 1 Repeat this for every period and every sample in 
% sample_size
 sample_gamma = gamrnd(1,1,sample_size,size(P,1),size(P,2));
 sum_sample_gamma = sum(sample_gamma,2);
 sum_sample_gamma = repmat(sum_sample_gamma,1,size(P,1),1);
 simQ = sample_gamma ./ sum_sample_gamma; 
 
 %Embed incomes and P to larger space
 incomes = reshape(incomes, [1, 1 ,size(P,2)]);
 P = reshape(P, [1, size(P,1),size(P,2)]);
 
 % Transform the uniform income share samples to uniform samples on budget
 % plane by multiplying the samples by income and dividing the samples
 % by the price of the good. 
 simQ = (simQ .* repmat(incomes,sample_size,size(P,1),1)) ./ repmat(P,sample_size,1,1); 
end
