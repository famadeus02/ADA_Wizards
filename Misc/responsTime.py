# Short script to do a response time analysis for our system

from math import *

Cs = 80 # sense
Ct = 0.03 # think
Ca = 10.0 # act

T = 120 # Period is the same for all tasks


R = 0
tries = 0

# # First iteration
W = Ct # W0
Wn = W
while True:
    Wn = Ct + (ceil(W/T) * Cs)
    tries += 1
    if Wn == W:
        R = Wn
        break
    else:
        W = Wn
    if Wn > T:
        print("Value not found")

print("Worst case response time for Think: ", R, ", Iterations: ", tries)


# Second iteration
tries = 0
W = Ca
while True:
    Wn = Ca + (ceil(W/T) * Cs) + (ceil(W/T) * Ct)
    tries += 1
    if Wn == W:
        R = Wn
        break
    elif Wn != W:
        W = Wn
    if Wn > T:
        print("Value not found")

print("Worst case response time for Act is: ", R, ", Iterations: ", tries)
