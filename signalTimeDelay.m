function echoTime = signalTimeDelay(signal, Amean, t, RequestedLength)
%Plottar signal mot tiden
figure
plot(t,signal,'linewidth',2)
drawnow

pulseRect = getrect(); %Specify rectangle with mouse
t0 = pulseRect(1);
t1 = pulseRect(1) + pulseRect(3);

%cursors over first pulse
line([t0 t0],[-0.15 0.15])
line([t1 t1],[-0.15 0.15])

fltPulse = t > t0 & t < t1; %vektor med 1 f?r den tid som ?r mellan t0 och t1, annars 0
%fltPulse

pulse = Amean(fltPulse);

Tinterval = 1.599999954748910e-08; %obs taget v?rde

tcorr = linspace(t1,(RequestedLength-1)*Tinterval*1e6,(RequestedLength+sum(fltPulse)-1)); %time in us?
crr = normxcorr2(pulse,Amean); %Normalized 2-D cross-correlation, matrix crr contains the correlation coefficients

figure
absc = abs(crr); %take absolute 
plot(tcorr,absc)
title('Normalised cross correlation')
xlabel('time (us)')

hold on
[pks_2, locs_2] = findpeaks(absc,'MinPeakDistance',200,'NPeaks',2,'MinPeakHeight',0.5);
plot(tcorr(locs_2),pks_2,'x')
pkDist = diff(locs_2); %calculates differences between adjacent elements of X along the first array dimension whose size does not equal 1
[pks, locs] = findpeaks(absc,'MinPeakDistance',pkDist-5,'MinPeakHeight',0.5);

%pks
%locs
%tcorr(locs)

% plot(tcorr(locs),pks,'o')
% axis([t(1)-0.1 t(end)+0.1 0 1])
% xlabel('time (us)')

% figure
% plot(diff(tcorr(locs)))
% title('Pulse echo time')
% xlabel('Eco number')
% ylabel('time (us)')

echoTime = mean(diff(tcorr(locs)));
end