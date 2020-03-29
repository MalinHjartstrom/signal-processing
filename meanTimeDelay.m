
%The pulses need to be marked by getrect() in the correct order starting from the far left.
nbrOfPulses = 4;
timePoints = zeros(1, nbrOfPulses);
for count = 1: nbrOfPulses
    timePoints(1, count) = testscript_basic();
end
firstPulse = timePoints(1,1);
allButFirstPulse = diff(timePoints);
pulseTimes = cat(2,firstPulse,allButFirstPulse)
meanTimeDelayOfPulses = mean(pulseTimes)