function result = K_tilda(x,t) 
%d = 1/10 * max(abs(K(x, t)));
d = 1/10 * 3;
result = 2*exp(x-t) + exp(3*(x-t)) + d * sin(13*pi*x);