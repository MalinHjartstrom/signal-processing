%%
clear

close all

%Eko fr?n ultraljud i ett materal
    %A is the signal
    %Timeinterval is the time between samples in seconds
    %Requested length is the number of samples

%Material thickness assumed to be 1 inch
d = 0.0254; %material thickness in meters

myRequestedlength = 2000;

myFolder = 'C:\Users\Malin\Documents\Forskningsassistent LTH\Signalbehandling\signal-processing\20200228-0001_'; %Working folder

for i = 1 : 32
    load([myFolder, num2str(i,'%02.f'), '.mat']);
    As(:,i) = A(1:myRequestedlength); %trim data
end

%overwrite lenght of data
RequestedLength = myRequestedlength;

tsampled = linspace(0,(RequestedLength-1)*Tinterval*1e6,RequestedLength); %time in us
t = linspace(0,(RequestedLength-1)*Tinterval*1e6,RequestedLength); %time in us

%Plot all signals against the sampled time
figure
% subplot(3,1,1)
plot(tsampled,As)
title('All signals')
xlabel('time (us)')

hold on

Amean = mean(As,2); %column vector containing the mean of each row
Amean = interp1(tsampled,Amean,t,'spline'); %returns the piecewise polynomial form of Amean(tsampled) using the t algorithm

%%%%%%%%%%%%%%%%%%%%%%%%%<MALIN>%%%%%%%%%%%%%%%%%%%%%%%%%%%
nbrOfSignals = 1;
nbrOfPulses = 4;
echoTimeDelays = zeros(nbrOfSignals,nbrOfPulses);
for i = 1:nbrOfSignals
    signal = As(:,i);
    for j = 1:nbrOfPulses
        echoTime = signalTimeDelay(signal, Amean, t, RequestedLength);
        echoTimeDelays(i, j) = echoTime;
    end
end
echoTimeDelays
%%%%%%%%%%%%%%%%%%%%%%%%%</MALIN>%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Plot Amean against time
plot(t,Amean,'linewidth',2)
drawnow

pulseRect = getrect(); %Specify rectangle with mouse
t0 = pulseRect(1);
t1 = pulseRect(1) + pulseRect(3);

%cursors over first pulse
line([t0 t0],[-0.15 0.15])
line([t1 t1],[-0.15 0.15])

fltPulse = t > t0 & t < t1;

pulse = Amean(fltPulse);

%Varf?r g?r vi det h?r?
%Om pulsl?ngden ?r j?mn blir 'pulse' f?r kort och vi f?r ingen plot.
% if mod(sum(fltPulse),2) == 1 %if pulse length is odd
%     pulse = Amean(fltPulse);
%     "pulse length is odd"
% else
%     pulse = Amean(fltPulse);
%     pulse = pulse(1:end-1);%Shortening the pulse length with one if even
%     "pulse length is even"
% end


tcorr = linspace(t1,(RequestedLength-1)*Tinterval*1e6,(RequestedLength+sum(fltPulse)-1)); %time in us?
crr = normxcorr2(pulse,Amean);

figure
% subplot(3,1,2)
absc = abs(crr); %take absolute 
plot(tcorr,absc)
title('normxcorr')
xlabel('time (us)')

%%
hold on
[pks_2, locs_2] = findpeaks(absc,'MinPeakDistance',200,'NPeaks',2,'MinPeakHeight',0.5);
plot(tcorr(locs_2),pks_2,'x')
pkDist = diff(locs_2);
[pks, locs] = findpeaks(absc,'MinPeakDistance',pkDist-5,'MinPeakHeight',0.5);
plot(tcorr(locs),pks,'o')
axis([t(1)-0.1 t(end)+0.1 0 1])
xlabel('time (us)')

figure
% subplot(3,1,3)
plot(diff(tcorr(locs)))
title('Pulse echo time')
xlabel('Eco number')
ylabel('time (us)')


echoTime = mean(diff(tcorr(locs)))

%Coefficient of variation
CV = std(diff(tcorr(locs)))/echoTime*100 %in percentage

%Velocity (m/s)
c = d*2/echoTime*1e6 %time in s


% 
% figure
% subplot(2,1,1)
% env = envelope(Amean); 
% plot(env)
% title('Envelope')
% xlabel('time (us)')
% [pks, locs] = findpeaks(env,'MinPeakDistance',200);
% hold on
% plot(locs,pks,'o')
% 
% subplot(2,1,2)
% plot(diff(locs))
% title('Pulse echo time')
% xlabel('Eco number')
% ylabel('time (us)')
% % 
% 
% hold on
% line([1 9],[mean(diff(locs)) mean(diff(locs))],'color','k','linestyle','--')
% 
% pW = 227;
% % 
% pulse_norm = normalize(abs(Amean(1 : pW))); 

%  c = nan(length(Amean) - pW,1);
%  for i = 1 : length(Amean) - pW
%      win_norm = normalize(abs(Amean(i : i + pW - 1)));
%      c(i) = sum(pulse_norm.*win_norm)/sum(pulse_norm.*pulse_norm);
%  end
% % 
% figure
% plot(c)






%%

function normVec = normalize(vector)
vMin = min(vector);
vMax = max(vector);
vAmp = vMax - vMin;
normVec = (vector - vMin) / vAmp;
end

