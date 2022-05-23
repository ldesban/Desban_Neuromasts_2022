function [dataset_R, dataset_NR, traces_R, traces_NR, Perc_R] = getRespCells_Trial1_single(dataset, SweepDur, thr)

dataset_R = []; % responding
dataset_NR = []; % non-responding
n = 0;
nr = 0;
traces_R = NaN(size(dataset,2),350);
traces_NR = NaN(size(dataset,2),350);

%% 1. classify responding (in dataset_R) versus non-responding (in dataset_NR)

figure();
for c = 1:size(dataset,2)
    dff = dataset(c).dff_ct_single;
    baseline = dataset(c).baselineSTD_ct;
    x_peak = dataset(c).x_peak_ct;
    peak = dataset(c).EffectSize_ct;
    f = dataset(c).FrameRate;
    if std([dff(1,1:10*f),dff(1,15*f:SweepDur*f)]) < thr % remove cells with large z drifts
        int = trapz(dff(1,5*f:10*f)) - trapz(zeros(size(5*f:10*f)));
        if (x_peak > 10*f && x_peak < 15*f && peak >= baseline*thr && int > size(10*f:15*f,2)*thr*baseline) % detect cells that show a response within the time window
            n = n+1;
            dataset_R = [dataset_R; dataset(c)];
            dataset_R(n).Integral_ct = int;
            for i = 1:SweepDur*f
                traces_R(n,i) = dff(1,i);
            end
            subplot(1,2,1)
            plot(traces_R(n,:), '-k', 'LineWidth',1); hold on;
            set(gca, 'xtick', 0:5*f:SweepDur*f); set(gca, 'xticklabel', 0:5:SweepDur); hold on;
        else
            nr = nr+1;
            dataset_NR = [dataset_NR; dataset(c)];
            dataset_NR(nr).timetopeak_ct = nan(1,3);
            dataset_NR(nr).decay_ct = nan(1,3);
            dataset_NR(nr).Integral_ct = int;
            for i = 1:SweepDur*f
                traces_NR(nr,i) = dff(1,i);
            end
            subplot(1,2,2)
            plot(traces_NR(nr,:), '-k', 'LineWidth',1); hold on;
            set(gca, 'xtick', 0:5*f:SweepDur*f); set(gca, 'xticklabel', 0:5:SweepDur); hold on;
        end
    end
end
subplot(1,2,1)
plot(nanmean(traces_R,1), '-r', 'LineWidth', 2); hold on;
xlabel('Time (s)');
ylabel('DeltaF/F (%)');
title('Responding cells');
subplot(1,2,2)
plot(nanmean(traces_NR,1), '-r', 'LineWidth', 2); hold on;
xlabel('Time (s)');
ylabel('DeltaF/F (%)');
title('Non-responding cells');

Perc_R = n/size(dataset,2);