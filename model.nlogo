;;SIR Model with random movement
;;Agents move around at random.
;;They are either Susceptible, Infected, or Recovered (or, equivalently, removed)



globals [max-infected]

turtles-own [
  infected?
  vaccinated?
  stationary?
]

to setup
  clear-all
  setup-turtles
  setup-infected
  setup-stationary
  setup-vaccine
  set max-infected (count turtles with [infected?])
  reset-ticks
end

to setup-turtles
  create-turtles init-population
  [
    set color green
    set shape "person"
    set size 2
    set infected? false
    set vaccinated? false
    set stationary? false
    setxy random-pxcor random-pycor
  ]
end

to setup-infected
  ask n-of init-infected turtles
  [
   set color red
   set infected? true
  ]
end

to setup-stationary
  ask n-of stationary turtles
  [
    set stationary? true
  ]
end

to setup-vaccine
  ask n-of init-vaccinated turtles
  [
    set vaccinated? true
    set color blue
  ]
end

to step
  ;;stop if everyone or noone is infected
  if (count turtles with [infected?] = 0)
  or (count turtles with [infected?] = init-population)
  [
    stop
  ]

  infect-susceptibles
  kill-susceptibles
  vaccine-susceptibles
  recover-infected
  recolor
  move
  calculate-max-infected
  tick
end

to vaccine-susceptibles
  ask turtles with [not infected? and not vaccinated?]
  [
    if random-float 100 < vaccination-rate
    [
      set vaccinated? true
      set color blue
    ]
  ]
end

to infect-susceptibles ;; S -> I
  ask turtles
  [
    let infected-neighbors (count other turtles with [color = red] in-radius 1 * (100 - quarantine-effort) / 100)
    if (random-float 1 <  1 - ((((100 - transmission-rate) / 100) ^ infected-neighbors)) and not vaccinated?)
    [set infected? true]
  ]
end

to recolor
  ask turtles with [infected?]
  [
    set color red
  ]
end

to move
  ask turtles with [not stationary?]
  [
    right random 360 ;;get a new random heading
    forward random-normal mobility 0.01
  ]
end

to recover-infected ;;I -> R
  ask turtles with [infected?]
  [
    if random-float 100 < recovery-rate
    [
      set infected? false
      set color green
    ]
  ]
end

to-report prop-infected
  report (count turtles with [infected?] / count turtles)
end

to kill-susceptibles
  ask turtles with [infected?]
  [
    ifelse prop-infected * 100 < healthcare-capacity
    [
      if (random-float 1000 < (infected-mortality))
      [
        die
      ]
    ][
      if (random-float 1000 < (10 * infected-mortality))
      [
        die
      ]
    ]
  ]
end

to-report num-dead
  report (init-population - count turtles)
end

to-report population
  report (count turtles)
end

to calculate-max-infected
  let x (count turtles with [infected?])
  if x > max-infected
  [set max-infected x]
end

to-report max-infected-prop
  report max-infected / init-population
end

to-report prop-uninfected
  report (count turtles with [not infected? and not vaccinated?]) / init-population
end
@#$#@#$#@
GRAPHICS-WINDOW
358
102
985
730
-1
-1
12.14
1
10
1
1
1
0
1
1
1
-25
25
-25
25
1
1
1
ticks
30.0

BUTTON
47
22
167
88
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
48
174
168
236
go
step
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
22
263
195
296
init-population
init-population
1
1000
1000.0
1
1
NIL
HORIZONTAL

SLIDER
21
301
194
334
init-infected
init-infected
1
20
20.0
1
1
NIL
HORIZONTAL

SLIDER
22
340
209
373
transmission-rate
transmission-rate
1
100
82.0
1
1
%
HORIZONTAL

SLIDER
22
416
195
449
mobility
mobility
0
10
1.0
.1
1
NIL
HORIZONTAL

PLOT
1097
203
1473
522
infection
time
proportion infected
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"infected" 1.0 0 -2674135 true "" "plot (count turtles with [infected?]) / init-population"
"susceptible" 1.0 0 -16777216 true "" "plot (count turtles with [not infected? and not vaccinated?]) / init-population"
"vaccinated" 1.0 0 -13345367 true "" "plot (count turtles with [vaccinated?]) / init-population"
"health care capacity" 1.0 0 -955883 true "" "plot healthcare-capacity / 100"

SLIDER
22
453
194
486
recovery-rate
recovery-rate
1
100
10.0
1
1
%
HORIZONTAL

MONITOR
1483
204
1617
249
NIL
max-infected-prop
5
1
11

MONITOR
1483
253
1617
298
NIL
prop-uninfected
17
1
11

SLIDER
22
378
194
411
stationary
stationary
0
1000
631.0
1
1
NIL
HORIZONTAL

SLIDER
22
493
194
526
init-vaccinated
init-vaccinated
0
1000
0.0
1
1
NIL
HORIZONTAL

SLIDER
21
533
209
566
quarantine-effort
quarantine-effort
1
100
1.0
1
1
%
HORIZONTAL

SLIDER
12
696
216
729
healthcare-capacity
healthcare-capacity
0
100
30.0
1
1
%
HORIZONTAL

SLIDER
13
733
205
766
infected-mortality
infected-mortality
0
10
3.6
0.1
1
%
HORIZONTAL

MONITOR
1483
305
1552
350
NIL
num-dead
17
1
11

MONITOR
1557
305
1628
350
NIL
population
17
1
11

PLOT
1096
526
1474
676
number died
time
number died
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot num-dead"

BUTTON
49
100
168
160
NIL
step
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
21
573
198
606
vaccination-rate
vaccination-rate
0
100
5.0
1
1
%
HORIZONTAL

@#$#@#$#@
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


## CREDITS AND REFERENCES

CREATIVE COMMONS LICENSE
This code is distributed by Juan Louis Rombetasik under a Creative Commons License:
Attribution-ShareAlike 4.0 International (CC 4.0)
https://creativecommons.org/licenses/by/4.0/
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.2
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="experiment-122" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="9999"/>
    <metric>ticks</metric>
    <enumeratedValueSet variable="num-turtles">
      <value value="200"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="transmissibility">
      <value value="0.1"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turning-angle">
      <value value="10"/>
      <value value="180"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="remove-recovered?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="HW7-1" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <steppedValueSet variable="num-turtles" first="50" step="50" last="500"/>
    <enumeratedValueSet variable="transmissibility">
      <value value="0.1"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery-rate">
      <value value="0"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-infected">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turning-angle">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="remove-recovered?">
      <value value="false"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="HW7-2" repetitions="10" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <steppedValueSet variable="num-turtles" first="50" step="50" last="500"/>
    <enumeratedValueSet variable="transmissibility">
      <value value="0.1"/>
      <value value="0.9"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery-rate">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="speed">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="turning-angle">
      <value value="60"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="remove-recovered?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment-covid" repetitions="30" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100000"/>
    <metric>max-infected-prop</metric>
    <metric>prop-uninfected</metric>
    <enumeratedValueSet variable="num-turtles">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="transmissibility">
      <value value="0.3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="recovery-rate">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="init-infected">
      <value value="3"/>
    </enumeratedValueSet>
    <steppedValueSet variable="speed" first="0.25" step="0.25" last="10"/>
    <enumeratedValueSet variable="remove-recovered?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
