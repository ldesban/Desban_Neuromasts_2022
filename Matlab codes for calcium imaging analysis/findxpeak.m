function [x, ES] = findxpeak(dff, onset, fr)

Nsweep = size(dff,2);
x = nan(1,Nsweep);% vector of x position of activation peak for each stim
ES = nan(1, Nsweep); %vector of effect size for each stim

for s = 1:Nsweep
    if onset > 5*fr
        peak = max([dff(onset*fr:(onset+10)*fr,s)]);
        x(1,s) = find([dff(onset*fr:(onset+10)*fr,s)] == peak) + onset*fr - 1;
        ES(1,s) = nanmean(dff(x(1,s)-2:x(1,s)+2,s),1)-nanmean(dff(onset*fr-5:onset*fr,s),1);
    else
        peak = max([dff(onset*fr:(onset+10)*fr,s)]);
        x(1,s) = find([dff(onset*fr:(onset+10)*fr,s)] == peak) + onset*fr - 1;
        ES(1,s) = nanmean(dff(x(1,s)-2:x(1,s)+2,s),1)-nanmean(dff(1:onset*fr,s),1);
    end
end