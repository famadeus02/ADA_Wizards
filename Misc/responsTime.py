# Short script to do a response time analysis for our system

from math import *

Cs = 80 # sense
Ct = 0.03 # think
Ca = 10.0 # act

T = 50.0 # Period is the same for all tasks
# Testing periods
# Ts = 45.0
# Tt = 60.0
# Ta = 60.0


R = 0
tries = 0

# # First iteration
W = Ct # W0
Wn = W
while True:
    Wn = Ct + (ceil(W/Ts) * Cs)
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
    Wn = Ca + (ceil(W/Ts) * Cs) + (ceil(W/Tt) * Ct)
    tries += 1
    if Wn == W:
        R = Wn
        break
    elif Wn != W:
        W = Wn
    if Wn > T:
        print("Value not found")

print("Worst case response time for Act is: ", R, ", Iterations: ", tries)
