%%
clear

close all

d = 3e-3; %material thickness

myRequestedlength = 2000;

for i = 1 : 32
    %load(['c:\Users\per\Dropbox (Personal)\Research_BME\AcouPlast\Material properties\Measurements\' ...
        %'OscilloscopeTest\20200227_steel_long\20200228-0001\' ...
        %'20200228-0001_' ...
        %num2str(i,'%02.f') '.mat'])
        
    load(['C:\Users\Malin\Dcouments\Forskningsassistent LTH\Signalbehandling\20200228-0001\20200228-0001_01'
        num2str(i,'%02.f') '.mat'])
    As(:,i) = A(1:myRequestedlength); %trim data
end

%overwrite lenght of data
RequestedLength = myRequestedlength;

tsampled = linspace(0,(RequestedLength-1)*Tinterval*1e6,RequestedLength); %time in ?s
t = linspace(0,(RequestedLength-1)*Tinterval*1e6,RequestedLength); %time in ?s


figure
% subplot(3,1,1)
plot(tsampled,As)


hold on

Amean = mean(As,2);
Amean = interp1(tsampled,Amean,t,'spline');
plot(t,Amean,'linewidth',2)
drawnow

pulseRect = getrect();
t0 = pulseRect(1);
t1 = pulseRect(1) + pulseRect(3);

%cursors over first pulse
line([t0 t0],[-0.15 0.15])
line([t1 t1],[-0.15 0.15])

fltPulse = t > t0 & t < t1;



if mod(sum(fltPulse),2) == 1 %if pulse length is odd
    pulse = Amean(fltPulse);
else
    pulse = Amean(fltPulse);
    pulse = pulse(1:end-1);
end


tcorr = linspace(t1,(RequestedLength-1)*Tinterval*1e6,(RequestedLength+sum(fltPulse)-1)); %time in ?s


crr = normxcorr2(pulse,Amean);
xlabel('time (?s)')

figure
% subplot(3,1,2)
absc = abs(crr); %take absolute 
plot(tcorr,absc)
title('normxcorr')

%%
hold on
[pks_2, locs_2] = findpeaks(absc,'MinPeakDistance',200,'NPeaks',2,'MinPeakHeight',0.5);
plot(tcorr(locs_2),pks_2,'x')
pkDist = diff(locs_2);
[pks, locs] = findpeaks(absc,'MinPeakDistance',pkDist-5,'MinPeakHeight',0.5);
plot(tcorr(locs),pks,'o')
axis([t(1)-0.1 t(end)+0.1 0 1])
xlabel('time (?s)')

figure
% subplot(3,1,3)
plot(diff(tcorr(locs)))
title('Pulse echo time')
xlabel('Eco number')
ylabel('time (?s)')

echoTime = mean(diff(tcorr(locs)))
CV = std(diff(tcorr(locs)))/mean(diff(tcorr(locs)))*100

c = d*2/echoTime*1e6


% 
% figure
% subplot(2,1,1)
% env = envelope(Amean);
% plot(env)
% title('envelope')
% [pks, locs] = findpeaks(env,'MinPeakDistance',200);
% hold on
% plot(locs,pks,'o')
% 
% subplot(2,1,2)
% plot(diff(locs))
% 
% hold on
% line([1 9],[mean(diff(locs)) mean(diff(locs))],'color','k','linestyle','--')

% pW = 227;
% 
% pulse_norm = normalize(abs(Amean(1 : pW)));
% 
% c = nan(length(Amean) - pW,1);
% for i = 1 : length(Amean) - pW
%     win_norm = normalize(abs(Amean(i : i + pW - 1)));
%     c(i) = sum(pulse_norm.*win_norm)/sum(pulse_norm.*pulse_norm);
% end
% 
% figure
% plot(c)






%%

function normVec = normalize(vector)
vMin = min(vector);
vMax = max(vector);
vAmp = vMax - vMin;
normVec = (vector - vMin) / vAmp;
end

