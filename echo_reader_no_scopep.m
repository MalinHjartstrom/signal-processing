%%
clear
close all



d = 1.88e-3; %material thickness in meters

%Eko fr?n ultraljud i ett materal
    %A is the signal
    %Timeinterval is the time between samples in seconds
    %Requested length is the number of samples





%myRequestedlength = 2000;

folder = uigetdir(... 
    'c:\Users\per\Lund University\Experimental acoustofluidics group - AcouPlast - AcouPlast\Material properties\Measurements\20200626_DTU_polymers\' ...
    );
files = dir(folder);


%For steel:
% myRequestedlength = 6250;
% myFolder = 'C:\Users\Malin\Documents\Forskningsassistent LTH\Signalbehandling\signal-processing\20200303-0001_'; %Working folder
%myFolder = 'C:\Users\Malin\Documents\Forskningsassistent LTH\Signalbehandling\signal-processing\20200228-0001_'; %Working folder

%For polymer:
%myRequestedlength = 2500;
%myFolder = 'C:\Users\Malin\Documents\Forskningsassistent LTH\Signalbehandling\sp\polymerdata\20191210-0001\20191210-0001_'; %Working folder

%Signal generated in PicoScope:
%myFolder = 'C:\Users\Malin\Documents\Forskningsassistent LTH\Signalbehandling\20200603-0001\20200603-0001_'; %Working folder


for i = 1 : 32
    load([folder '\' files(i+2).name],'A','Length','Tstart','Tinterval');
    As(:,i) = A;
end


%overwrite lenght of data
% RequestedLength = myRequestedlength;

% tsampled = linspace(0,(RequestedLength-1)*Tinterval*1e6,RequestedLength); %time in us
t = linspace(0,(Length-1)*Tinterval*1e6,Length); %time in us


%% Call interPeakTime function

% interpolationRate = 100; %Interpolation rate
% lengthOfSignal = 500; %Choosen length of signal
% tinterval = timeIntervalNanoseconds / 1000; %tinterval in micro seconds



%Print time between consecutive peaks
% times



%% Analyse a signal




%L?gg ev in n som argument och l?gg funktionen 'interPeakTime' i functionen
%'measure'
% n = 4;
% for i = 1 : n
%     As(:,i) = signal(1:myRequestedlength); %trim data
% end

tsampled = linspace(0,(Length-1)*Tinterval*1e6,Length); %time in us
t = linspace(0,(Length-1)*Tinterval*1e6,Length); %time in us


%Plottar alla signaler mot den samlade tiden
figure
plot(tsampled,As)
title('All signals')
xlabel('time (us)')

%% Mark in figure
Amean = mean(As,2); %column vector containing the mean of each row
Aabs = abs(Amean);

figure
plot(t,Aabs,'linewidth',2)
title('Mean of all signals: Mark two peaks')
xlabel('time (us)')
axis([0 max(t) min(Aabs) max(Aabs)+0.01])
annotation('textbox', [0.55, 0.65, 0.3, 0.2], 'String', "Please mark the first interesting peak with a rectangle. Then mark the second relevant peak that is closest to it.")

%Markera den minsta (men fortfarande intressanta) peaken f?r att best?mma
%'MinPeakHeight', samt peaken brevid f?r att best?mma minsta avst?nd mellan
%peaks
rect1 = getrect;
flt1 = t>rect1(1) & t < rect1(1) + rect1(3);
[peak1, t1] = findpeaks(Aabs(flt1),t(flt1),'NPeaks',1);

rect2 = getrect;
flt2 = t>rect2(1) & t < rect2(1) + rect2(3);
[peak2, t2] = findpeaks(Aabs(flt2),t(flt2),'NPeaks',1);

flt = t>=t1; % filter for excluding times before first peak 

% [xx, y] = findpeaks;
% mph = y;
% peak1 = xx;
% [xx2,~] = ginput(1);
% peak2 = xx2;
delta_t1 = (t2-t1);
mph = peak1*0;


%% Interpolation
%Interpolerar till interpolationRate ggr h?gre samplingshastighet
interpolationRate = 1;
Aabsi = interp(Aabs,interpolationRate);
ti = interp(t,interpolationRate);

%% Time between consecutive peaks
%Plottar interpolerade abs(Amean) mot interpolerad tid
figure
plot(ti,Aabsi,'linewidth',2)
title('Mean of all signals with peaks, interpolated')
xlabel('time (us)')
axis([0 max(ti) min(Aabsi) max(Aabsi)+0.01])
hold on
% 
% [pks_2, locs_2] = findpeaks(Aabsi,ti,'MinPeakDistance',minDist,'NPeaks',2,'MinPeakHeight',mph);
% plot(locs_2,pks_2,'x')
% diff((locs_2)); %963 samples in original sampling rate

[pksAll, tAll] = findpeaks(Aabsi(flt),ti(flt),'MinPeakHeight',mph,'MinPeakDistance',0.1);

pks = [peak1;peak2];
times = [t1,t2];

for i = 1:9
    flt = tAll > times(end) + delta_t1 * 0.95 & tAll < times(end) + delta_t1 * 1.05; %filter out the next relevant peak
    if numel(tAll(flt)) == 1
        times = [times, tAll(flt)];
        pks = [pks;pksAll(flt)];
    else
        disp('Dual peak found. Confused.')
        return
    end
end
        



    
    
    
    
% [pks, locs] = findpeaks(Aabsi(flt),ti(flt),'MinPeakDistance',minDist,'MinPeakHeight',mph);
% pks = [peak1;pks]; %add the peak 1 that was idientiied by the user
% locs = [t1, locs];
plot(times,pks,'o')
format long g
% sample_differences = diff(locs)
time_between_peaks = diff(times)'

%% Plotting the mean of the original signal and the (now approximated) peaks
%Plottar peaks mot originalplot
%OBS beh?ver avrunda peaksen till heltal f?r att kunna plotta tillsammans
%med originalsignalen

% roundedPeaks = round(locs/interpolationRate);

% figure
% plot(t,Aabs,'linewidth',2)
% title('Mean of abs(signal) together with approximated peaks')
% xlabel('time (us)')
% axis([0 max(t) min(Aabs) max(Aabs)+0.01])
% hold on
% 
% plot(t(roundedPeaks),pks, 'ro')
% legend({'Mean of abs(signal)', 'Approximated peaks'})

d %material thickness
c_avg = mean(2*d./time_between_peaks*1e6)
c_std = std(2*d./time_between_peaks*1e6)
c_cv = c_std/c_avg*100


figure(4)
plot(time_between_peaks)
hold on