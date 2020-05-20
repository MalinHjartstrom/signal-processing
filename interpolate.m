
clear
close all

% definiera en x-vektor med ett fåtal sampe
t = linspace(0,4*pi,10);
% utvärdera funktionen sin(t) vid dessa sampeltillfällen
y = sin(t);

%plotta
figure
plot(t,y,'x')

% Interpolera datan och tidsaxeln med 10 gångers högre sampling
yi = interp(y,10);
ti = interp(t,10);

% Plotta 
hold on
plot(ti,yi,'.')

% För jämförelse, plotta den verkliga underliggande funktionen utvärderad i
% 1000 punkter
tteor = linspace(0,4*pi,1000);
plot(tteor,sin(tteor))
