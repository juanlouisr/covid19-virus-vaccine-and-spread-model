# covid19-virus-vaccine-and-spread-model
Covid 19 virus: vaccine and spread model netlogo

## Try it on NetLogo web

https://www.netlogoweb.org/launch#https://raw.githubusercontent.com/mizuday/covid19-virus-vaccine-and-spread-model/main/model.nlogo


## WHAT IS IT?

COVID-19 Virus Spread and Vaccination is an Agent-Based-Model built from the skeleton of an SIR model developed by Paul Smaldino currently (2020) at the Cognitive and Information Sciences Department at the University of California, Merced; and was further developed by Nich Martin at the University of Florida, Department of Entomology and Nematology as a tool to help educate the public on how interaction models concerning the current COVID-19 pandemic are used to make predictions and recommendations to the public. 

## HOW IT WORKS

An initial population of agents (green-colored humanoids) are randomly placed in the model space with an initial population of infected individuals (red). As time moves forward, agents move randomly through the model space according to specified parameters such as number of stationary individuals and mobility. Infected individuals transmit the virus to susceptible individuals by coming within a certain distance of each other. Whether the susceptible individual becomes infected is determined by a random probability, the likelihood of which increases as transmission rate increases. The model can be run with and without vaccinated individuals; when ran with immunity, infected individuals will become vaccinated (color changes to blue) according to a random probability, the liklihood of which increases with increasing recovery rate. Mortality rate can be adjusted. The ability of hospitals to cope with the proportion of infected individuals can be adjusted as well. Once the proportion of infected individuals is greater than _health care capacity_ mortality increases an order of magnitude, as predicted by other current models. 

## HOW TO USE IT

After adjusting the parameters, described below, simply click the _setup_ button and click _go_. The model will continue to run until there are either no more infected individuals or no more susceptible individuals.

### Initial Population

Control population size by adjusting the _init-population_ slider.

### Initial Number of Infected Individuals

Controls initial number of infected using the _init-infected_ slider.

### Transmission Rate

Current estimates are between 0.50 and 0.70. Set transmission rate by moving the _transmission-rate_ slider.

### Number of Stationary Individuals

The _stationary_ slider allows the user to control the number of individals not moving (represents physical/social distancing) in the model space.

### Mobility

The _mobility_ slider allows the user to set how much distance non-stationary individuals move throughout the model space.

### Recovery Rate

Set the _recovery-rate_ slider low for longer recovery time and high for quick recovery. Suggested recovery rate for the current virus is 15%.

### Initial Number of vaccinated Individuals

Use the _init-vaccinated_ slider to adjust the number of individuals vaccinated to the virus before the model runs.

### Quarantine Effort

By adjusting the _quarantine-effort_ slider, users can control infected individuals' ability to infect susceptibles.

### Vaccination Rate

Set the _vaccination-rate_ slider low for slower vaccine distribution and high for quick vaccine distribution. Suggested vaccination rate for the current virus is 5%.

### Health Care Capacity

The _healthcare-capacity_ slider changes the proportion of infected individuals hospitals can provide care for. Once the proportion of infected individuals exceeds health care capacity (which I'm told should realistically be set at least below 0.30) mortality rate increases one order of magnitude from where it was initially set.

### Mortality Rate

The _infected-mortality_ slider changes the base-line mortality rate for those infected. Estimates for mortality rate range from 1 to 10%, averaging around 3.6 when not accounting for health care capacity.


## THINGS TO NOTICE

You can watch the model space and individuals moving throughout it to see how disease spreads throughout a population.

The model has two plot outputs. The first shows the number of susceptible, infected, and vaccinated individuals through time. This same figure also shows a line for health care capacity. 

The plot below the first shows the total number of individuals who have died as the model moves through time. 

There are also a number of indicator values including the maximum propotion of individuals infected, the proportion uninfected, the number of people who have died, and the current population size. 


## THINGS TO TRY

Try adjusting the _init-population_ slider to see how more sparse, rural areas are affected vs. densely populated cities.

Adjust the _stationary_ slider to see how many people "social distancing" it takes to "flatten the curve".

Adjust the _init-vaccinated_ slider to see what outcomes would look like if a vaccine was available, and how many individuals getting vaccinated it would take to see the effects of "herd immunity".

By adjusting the _quarantine-effort_ you can see what the effects of isolating individuals already infected has on the dynamics of the system. 

## EXTENDING THE MODEL

If you have any suggestions for things to add or change in the model feel free to contact me at 13519075@std.stei.itb.ac.id. I (Juan Louis Rombetasik) am not an epidemiologist, so if there are epidemiologists out there who feel the model needs drastic improvement, please contact me. But please also bear in mind, this was developed as an educational tool so changes will likely only be made if they serve an educational benefit. Netlogo users are encouraged to adjust the code as they see fit; I would be delighted if you send me your updates; I am new to agent-based modeling and would like useful feedback.

## RELATED MODELS

This model is based off an initial model by Paul Smaldino
"SIR Model with random movement"
http://smaldino.com/wp/


## Author

- [Juan Louis R](https://github.com/mizuday/)

- [Aria Berlian](https://github.com/ariaberlian/)


## CREDITS AND REFERENCES

CREATIVE COMMONS LICENSE
This code is distributed by Juan Louis Rombetasik under a Creative Commons License:

Shield: [![CC BY-SA 4.0][cc-by-sa-shield]][cc-by-sa]

This work is licensed under a
[Creative Commons Attribution-ShareAlike 4.0 International License][cc-by-sa].

[![CC BY-SA 4.0][cc-by-sa-image]][cc-by-sa]

[cc-by-sa]: http://creativecommons.org/licenses/by-sa/4.0/
[cc-by-sa-image]: https://licensebuttons.net/l/by-sa/4.0/88x31.png
[cc-by-sa-shield]: https://img.shields.io/badge/License-CC%20BY--SA%204.0-lightgrey.svg