/*  
Example of applying measures of rationality to the data from Choi et al., 2014, "Who Is (More) Rational?", American Economic Review
Uses the article's data file "CKM_II_data.dta" available at doi.org/10.3886/E116126V1.
This file converts the Stata data file into comma-separated values that are legible by MATLAB. 
*/

clear 
 use CKM_II_data.dta
gen long id_member = 100*new_nohhold+nomem
outfile id_member point* x* y* using example_choi_et_al_budget_choices.csv, replace comma wide

