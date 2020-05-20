
clear
close all

% definiera en x-vektor med ett f�tal sampe
t = linspace(0,4*pi,10);
% utv�rdera funktionen sin(t) vid dessa sampeltillf�llen
y = sin(t);

%plotta
figure
plot(t,y,'x')

% Interpolera datan och tidsaxeln med 10 g�ngers h�gre sampling
yi = interp(y,10);
ti = interp(t,10);

% Plotta 
hold on
plot(ti,yi,'.')

% F�r j�mf�relse, plotta den verkliga underliggande funktionen utv�rderad i
% 1000 punkter
tteor = linspace(0,4*pi,1000);
plot(tteor,sin(tteor))
