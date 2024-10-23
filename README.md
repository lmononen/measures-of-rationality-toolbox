# Measures of Rationality Toolbox
Matlab program for computing measures of rationality for consumer choice data using methods discussed in Mononen (2023), "*Computing and Comparing Measures of Rationality*".

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
    - [Money Pump Index](#money-pump-index)
    - [Normalized Money Pump Index](#normalized-money-pump-index)
    - [Number of Cycles](#number-of-cycles)
  - [Measures of Rationality for Rationalization with Symmetric Utility](#measures-of-rationality-for-rationalization-with-symmetric-utility)
    - [Afriat's Efficiency Index with Symmetric Utility](#afriats-efficiency-index-with-symmetric-utility)
    - [Houtman-Maks Index with Symmetric Utility](#houtman-maks-index-with-symmetric-utility)
    - [Swaps Index with Symmetric Utility](#swaps-index-with-symmetric-utility)
    - [Varian's Goodness-of-Fit of degree α with Symmetric Utility](#varians-goodness-of-fit-of-degree-alpha-with-symmetric-utility)
    - [Inverse Varian's Goodness-of-Fit of degree α with Symmetric Utility](#inverse-varians-goodness-of-fit-of-degree-alpha-with-symmetric-utility)
    - [Normalized Minimum Cost Index of degree α with Symmetric Utility](#normalized-minimum-cost-index-of-degree-alpha-with-symmetric-utility)	
  - [Percentile Score](#percentile-score)  	
- [Installation](#installation)  
- [Usage](#usage)
  - [Rationality Measures](#rationality-measures)
  - [Money Pump Index](#money-pump-index-usage)
  - [Rationality Measures Symmetric](#rationality-measures-symmetric)
  - [Percentile Score](#percentile-score-usage)  
- [References](#references)

# Background

The observed consumer choice data consists of $T$ observations of prices and bundles

$$D=\big((p_1,x_1),\dotsc,(p_T,x_T)\big)$$

where prices $p_t\in \mathbb{R}^G_{++}$ and bundles $x_t\in \mathbb{R}^G_{+}$ for the number of goods $G$. 

The *revealed preference* is 

$$x_{t}\mathrel{\text{R}}x_{t^\prime}\iff p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\text{P}}x_{t^\prime}\iff p_t\cdot x_t   > p_t\cdot x_{t^\prime}\mathrlap{.}$$

A revealed preference $(\mathop{\text{R}},\mathop{\text{P}})$ is *acyclical* if there does not exist a cycle $(x_{t_1},\dotsc, x_{t_n})$ such that for each $1\leq i \leq n-1$, $x_{t_i}\mathrel{\text{R}}x_{t_{i+1}}$ and $x_{t_n}\mathrel{\text{P}}x_{t_{1}}$.

The data $D$ is *rationalizable* if there exists a non-satiated utility $u:\mathbb{R}^G_{+}\to\mathbb{R}$ that explains the choices as maximizing the utility subject to the budget constraint i.e. such that for each $t$ 

$$x_t\in \mathop{\text{arg\\,max}}\\{ u(x)| x\cdot p_t \leq x_t\cdot p_t\\}.$$

As is well known, the data is rationalizable iff the revealed preference $(\mathop{\text{R}},\mathop{\text{P}})$ is acyclical and satisfies the generalized axiom of revealed preference (GARP) (Afriat, 1967).

## Measures of Rationality

The measures of rationality capture how close the observed data is to being rationalizable. 

### Afriat's Efficiency Index

For a common adjustment factor $e\in[0,1]$, define the relaxed revealed preference $(\mathop{\text{R}^{e}},\mathop{\text{P}^{e}})$ by for all 

$$x_{t}\mathrel{\text{R}^{e}}x_{t^\prime}\iff (1-e)p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\text{P}^{e}}x_{t^\prime}\iff (1-e)p_t\cdot x_t   > p_t\cdot x_{t^\prime}\mathrlap{.}$$

Afriat's critical cost efficiency index (1972) is 

$$\inf_{e\in[0,1]}e\text{ such that }(\mathop{\text{R}^{e}},\mathop{\text{P}^{e}}) \text{ is acyclical.}$$

### Houtman-Maks Index

Houtman-Maks index (1985) is 

$$\inf_{B\subseteq T}\frac{1}{T}|B|\text{ such that } (p_i,x_i)_{i\in\\{1,\dotsc, T\\}\setminus B}\text{ is rationalizable.}$$

### Swaps Index

Swaps index (Apesteguia & Ballester, 2015; Mononen, 2023) is 

$$\inf_{B\subseteq \mathop{\text{R}}}\frac{1}{T}|B|\text{ such that }(\mathop{\text{R}}\setminus B,\mathop{\text{P}}\setminus B)\text{ is acyclical.}$$

### Varian's Goodness-of-Fit of Degree $\alpha$

For observation specific adjustment factors $(e_t)\in[0,1]^T$, define the relaxed revealed preference $(\mathop{\text{R}^{(e_t)}},\mathop{\text{P}^{(e_t)}})$ by for all 

$$x_{t}\mathrel{\text{R}^{(e_t)}}x_{t^\prime}\iff (1-e_t)p_t\cdot x_t\geq p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\text{P}^{(e_t)}}x_{t^\prime}\iff (1-e_t)p_t\cdot x_t   > p_t\cdot x_{t^\prime}\mathrlap{.}$$

Varian's goodness-of-fit of degree $\alpha$ (Varian, 1990; Mononen, 2023) for $\alpha>0$ is 

$$\inf_{(e_t)\in[0,1]^T}\frac{1}{T}\sum_{t=1}^T e_t^\alpha\text{ such that }(\mathop{\text{R}^{(e_t)}},\mathop{\text{P}^{(e_t)}}) \text{ is acyclical.}$$

Varian's goodness-of-fit of degree $0$ (Mononen, 2023) is 

$$\inf_{(e_{t})\in[0,1]^T}\frac{1}{T}\bigg(|\\{t|e_{t}>0\\}| + \Big(\prod_{t|e_{t}>0} e_{t} \Big)^{\frac{1}{|\\{t|e_{t}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e_{t})}} \text{ is acyclical.}$$

### Inverse Varian's Goodness-of-Fit of Degree $\alpha$

For observation specific adjustment factors $(e_{t^\prime})\in[0,1]^T$, define the relaxed revealed preference $(\mathop{\text{R}^{(e_{t^\prime})}},\mathop{\text{P}^{(e_{t^\prime})}})$ by for all 

$$x_{t}\mathrel{\text{R}^{(e_{t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t\geq (1-e_{t^\prime})p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\text{P}^{(e_{t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t   > (1-e_{t^\prime})p_t\cdot x_{t^\prime}\mathrlap{.}$$

Inverse Varian's goodness-of-fit of degree $\alpha$ (Mononen, 2023) for $\alpha>0$ is 

$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t^\prime=1}^T e_{t^\prime}^\alpha\text{ such that }(\mathop{\text{R}^{(e_{t^\prime})}},\mathop{\text{P}^{(e_{t^\prime})}}) \text{ is acyclical.}$$

Inverse Varian's goodness-of-fit of degree $0$ (Mononen, 2023) is 

$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\bigg(|\\{t^\prime|e_{t^\prime}>0\\}| + \Big(\prod_{t^\prime|e_{t^\prime}>0} e_{t^\prime} \Big)^{\frac{1}{|\\{t^\prime|e_{t^\prime}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e_{t^\prime})}} \text{ is acyclical.}$$

### Normalized Minimum Cost Index of Degree $\alpha$

For relation specific adjustment factors $(e_{t,t^\prime})\in[0,1]^{T\times T}$, define the relaxed revealed preference $(\mathop{\text{R}^{(e_{t,t^\prime})}},\mathop{\text{P}^{(e_{t,t^\prime})}})$ by for all 

$$x_{t}\mathrel{\text{R}^{(e_{t,t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t\geq (1-e_{t,t^\prime})p_t\cdot x_{t^\prime}$$
$$x_{t}\mathrel{\text{P}^{(e_{t,t^\prime})}}x_{t^\prime}\iff p_t\cdot x_t   > (1-e_{t,t^\prime})p_t\cdot x_{t^\prime}\mathrlap{.}$$

Normalized minimum cost index of degree $\alpha$ (Mononen, 2023) for $\alpha>0$ is 

$$\inf_{(e_{t,t^\prime})\in[0,1]^T}\frac{1}{T}\sum_{t=1}^T\sum_{t^\prime=1}^T e_{t,t^\prime}^\alpha\text{ such that }(\mathop{\text{R}^{(e_{t,t^\prime})}},\mathop{\text{P}^{(e_{t,t^\prime})}}) \text{ is acyclical.}$$

Normalized minimum cost index of degree $0$ (Mononen, 2023) is 

$$\inf_{(e_{t,t^\prime})\in[0,1]^T}\frac{1}{T}\bigg(|\\{(t,t^\prime)|e_{t,t^\prime}>0\\}| + \Big(\prod_{(t,t^\prime)|e_{t,t^\prime}>0} e_{t,t^\prime} \Big)^{\frac{1}{|\\{(t,t^\prime)|e_{t,t^\prime}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e_{t,t^\prime})}} \text{ is acyclical.}$$

### Money Pump Index

For data $\big((p_1,x_1),\dotsc,(p_T,x_T)\big)\in\mathcal D,$ say that $(x_{t_1},\dotsc,x_{t_n})$ is a *cycle* if for all $1\leq i\leq n$, when $x_{t_{n+1}}\coloneqq x_{t_1}$,

$$x_{t_i}\\mathrel{\text{R}} x_{t_{i+1}}\text{ and for some $1\leq i^\prime\leq n$, }x_{t_{i^\prime}}\mathrel{\text{P}} x_{t_{i^\prime+1}}/$$

The collection of cycles up to different rotations is denoted by $\mathcal C$. 

The average money pump index (Echenique et al., 2011) is 

$$\frac{1}{\mathcal C}\sum_{(x_{t_1},\dotsc,x_{t_n})\in\mathcal C}\frac{\sum_{i=1}^n p_{t_i}\cdot(x_{t_i}-x_{t_{i+1}})}{\sum_{i=1}^n p_{t_i}\cdot x_{t_i}}.$$


### Normalized Money Pump Index

We use the notation from the money pump index. The average normalized money pump index (Mononen, 2022) is 

$$\frac{1}{\mathcal C}\sum_{(x_{t_1},\dotsc,x_{t_n})\in\mathcal C}\frac{1}{n}\sum_{i=1}^n\frac{p_{t_i}\cdot(x_{t_i}-x_{t_{i+1}})}{p_{t_i}\cdot x_{t_i}}.$$


### Number of Cycles

We use the notation from the money pump index. The number of cycles (Swofford & Whitney, 1987) is 

$$|{\mathcal C}|.$$

## Measures of Rationality for Rationalization with Symmetric Utility

Next, we consider the rationalization of the observed choices by a symmetric utility. Especially, if the goods are risky assets where one of them pays off with equal probability, then this corresponds to rationalization by a utility that satisfies first-order stochastic dominance.

For a permutation of goods $\pi:\\{1,\dotsc, G\\}\to\\{1,\dotsc, G\\}$, denote the permutation of a bundle $(x_i)\_{i=1}^{G}$ as $\pi((x\_i)\_{i=1}^{G})=(x\_{\pi(i)})\_{i=1}^G$.

Define the symmetrically extended revealed preference for all $t, t^\prime$ and permutations $\pi$ as  

$$x\_{t}\mathrel{\text{R}\_{\text{S}}}\pi(x\_{t^\prime})\iff p\_t\cdot x\_t\geq p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}\_{\text{S}}}\pi(x\_{t^\prime})\iff p\_t\cdot x\_t   > p\_t\cdot \pi(x\_{t^\prime})\mathrlap{.}$$

The choices can be rationalized by a symmetric and non-satiated utility function if and only if $(\mathop{\text{R}\_{\text{S}}},\mathop{\text{P}\_{\text{S}}})$ is acyclical (Chambers & Rehbeck, 2018). 

Using these symmetrically extended revealed preferences and their acyclicality, we can extend all the previous measures of rationality to rationalization by a symmetric utility. 

###  Afriat's Efficiency Index with Symmetric Utility

For a common adjustment factor $e\in[0,1]$, define the relaxed revealed preference $(\mathop{\text{R}^{e}\_{\text{S}}},\mathop{\text{P}^{e}\_{\text{S}}})$ by for all  $t, t^\prime$ and permutations $\pi$ as 

$$x\_{t}\mathrel{\text{R}^{e}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e)p\_t\cdot x\_t\geq p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}^{e}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e)p\_t\cdot x\_t   > p\_t\cdot \pi(x\_{t^\prime})\mathrlap{.}$$

Afriat's efficiency index with symmetric utility is 

$$\inf\_{e\in[0,1]}e\text{ such that }(\mathop{\text{R}^{e}\_{\text{S}}},\mathop{\text{P}^{e}\_{\text{S}}}) \text{ is acyclical.}$$

### Houtman-Maks Index with Symmetric Utility

Houtman-Maks index with symmetric utility is 

$$\inf\_{B\subseteq T}\frac{1}{T}|B|\text{ such that } (p\_i,x\_i)\_{i\in\\{1,\dotsc, T\\}\setminus B}\text{ is rationalizable with symmetric utility.}$$

### Swaps Index with Symmetric Utility

Swaps index with symmetric utility is $\inf\_{B\subseteq \mathop{\text{R}\_{\text{S}}}}\frac{1}{T}|B|$  such that by defining for all  $t, t^\prime$ with $(t,t^\prime)\notin B$ and permutations $\pi$ 

$$x\_{t}\mathrel{\text{R}^{B}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e)p\_t\cdot x\_t\geq p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}^{B}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e)p\_t\cdot x\_t   > p\_t\cdot \pi(x\_{t^\prime})$$

$(\mathop{\text{R}^{B}\_{\text{S}}},\mathop{\text{P}^{B}\_{\text{S}}})$ is acyclical. 

### Varian's Goodness-of-Fit of Degree $\alpha$ with Symmetric Utility

For observation specific adjustment factors $(e\_t)\in[0,1]^T$, define the relaxed revealed preference $(\mathop{\text{R}^{(e\_t)}\_{\text{S}}},\mathop{\text{P}^{(e\_t)}\_{\text{S}}})$  by for all  $t, t^\prime$ and permutations $\pi$ as  

$$x\_{t}\mathrel{\text{R}^{(e\_t)}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e\_t)p\_t\cdot x\_t\geq p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}^{(e\_t)}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e\_t)p\_t\cdot x\_t   > p\_t\cdot \pi(x\_{t^\prime})\mathrlap{.}$$

Varian's goodness-of-fit of degree $\alpha$ with symmetric utility for $\alpha>0$ is 

$$\inf\_{(e\_t)\in[0,1]^T}\frac{1}{T}\sum\_{t=1}^T e\_t^\alpha\text{ such that }(\mathop{\text{R}^{(e\_t)}\_{\text{S}}},\mathop{\text{P}^{(e\_t)}\_{\text{S}}}) \text{ is acyclical.}$$

Varian's goodness-of-fit of degree $0$ with symmetric utility is 

$$\inf_{(e_{t})\in[0,1]^T}\frac{1}{T}\bigg(|\\{t|e_{t}>0\\}| + \Big(\prod_{t|e_{t}>0} e_{t} \Big)^{\frac{1}{|\\{t|e_{t}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e\_t)}\_{\text{S}}} \text{ is acyclical.}$$

### Inverse Varian's Goodness-of-Fit of Degree $\alpha$ with Symmetric Utility

For observation specific adjustment factors $(e\_{t^\prime})\in[0,1]^T$, define the relaxed revealed preference $(\mathop{\text{R}^{(e\_{t^\prime})}\_{\text{S}}},\mathop{\text{P}^{(e\_{t^\prime})}\_{\text{S}}})$  by for all  $t, t^\prime$ and permutations $\pi$ as  

$$x\_{t}\mathrel{\text{R}^{(e\_{t^\prime})}\_{\text{S}}}\pi(x\_{t^\prime})\iff p\_t\cdot x\_t\geq (1-e\_{t^\prime})p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}^{(e\_{t^\prime})}\_{\text{S}}}\pi(x\_{t^\prime})\iff p\_t\cdot x\_t   > (1-e\_{t^\prime})p\_t\cdot \pi(x\_{t^\prime})\mathrlap{.}$$

Inverse Varian's goodness-of-fit of degree $\alpha$ with symmetric utility for $\alpha>0$ is 

$$\inf\_{(e\_{t^\prime})\in[0,1]^T}\frac{1}{T}\sum\_{t^\prime=1}^T e\_{t^\prime}^\alpha\text{ such that }(\mathop{\text{R}^{(e\_{t^\prime})}\_{\text{S}}},\mathop{\text{P}^{(e\_{t^\prime})}\_{\text{S}}}) \text{ is acyclical.}$$

Inverse Varian's goodness-of-fit of degree $0$ with symmetric utility is 

$$\inf_{(e_{t^\prime})\in[0,1]^T}\frac{1}{T}\bigg(|\\{t^\prime|e_{t^\prime}>0\\}| + \Big(\prod_{t^\prime|e_{t^\prime}>0} e_{t^\prime} \Big)^{\frac{1}{|\\{t^\prime|e_{t^\prime}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e_{t^\prime})}\_{\text{S}}} \text{ is acyclical.}$$

### Normalized Minimum Cost Index of Degree $\alpha$ with Symmetric Utility

For relation specific adjustment factors $(e\_{t,t^\prime})\in[0,1]^{T\times T}$, define the relaxed revealed preference $(\mathop{\text{R}^{(e\_{t,t^\prime})}\_{\text{S}}},\mathop{\text{P}^{(e\_{t,t^\prime})}\_{\text{S}}})$  by for all  $t, t^\prime$ and permutations $\pi$ as  

$$x\_{t}\mathrel{\text{R}^{(e\_{t,t^\prime})}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e\_{t,t^\prime})p\_t\cdot x\_t\geq p\_t\cdot \pi(x\_{t^\prime})\mathrlap{\text{ or } t=t^\prime}$$
$$x\_{t}\mathrel{\text{P}^{(e\_{t,t^\prime})}\_{\text{S}}}\pi(x\_{t^\prime})\iff (1-e\_{t,t^\prime})p\_t\cdot x\_t   > p\_t\cdot \pi(x\_{t^\prime})\mathrlap{.}$$

Normalized minimum cost index of degree $\alpha$ with symmetric utility for $\alpha>0$ is 

$$\inf\_{(e\_{t,t^\prime})\in[0,1]^{T\times T}}\frac{1}{T}\sum\_{t=1}^T\sum\_{t^\prime=1}^T e\_{t,t^\prime}^\alpha\text{ such that }(\mathop{\text{R}^{(e\_{t,t^\prime})}\_{\text{S}}},\mathop{\text{P}^{(e\_{t,t^\prime})}\_{\text{S}}}) \text{ is acyclical.}$$

Normalized minimum cost index of degree $0$ with symmetric utility is 

$$\inf_{(e_{t,t^\prime})\in[0,1]^T}\frac{1}{T}\bigg(|\\{(t,t^\prime)|e_{t,t^\prime}>0\\}| + \Big(\prod_{(t,t^\prime)|e_{t,t^\prime}>0} e_{t,t^\prime} \Big)^{\frac{1}{|\\{(t,t^\prime)|e_{t,t^\prime}>0\\}|}}\bigg)\text{ such that }\mathop{\text{P}^{(e_{t,t^\prime})}\_{\text{S}}} \text{ is acyclical.}$$

### Percentile Score

The percentile score adjusts the measure of rationality for its predictive success following Dean and Martin (2016) in order to make the measure comparable across different choice situations. Formally, for a number of goods $G$ and prices $p_t$ denote the income $w_t=p_t\cdot x_t$ and the budget line 

$$B(p_t,w_t)=\\{x\in \mathbb{R}_{+}^G| p_t \cdot x=w_t\\}.$$

For a measure of rationality $I$, the percentile score for the measure of rationality $I$ for data $\big((p_1,x_1),\dotsc,(p_T,x_T)\big)$ is

$$\\mathop{\text{Prob}}\big[I\big((p_1,x_1),..., (p_T,x_T)\big)>I\big((p_1,X_1),..., (p_T,X_T)\big)\big]\text{, where for each $t$, }X_t\sim\mathop{\text{Uni}}\big(B(p_t,p_t\cdot x_t)\big).$$

# Installation

1. Download the repository.

2. Open the main folder of the repository in Matlab.

3. Add the main folder and the subfolders to the Matlab path with the command

```
addpath(genpath('./'))
```


# Usage

The directory `Examples` offers minimal examples of the usage and an application to the experiment from Choi et al., 2014, "Who Is (More) Rational?", American Economic Review. 

## Rationality Measures

The function `rationality_measures` calculates **Afriat's index**, **Houtman-Maks index**, **Swaps index**, **Varian's goodness-of-fit of degree $\alpha$**, **inverse Varian's index of degree $\alpha$**, and **normalized minimum cost index of degree $\alpha$**  from prices and quantities. 

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
        values_vec(2): Houtman-Maks index
        values_vec(3): Swaps index
        For each power_vec(j):
          values_vec(3*j + 1): Varian's index of degree power_vec(j)
          values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j)
          values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j)

## Money Pump Index <a name="money-pump-index-usage"></a>

The function `money_pump_index` calculates **the average money pump index**, **normalized money pump index**, and **the number of cycles** from prices and quantities.\
The function `money_pump_index` is significantly slower than `rationality_measures` and it might not finish in a reasonable time if the choices contain a lot of choice cycles. 

    values_vec = money_pump_index(P, Q)
      Input:
        P: A matrix of prices where the rows index goods and the columns
          index time periods. The column vector at t gives the vector of
          prices that the consumer faced in the period t. 
        Q: A matrix of purchased quantities where the rows index
          goods and the columns index time periods. The column vector at t gives 
          the purchased bundle at the period t. 
        
      Output: 
        values_vec(1): Average money pump index
        values_vec(2): Normalized money pump index
        values_vec(3): Number of cycles  

## Rationality Measures Symmetric


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
        values_vec(2): Houtman-Maks index with symmetric utility
        values_vec(3): Swaps index with symmetric utility
        For each power_vec(j):
          values_vec(3*j + 1): Varian's index of degree power_vec(j) with symmetric utility
          values_vec(3*j + 2): Inverse Varian's index of degree power_vec(j) with symmetric utility
          values_vec(3*j + 3): Normalized minimum cost index of degree power_vec(j) with symmetric utility

## Percentile Score <a name="percentile-score-usage"></a>

The function `percentile_score` compares the measure of rationality from the data to the measure of rationality of choosing uniformly randomly on the budget line. This gives the probability that the data has a strictly or weakly higher measure of rationality than choosing randomly. This provides a predictive power adjustment for the measures of rationality following Dean and Martin (2016). 

    [prob_strictly_less_rational_than_random, prob_weakly_less_rational_than_random, prob_random_satisfies_garp] 
	= percentile_score(P, Q, power_vec, sample_size)    
      Input:
        P: A matrix of prices where the rows index goods and the columns
          index time periods. 
        Q: A matrix of purchased quantities where the rows index
          goods and the columns index time periods. 
        power_vec: A vector of power variations to calculate for Varian's index, 
          inverse Varian's index, and normalized minimum cost index. 
        sample_size: The number of draws from the budget line used to estimate the
          probabilities. 
     
      Output:
        prob_strictly_less_rational_than_random: For each measure of rationality, 
          the probability that the data has a strictly higher measure of rationality than 
          choosing uniformly on the budget line.
        prob_weakly_less_rational_than_random: For each measure of rationality, 
          the probability that the data has a strictly higher measure of rationality than 
          choosing uniformly on the budget line.   
        prob_random_satisfies_garp: The probability that uniform choices on the
          budget line satisfy GARP.
     
      The order of indices:
        1: Afriat's index
        2: Houtman-Maks index
        3: Swaps index
        For each degree in power_vec(j):
          3*j + 1: Varian's index of degree power_vec(j)
          3*j + 2: Inverse Varian's index of degree power_vec(j)
          3*j + 3: Normalized minimum cost index of degree power_vec(j)
		  
# References

Afriat, Sydney N. (1967). The construction of utility functions from expenditure data. *International economic review* 8(1), pp. 67–77.

Afriat, Sydney N. (1972). Efficiency estimation of production functions. *International economic review*, 13(3) pp. 568–598.

Apesteguia, Jose and Ballester, Miguel (2015). A measure of rationality and welfare. *Journal of Political Economy* 123(6), pp. 1278–1310.

Echenique, Federico; Lee, Sangmok, and Shum Matthew (2011) *The Money Pump as a Measure of Revealed Preference Violations*, 119(6), pp. 1201-1223.

Chambers, Christopher P. and Rehbeck, John (2018). Note on symmetric utility. *Economics Letters* 162, pp. 27-29.

Choi, Syngjoo; Kariv, Shachar; Müller, Wieland, and Silverman, Dan (2014). Who Is (More) Rational? *American Economic Review* 104(6), pp. 1518–50.

Dean, Mark and Martin, Daniel (2016). Measuring rationality with the minimum cost of revealed preference violations. *Review of Economics and Statistics* 98(3), pp. 524–534.

Houtman, Martijn and Maks, J. A. H. (1985). Determining All Maximal Data Subsets Consistent with Revealed Preference. *Kwantitatieve methoden* 19(1), pp. 89–104.

Mononen, Lasse (2022). The Foundations of Measuring (Cardinal) Rationality.

Mononen, Lasse (2023). Computing and Comparing Measures of Rationality.

Swofford, James L. and Whitney, Gerald A. (1987). Nonparametric Tests of Utility Maximization and Weak Separability for Consumption, Leisure and Money. *The Review of Economics and Statistics* 69(3), pp. 458–464.

Varian, Hal R. (1990). Goodness-of-fit in optimizing models. *Journal of Econometrics* 46(1),pp. 125–140.
