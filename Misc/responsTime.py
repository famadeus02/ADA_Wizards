# Short script to do a response time analysis for our system

from math import * 

Cs = 80.0 # sense
Ct = 0.03 # think
Ca = 10.0 # act

T = 150.0 # Period is the same for all tasks

W = Ct # W0 
Wn = W

R = 0
tries = 0

# # First iteration
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

print("Worst case response time for Think: ", R)
print("Iterations", tries)

tries = 0
W = Ca
# Second iteration
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


print("Worst case R for Act is: ", R)
print("Iterations", tries)