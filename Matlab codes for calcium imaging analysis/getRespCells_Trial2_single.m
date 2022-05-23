function [dataset_R, dataset_NR, traces_R, traces_NR, Perc_R] = getRespCells_Trial2_single(dataset, thr)

dataset_R = [];
dataset_NR = [];
n = 0;
nr = 0;
traces_R = NaN(size(dataset,1),350);
traces_NR = NaN(size(dataset,1),350);

%% 1. classify cells as responding (in dataset_R) versus non-responding (in dataset_NR)

h1 = figure('Position', [1950 300 1400 800]);
for c = 1:size(dataset,1)
    dff = dataset(c).dff;
    baseline = dataset(c).baselineSTD;
    x_peak = dataset(c).x_peak;
    peak = dataset(c).EffectSize;
    f = dataset(c).FrameRate;
    int = trapz(dff(1,5*f:15*f)) - trapz(zeros(size(5*f:15*f)));
    if (x_peak > 5*f && x_peak < 15*f && peak >= baseline*thr && int > size(5*f:15*f,2)*thr*baseline)
        n = n+1;
        dataset_R = [dataset_R; dataset(c)];
        dataset_R(n).Integral = int;
        for i = 1:70*f
            traces_R(n,i) = dff(1,i);
        end
        subplot(1,2,1)
        plot(traces_R(n,:), '-k', 'LineWidth',1); hold on;
        set(gca, 'xtick', 0:5*f:70*f); set(gca, 'xticklabel', 0:5:70);
    else
        nr = nr+1;
        dataset_NR = [dataset_NR; dataset(c)];
        dataset_NR(nr).timetopeak = nan(1,3);
        dataset_NR(nr).decay = nan(1,3);
        dataset_NR(nr).Integral = int;
        for i = 1:70*f
            traces_NR(nr,i) = dff(1,i);
        end
        subplot(1,2,2)
        plot(traces_NR(nr,:), '-k', 'LineWidth',1); hold on;
        set(gca, 'xtick', 0:5*f:70*f); set(gca, 'xticklabel', 0:5:70);
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

Perc_R = n/size(dataset,1);