%    example_choi_et_al_stat_significance - Rationality_Measures Copyright (C) 2022  Lasse Mononen
%
%    This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
% An example of calculating the statistical significance levels for the 
% rationality violation for the choices in the experiment from Choi et al., 
% 2014, "Who Is (More) Rational?", American Economic Review. 
%
% This script uses the data file 'Example_Choi_et_al_Budget_Choices.csv'
% generated by Stata script Example_Choi_et_al_1.do.

% Include the Rationality_Measures folder and all the subfolders to the path
addpath(genpath('../')) 

% Choose the statistical significance level
significance_level=0.05;

% The sample size for estimating the probability that the observed data 
% is more (less) rational than random choices 
sample_size = 200;

%%%%%%%%%%%%%%%
%% Read data %%
%%%%%%%%%%%%%%%

data=importdata('Choi_et_al_Data/example_choi_et_al_budget_choices.csv');

% Drop observations without choices
data=data(all(~isnan(data(:,2:end)),2),:);

% Check if missing choices for some observations
find(isnan(data));

% Create background and storage variables
agents=size(data,1);
periods=25;
goods=2;
agentP=zeros(agents,goods,periods);
agentQ=zeros(agents,goods,periods);

% Each data row consists of user_id, the maximum x quantity available for 
% each period, the maximum y quantity available for each period, the 
% chosen x-quantity for each period, and the chosen y-quantity for each period. 
userid=data(1:agents,1);
max_x=data(1:agents,2:(1+periods));
max_y=data(1:agents,(2+periods):(1+2*periods));

% Calculate the prices by assuming that the income is 1 and so the prices
% are the reciprocals of the maximum quantities
agentP(:,1,:)=max_x.^(-1);
agentP(:,2,:)=max_y.^(-1);

% Read the chosen quantities
agentQ(:,1,:)=data(1:agents,(2+2*periods):(1+3*periods));
agentQ(:,2,:)=data(1:agents,(2+3*periods):(1+4*periods));

% Drop the original data variables
clearvars data


%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate Measures %%
%%%%%%%%%%%%%%%%%%%%%%%%

% Use variations of measures where the size of errors is measured in l^1
% norm and in l^{0.5} norm raised to the power of 0.5.
power_vec=[1,0.5];
 
% Calculate the number of different measures calculated
no_measure_variations = 3;
no_other_measures = 3;
total_no_measure = max(size(power_vec)) * no_measure_variations + no_other_measures;
        
% Create the storage files storing measures of rationality values	
prob_more_rational_than_random=zeros(agents,total_no_measure);    
prob_less_rational_than_random=zeros(agents,total_no_measure);    
prob_random_satisfies_garp = zeros(agents,1);

% The simulation in statistical_significance run in parallel
for i=1:agents
    i
    P=squeeze(agentP(i,:,:));
    Q=squeeze(agentQ(i,:,:));    
    [prob_more_rational_than_random(i,:),prob_less_rational_than_random(i,:),prob_random_satisfies_garp(i)]=statistical_significance(P, Q, power_vec, sample_size);
end 



%%%%%%%%%%%%%%%%%%%%%%%
%% Create the output %%
%%%%%%%%%%%%%%%%%%%%%%%

 
 % Create output variable titles
  measure_variations_names={'Varian','InvVarian','NMCI'};
  
 header={'Afriat','HM','Swaps'};
 % Add titles for each power variation
 % Skip the number if the power is 1
 for p=power_vec
     if p==1
         header = [header,measure_variations_names];
     else
         header = [header,strcat(measure_variations_names,string(p))];
     end
 end


Fraction_of_statistically_significantly_more_rational_choices_than_random_behavior = [header;mean(prob_more_rational_than_random>=1-significance_level)]


Fraction_of_statistically_significantly_less_rational_choices_than_random_behavior = [header;mean(prob_less_rational_than_random>=1-significance_level)]
