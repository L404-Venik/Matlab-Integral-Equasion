function K = K_tilda(x,t) 
d = 1/10 * 3;
K = 2*exp(x-t) + 3 * exp(3*(x-t)) + d * sin(10*pi*x);