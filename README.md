# Measures of Rationality Toolbox
Matlab program for computing measures of rationality for consumer choice data using methods discussed in Mononen (2022), "*Computing and Comparing Measures of Rationality*".

#
## Table of Contents

- [Background](#background)
  - [Measures of Rationality](#measures-of-rationality)
    - [Afriat's Efficiency Index](#afriats-efficiency-index)
    - [Houtman-Maks Index](#houtman-maks-index)
    - [Swaps Index](#swaps-index)
    - [Varian's Goodness-of-Fit of degree α](#varians-goodness-of-fit-of-degree-alpha)
    - [Inverse Varian's Goodness-of-Fit of degree α](#inverse-varians-goodness-of-fit-of-degree-alpha)
    - [Normalized Minimum Cost Index of degree α](#normalized-minimum-cost-index-of-degree-alpha)
  - [Measures of Rationality for Rationalization with Symmetric Utility](#measures-of-rationality-for-rationalization-with-symmetric-utility)
    - [Afriat's Efficiency Index with Symmetric Utility](#afriats-efficiency-index-with-symmetric-utility)
    - [Houtman-Maks Index with Symmetric Utility](#houtman-maks-index-with-symmetric-utility)
    - [Swaps Index with Symmetric Utility](#swaps-index-with-symmetric-utility)
    - [Varian's Goodness-of-Fit of degree α with Symmetric Utility](#varians-goodness-of-fit-of-degree-alpha-with-symmetric-utility)
    - [Inverse Varian's Goodness-of-Fit of degree α with Symmetric Utility](#inverse-varians-goodness-of-fit-of-degree-alpha-with-symmetric-utility)
    - [Normalized Minimum Cost Index of degree α with Symmetric Utility](#normalized-minimum-cost-index-of-degree-alpha-with-symmetric-utility)	
  - [Statistical Significance of Rationality Measures](#statistical-significance-of-rationality-measures)  	
- [Installation](#installation)  
- [Usage](#usage)
  - [Rationality Measures](#rationality-measures)
  - [Rationality Measures Symmetric](#rationality-measures-symmetric)
  - [Statistical Significance](#statistical-significance)  
- [References](#references)

## Background

The observed consumer choice data consists of $T$ observation of bundles and prices
$$D=\big((p_1,x_1),\dotsc,(p_T,x_T)\big)$$
where $p_i\in \mathbb{R}^G_{++}$ and $x_i\in \mathbb{R}^G_{+}$ for the number of goods $G$. 

The *revealed preference* is 
$$x_{t}\mathrel{\operatorname{R}}x_{t^\prime}\iff p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\operatorname{P}}x_{t^\prime}\iff p_t\cdot x_t   > p_t\cdot x_{t^\prime}.$$

A revealed preference $(\operatorname{R},\operatorname{P})$ is *acyclical* if there does not exist a cycle $(x_{t_1},\dotsc, x_{t_n})$ such that for each $1\leq i \leq n-1$, $x_{t_i}\mathrel{\operatorname{R}}x_{t_{i+1}}$ and $x_{t_n}\mathrel{\operatorname{P}}x_{t_{1}}$.

The data $D$ is *rationalizable* if there exists a non-satiated utility $u:\mathbb{R}^G_{+}\to\mathbb{R}$ that explains the choices as maximizing the utility subject to the budget constraint i.e. such that for each $t$ 
$$x_t\in \operatorname{arg\\,max}\\{ u(x)| x\cdot p_t \leq x_t\cdot p_t\\}.$$

As is well known, the data is rationalizable iff the revealed preference $(\operatorname{R},\operatorname{P})$ is acyclical (Afriat, 1967).

### Measures of Rationality

The measures of rationality capture how close the observed data is to being rationalizable. 

#### Afriat's Efficiency Index

For a common adjustment factor $e\in[0,1]$, define the relaxed revealed preference $(\operatorname{R}^{e},\operatorname{P}^{e})$ by for all 
$$x_{t}\mathrel{\operatorname{R}^{e}}x_{t^\prime}\iff (1-e)p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\operatorname{P}^{e}}x_{t^\prime}\iff (1-e)p_t\cdot x_t   > p_t\cdot x_{t^\prime}.$$

Afriat's efficiency index (1972) is 
$$\inf_{e\in[0,1]}e\text{ such that }(\operatorname{R}^{e},\operatorname{P}^{e}) \text{ is acyclical.}$$

#### Houtman-Maks Index

Houtman-Maks index (1985) is 
$$\inf_{B\subseteq T}\frac{1}{T}|B|\text{ such that } (p_i,x_i)_{i\in\\{1,\dotsc, T\\}\setminus B}\text{ is rationalizable.}$$

#### Swaps Index

Swaps index (Apesteguia & Ballester, 2015; Mononen, 2022) is 
$$\inf_{B\subseteq \operatorname{R}}\frac{1}{T}|B|\text{ such that }(\operatorname{R}\setminus B,\operatorname{P}\setminus B)\text{ is acyclical.}$$

#### Varian's Goodness-of-Fit of Degree $\alpha$

For an observation specific adjustment factors $(e_t)\in[0,1]^T$, define the relaxed revealed preference $(\operatorname{R}^{(e_t)},\operatorname{P}^{(e_t)})$ by for all 
$$x_{t}\mathrel{\operatorname{R}^{(e_t)}}x_{t^\prime}\iff (1-e_t)p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\operatorname{P}^{(e_t)}}x_{t^\prime}\iff (1-e_t)p_t\cdot x_t   > p_t\cdot x_{t^\prime}.$$

Varian's goodness-of-fit of degree $\alpha$ (Varian, 1990; Mononen, 2022)  is 
$$\inf_{e_t)\in[0,1]^T}\frac{1}{T}\sum_{t=1}^T e_t^\alpha\text{ such that }(\operatorname{R}^{(e_t)},\operatorname{P}^{(e_t)}) \text{ is acyclical.}$$

#### Inverse Varian's Goodness-of-Fit of Degree $\alpha$

For an observation specific adjustment factors $(e_{t^\prime})\in[0,1]^T$, define the relaxed revealed preference $(\operatorname{R}^{(e_{t^\prime})},\operatorname{P}^{(e_{t^\prime})})$ by for all 
$$x_{t}\mathrel{\operatorname{R}^{(e_{t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t\geq (1-e_{t^\prime})p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\operatorname{P}^{(e_{t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t   > (1-e_{t^\prime})p_t\cdot x_{t^\prime}.$$

Inverse Varian's goodness-of-fit of degree $\alpha$ (Mononen, 2022) is 
$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t^\prime=1}^T e_{t^\prime}^\alpha\text{ such that }(\operatorname{R}^{(e_{t^\prime})},\operatorname{P}^{(e_{t^\prime})}) \text{ is acyclical.}$$

#### Normalized Minimum Cost Index of Degree $\alpha$

For a relation specific adjustment factors $(e_{t,t^\prime})\in[0,1]^{T\times T}$, define the relaxed revealed preference $(\operatorname{R}^{(e_{t,t^\prime})},\operatorname{P}^{(e_{t,t^\prime})})$ by for all 
$$x_{t}\mathrel{\operatorname{R}^{(e_{t,t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t\geq (1-e_{t,t^\prime})p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\operatorname{P}^{(e_{t,t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t   > (1-e_{t,t^\prime})p_t\cdot x_{t^\prime}.$$

Normalized minimum cost index of degree $\alpha$ (Mononen, 2022) is 
$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t^\prime=1}^T e_{t,t^\prime}^\alpha\text{ such that }(\operatorname{R}^{(e_{t^\prime})},\operatorname{P}^{(e_{t^\prime})}) \text{ is acyclical.}$$

### Measures of Rationality for Rationalization with Symmetric Utility

Next, we consider the rationalization of the observed choices by a symmetric utility. Especially, if the goods are risky assets where one of them pays off with equal probability, then this corresponds to rationalization by a utility that satisfies first-order stochastic dominance.

For a permutation of goods $\pi:\\{1,\dotsc, G\\}\to\\{1,\dotsc, G\\}$, denote the permutation of a bundle $(x_i)\_{i=1}^{G}$ as $\pi((x_i)\_{i=1}^{G})=(x_{\pi(i)})_{i=1}^G$.

Define the symmetrically extended revealed preference for all $t, t^\prime$ and permutations $\pi$ as  
$$x_{t}\mathrel{\operatorname{R_S}}\pi(x_{t^\prime})\iff p_t\cdot x_t\geq p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}}x_{t^\prime}\iff p_t\cdot x_t   > p_t\cdot x_{t^\prime}.$$

The choices can be rationalized by a symmetric and non-satiated utility function if and only if $(\operatorname{R_S},\operatorname{P_S})$ is acyclical (Chambers & Rehbeck, 2018). 

Using these symmetrically extended revealed preferences and their acyclicality, we can extend all the previous measures of rationality to rationalization by a symmetric utility. 

####  Afriat's Efficiency Index with Symmetric Utility

For a common adjustment factor $e\in[0,1]$, define the relaxed revealed preference $(\operatorname{R_S}^{e},\operatorname{P_S}^{e})$ by for all  $t, t^\prime$ and permutations $\pi$ as  
$$x_{t}\mathrel{\operatorname{R_S}}\pi(x_{t^\prime})\iff (1-e)p_t\cdot x_t\geq p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}}\pi(x_{t^\prime})\iff (1-e)p_t\cdot x_t   > p_t\cdot \pi(x_{t^\prime}).$$

Afriat's efficiency index with symmetric utility is 
$$\inf_{e\in[0,1]}e\text{ such that }(\operatorname{R_S}^{e},\operatorname{P_S}^{e}) \text{ is acyclical.}$$

#### Houtman-Maks Index with Symmetric Utility

Houtman-Maks index with symmetric utility is 
$$\inf_{B\subseteq T}\frac{1}{T}|B|\text{ such that } (p_i,x_i)_{i\in\\{1,\dotsc, T\\}\setminus B}\text{ is rationalizable with symmetric utility.}$$

#### Swaps Index with Symmetric Utility

Swaps index with symmetric utility is $\inf_{B\subseteq \operatorname{R_S}}\frac{1}{T}|B|$  such that by defining for all  $t, t^\prime$ with $(t,t^\prime)\notin B$ and permutations $\pi$ 
$$x_{t}\mathrel{\operatorname{R_S}}\pi(x_{t^\prime})\iff (1-e)p_t\cdot x_t\geq p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}}\pi(x_{t^\prime})\iff (1-e)p_t\cdot x_t   > p_t\cdot \pi(x_{t^\prime})$$
$(\operatorname{R_S},\operatorname{P_S})$ is acyclical. 

#### Varian's Goodness-of-Fit of Degree $\alpha$ with Symmetric Utility

For an observation specific adjustment factors $(e_t)\in[0,1]^T$, define the relaxed revealed preference $(\operatorname{R_S}^{(e_t)},\operatorname{P_S}^{(e_t)})$  by for all  $t, t^\prime$ and permutations $\pi$ as  
$$x_{t}\mathrel{\operatorname{R_S}^{(e_t)}}\pi(x_{t^\prime})\iff (1-e_t)p_t\cdot x_t\geq p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}^{(e_t)}}\pi(x_{t^\prime})\iff (1-e_t)p_t\cdot x_t   > p_t\cdot \pi(x_{t^\prime}).$$

Varian's goodness-of-fit of degree $\alpha$ with symmetric utility is 
$$\inf_{e_t)\in[0,1]^T}\frac{1}{T}\sum_{t=1}^T e_t^\alpha\text{ such that }(\operatorname{R_S}^{(e_t)},\operatorname{P_S}^{(e_t)}) \text{ is acyclical.}$$

#### Inverse Varian's Goodness-of-Fit of Degree $\alpha$ with Symmetric Utility

For an observation specific adjustment factors $(e_{t^\prime})\in[0,1]^T$, define the relaxed revealed preference $(\operatorname{R_S}^{(e_{t^\prime})},\operatorname{P_S}^{(e_{t^\prime})})$  by for all  $t, t^\prime$ and permutations $\pi$ as  
$$x_{t}\mathrel{\operatorname{R_S}^{(e_{t^\prime})}}\pi(x_{t^\prime})\iff p_t\cdot x_t\geq (1-e_{t^\prime})p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}^{(e_{t^\prime})}}\pi(x_{t^\prime})\iff p_t\cdot x_t   > (1-e_{t^\prime})p_t\cdot \pi(x_{t^\prime}).$$

Inverse Varian's goodness-of-fit of degree $\alpha$ with symmetric utility is 
$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t^\prime=1}^T e_{t^\prime}^\alpha\text{ such that }(\operatorname{R_S}^{(e_{t^\prime})},\operatorname{P_S}^{(e_{t^\prime})}) \text{ is acyclical.}$$

#### Normalized Minimum Cost Index of Degree $\alpha$ with Symmetric Utility

For a relation specific adjustment factors $(e_{t,t^\prime})\in[0,1]^{T\times T}$, define the relaxed revealed preference $(\operatorname{R_S}^{(e_{t,t^\prime})},\operatorname{P_S}^{(e_{t,t^\prime})})$  by for all  $t, t^\prime$ and permutations $\pi$ as  
$$x_{t}\mathrel{\operatorname{R_S}^{(e_{t,t^\prime})}}\pi(x_{t^\prime})\iff (1-e_{t,t^\prime})p_t\cdot x_t\geq p_t\cdot \pi(x_{t^\prime})\text{ or } t=t^\prime$$
$$x_{t}\mathrel{\operatorname{P_S}^{(e_{t,t^\prime})}}\pi(x_{t^\prime})\iff (1-e_{t,t^\prime})p_t\cdot x_t   > p_t\cdot \pi(x_{t^\prime}).$$

Normalized minimum cost index of degree $\alpha$ with symmetric utility is 
$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t^\prime=1}^T e_{t,t^\prime}^\alpha\text{ such that }(\operatorname{R_S}^{(e_{t^\prime})},\operatorname{P_S}^{(e_{t^\prime})}) \text{ is acyclical.}$$

### Statistical Significance of Rationality Measures

The significance levels for violations of rationality are based on testing if the measure of rationality observed in the data could have been generated by a person choosing randomly on the budget line. Formally, for a number of goods $G$ and prices $p_t$ denote the income $w_t=p_t\cdot x_t$ and the budget line 
$$B(p_t,w_t)=\\{x\in \mathbb{R}_{+}^G| p_t \cdot x=w_t\\}.$$
For a measure of rationality $I$, we are testing the null hypothesis with one-sided tests
$$H_0: I\big((p_1,x_1),\dotsc, (p_T,x_T)\big)\sim I\big((p_1,\operatorname{Uni}(B(p_1,w_1))),\dotsc, (p_T,\operatorname{Uni}(B(p_T,w_T)))\big).$$

Here, the p-value of the test is the probability that random choices are less (more) rational than the observed choices.

## Installation

1. Download the repository.

2. Open the main folder of the repository in MATLAB.

3. Run the below command to include the main folder and the subfolders to the MATLAB path

```
addpath(genpath('./'))
```


## Usage

The directory `Examples` offers minimal examples of the usage and an application to the experiment from Choi et al., 2014, "Who Is (More) Rational?", American Economic Review. 

### Rationality Measures

The function `rationality_measures` calculates measures of rationality from prices and quantities. 

    values_vec = rationality_measures(P, Q, power_vec)
      Input:
        P: A matrix of prices where the rows index goods and the columns
          index time periods. The column vector at t gives the vector of
          prices that the consumer faced in the period t. 
        Q: A matrix of purchased quantities where the rows index
          goods and the columns index time periods. The column vector at t gives 
          the purchased bundle at the period t. 
        power_vec: A vector of power variations to calculate for Varian's index, 
          inverse Varian's index, and normalized minimum cost index. 
        
      Output: 
        values_vec(1): Afriat's index
        values_vec(2): Houthman-Maks index
        values_vec(3): Swaps index
        For each power_vec(j):
          values_vec(3*j + 1): Varian's index of degree power_vec(j)
          values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j)
          values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j)
		  

### Rationality Measures Symmetric


The function `rationality_measures_symmetric` calculates measures of rationality for symmetric utility from prices and quantities. 

    values_vec = rationality_measures_symmetric(P, Q, power_vec)
      Input:
        P: A matrix of prices where the rows index goods and the columns
          index time periods. 
        Q: A matrix of purchased quantities where the rows index
          goods and the columns index time periods. 
        power_vec: A vector of power variations to calculate for Varian's index, 
          inverse Varian's index, and normalized minimum cost index. 
        
      Output: 
        values_vec(1): Afriat's index with symmetric utility
        values_vec(2): Houthman-Maks index with symmetric utility
        values_vec(3): Swaps index with symmetric utility
        For each power_vec(j):
          values_vec(3*j + 1): Varian's index of degree power_vec(j) with symmetric utility
          values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j) with symmetric utility
          values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j) with symmetric utility

### Statistical Significance

The function `statistical_significance` compares the measure of rationality from the data to the measure of rationality of choosing uniformly randomly on the budget line. This gives the probability that the data has a lower or higher measure of rationality than choosing randomly. This provides a statistical test for the significance of rationality violations following Mononen (2022).

    [prob_more_rational_than_random, prob_less_rational_than_random, prob_random_satisfies_garp] 
	= statistical_significance(P, Q, power_vec, sample_size)    
      Input:
        P: A matrix of prices where the rows index goods and the columns
          index time periods. 
        Q: A matrix of purchased quantities where the rows index
          goods and the columns index time periods. 
        power_vec: powers of indices to calculate for Varian's index, inverse
          Varian's index, and normalized minimum cost index.
        sample_size: The number of draws from the budget line used to estimate the
          probabilities. 
     
      Output:
        prob_more_rational_than_random: For each measure of rationality, 
          the probability that the data has a lower measure of rationality than 
          choosing uniformly on the budget line.
        prob_less_rational_than_random: For each measure of rationality, 
          the probability that the data has a higher measure of rationality than 
          choosing uniformly on the budget line.
        prob_random_satisfies_garp: The probability that uniform choices on the
          budget line satisfy GARP.
     
      The order of indices:
        1: Afriat's index
        2: Houtman-Maks index
        3: Swaps index
        For each degree in power_vec(j):
          3*j + 1: Varian's index of order power_vec(j)
          3*j + 2: Inverse Varian's index of order power_vec(j)
          3*j + 3: Normalized minimum cost index of order power_vec(j)
		  
## References

Afriat, Sydney N. (1967). The construction of utility functions from expenditure data. *International economic review* 8(1), pp. 67–77.

Afriat, Sydney N. (1972). Efficiency estimation of production functions. *International economic review*, 13(3) pp. 568–598.

Apesteguia, Jose and Ballester, Miguel (2015). A measure of rationality and welfare. *Journal of Political Economy* 123(6), pp. 1278–1310.

Chambers, Christopher P. and Rehbeck, John (2018). Note on symmetric utility. *Economics Letters* 162, pp. 27-29.

Choi, Syngjoo; Kariv, Shachar; Müller, Wieland, and Silverman, Dan (2014). Who Is (More) Rational? *American Economic Review* 104(6), pp. 1518–50.

Houtman, Martijn and Maks, J. A. H. (1985). Determining All Maximal Data Subsets Consistent with Revealed Preference. *Kwantitatieve methoden* 19(1), pp. 89–104.

Mononen, Lasse (2022). Computing and Comparing Measures of Rationality.

Varian, Hal R. (1990). Goodness-of-fit in optimizing models. *Journal of Econometrics* 46(1),pp. 125–140.
