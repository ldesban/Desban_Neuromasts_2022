function [h, p1, p2, p3, p4] = plot_Resp_vs_NonResp_single(dataset_R, dataset_NR, Traces_R, Traces_NR, Perc_R, dataset_NR_R, dataset_NR_NR, Traces_NR_R, Traces_NR_NR, Perc_NR_R, dataset_R_R, dataset_R_NR, Traces_R_R, Traces_R_NR, Perc_R_R)

h = figure('Position', [1950 300 1400 800]);
subplot(4,3,1:2)
    patch([25 29 29 25], [-20 -20 200 200], 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.3); hold on;
    boundedline(1:350, nanmean(Traces_R,1), nanstd(Traces_R)/sqrt(size(dataset_R,1)), 'cmap', [1 0 0]); hold on;
    boundedline(1:350, nanmean(Traces_NR,1), nanstd(Traces_NR)/sqrt(size(dataset_NR,1)), 'cmap', [0 0 0]); hold on;
    axis([0 350 -5 30]);
    set(gca, 'xtick', 0:25:350); set(gca, 'xticklabel', 0:5:70); xlabel('Time (s)');
    ylabel('Trial1 - DeltaF/F (%)');
subplot(4,3,3)
    p1 = pie([Perc_R, 1-Perc_R]); 
    pText = findobj(p1,'Type','text');
    percentValues = get(pText,'String');
    if Perc_R ~= 0 && Perc_R ~= 1
        txt1 = {'Responding: ';'Non-responding: '}; 
        combinedtxt = strcat(txt1,percentValues); 
        pText(1).String = combinedtxt(1); pText(2).String = combinedtxt(2);
        c = p1(1); c.FaceColor = [1 0 0]; c = p1(3); c.FaceColor = [0 0 0];
    elseif Perc_R == 0
        txt1 = {'Non-responding: '}; 
        combinedtxt = strcat(txt1,percentValues); 
        pText(1).String = combinedtxt(1);
        c = p1(1); c.FaceColor = [0 0 0];
    elseif Perc_R == 1
        txt1 = {'Responding: '}; 
        combinedtxt = strcat(txt1,percentValues); 
        pText(1).String = combinedtxt(1);
        c = p1(1); c.FaceColor = [1 0 0];
    end
    D = [dataset_R; dataset_NR];
    title(['N = ', num2str(size(unique([D.Fish]),2)),  ' larvae'; 'n = ', num2str(size(D,1)), ' cells']);
subplot(4,3,4:5)
    patch([25 29 29 25], [-20 -20 200 200], 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.3); hold on;
    boundedline(1:350, nanmean(Traces_R_R,1), nanstd(Traces_R_R)/sqrt(size(dataset_R_R,1)), 'cmap', [0.75 0 0]); hold on;
    boundedline(1:350, nanmean(Traces_R_NR,1), nanstd(Traces_R_NR)/sqrt(size(dataset_R_NR,1)), '--', 'cmap', [1 0 0]); hold on;
    axis([0 350 -5 30]);
    set(gca, 'xtick', 0:25:350); set(gca, 'xticklabel', 0:5:70); xlabel('Time (s)');
    ylabel('Trial2 - DeltaF/F (%)');
subplot(4,3,6)
    p2 = pie([Perc_R_R, 1-Perc_R_R]); 
    pText = findobj(p2,'Type','text');
    percentValues = get(pText,'String'); 
    if Perc_R_R ~=0 && Perc_R_R ~= 1
        txt2 = {'R-R: ';'R-NR: '}; 
        combinedtxt = strcat(txt2,percentValues); 
        pText(1).String = combinedtxt(1);
        pText(2).String = combinedtxt(2);
        c = p2(1); c.FaceColor = [0.75 0 0]; c = p2(3); c.FaceColor = [1 0 0];
    elseif Perc_R_R == 0
        txt2 = {'R-NR: '}; 
        combinedtxt = strcat(txt2,percentValues); 
        pText(1).String = combinedtxt(1);
        c = p2(1); c.FaceColor = [1 0 0];
    elseif Perc_R_R == 1
        txt2 = {'R-R: '}; 
        combinedtxt = strcat(txt2,percentValues); 
        pText(1).String = combinedtxt(1);
        c = p2(1); c.FaceColor = [0.75 0 0];
    end
    D2 = [dataset_R_R; dataset_R_NR];
    title(['N = ', num2str(size(unique([D2.Fish]),2)),  ' larvae'; 'n = ', num2str(size(D2,1)), ' cells']);
subplot(4,3,7:8)
    patch([25 29 29 25], [-20 -20 200 200], 'cyan', 'EdgeColor', 'none', 'FaceAlpha', 0.3); hold on;
    boundedline(1:350, nanmean(Traces_NR_R,1), nanstd(Traces_NR_R)/sqrt(size(dataset_NR_R,1)), 'cmap', [0 0 0]); hold on;
    boundedline(1:350, nanmean(Traces_NR_NR,1), nanstd(Traces_NR_NR)/sqrt(size(dataset_NR_NR,1)), '--', 'cmap', [0.25 0.25 0.25]); hold on;
    axis([0 350 -5 30]);
    set(gca, 'xtick', 0:25:350); set(gca, 'xticklabel', 0:5:70); xlabel('Time (s)');
    ylabel('Trial2 - DeltaF/F (%)');
subplot(4,3,9)
    p3 = pie([Perc_NR_R, 1-Perc_NR_R]); 
    pText = findobj(p3,'Type','text');
    percentValues = get(pText,'String'); 
    if Perc_NR_R ~= 0 && Perc_NR_R ~=1
        txt3 = {'NR-R: ';'NR-NR: '}; 
        combinedtxt = strcat(txt3,percentValues); 
        pText(1).String = combinedtxt(1); pText(2).String = combinedtxt(2);
        c = p3(1); c.FaceColor = [0 0 0]; c = p3(3); c.FaceColor = [0.25 0.25 0.25];
    elseif Perc_NR_R == 0
        txt3 = {'NR-NR: '}; 
        combinedtxt = strcat(txt3,percentValues); 
        pText(1).String = combinedtxt(1); 
        c = p3(1); c.FaceColor = [0.25 0.25 0.25];
    elseif Perc_NR_R == 1
        txt3 = {'NR-R: '}; 
        combinedtxt = strcat(txt3,percentValues); 
        pText(1).String = combinedtxt(1);
        c = p3(1); c.FaceColor = [0 0 0];
    end
    D3 = [dataset_NR_R; dataset_NR_NR];
    title(['N = ', num2str(size(unique([D3.Fish]),2)),  ' larvae'; 'n = ', num2str(size(D3,1)), ' cells']);
subplot(4,3,10)
    for i = 1:size(dataset_R_NR,1)
        Effect1 = dataset_R_NR(i).EffectSize_ct;
        Effect2 = dataset_R_NR(i).EffectSize;
        line([1 2], [Effect1 Effect2], 'Marker', 'o', 'Color', 'r'); hold on;
    end
    for i = 1:size(dataset_R_R,1)
        Effect1 = dataset_R_R(i).EffectSize_ct;
        Effect2 = dataset_R_R(i).EffectSize;
        line([1 2], [Effect1 Effect2], 'Marker', 'o', 'Color', [0.75 0 0]); hold on;
    end
    for i = 1:size(dataset_NR_NR,1)
        Effect1 = dataset_NR_NR(i).EffectSize_ct;
        Effect2 = dataset_NR_NR(i).EffectSize;
        line([3 4], [Effect1 Effect2], 'Marker', 'o', 'Color', [0.25 0.25 0.25]); hold on;
    end
    for i = 1:size(dataset_NR_R,1)
        Effect1 = dataset_NR_R(i).EffectSize_ct;
        Effect2 = dataset_NR_R(i).EffectSize;
       line([3 4], [Effect1 Effect2], 'Marker', 'o', 'Color', 'k'); hold on;
    end
    axis([0.5 4.5 -5 100]);
    set(gca, 'xtick', 1.5:2:3.5); set(gca, 'xticklabel', {'Resp', 'Non-Resp'});
    ylabel('DeltaF/F (%)');
subplot(4,3,11)
    M = max([size(dataset_R_NR,1), size(dataset_R_R,1), size(dataset_NR_R,1)]);
    TTP = nan(M,4);
    if Perc_R_R ~= 0 && Perc_R_R ~= 1
        for i = 1:size(dataset_R_NR,1)
            TTP(i,1) = nanmean(dataset_R_NR(i).timetopeak_ct,2);
            plot(1, TTP(i,1), 'or'); hold on;
        end
        for i = 1:size(dataset_R_R,1)
            TTP(i,2) = nanmean(dataset_R_R(i).timetopeak_ct,2);
            TTP(i,3) = nanmean(dataset_R_R(i).timetopeak,2);
            line([2 3], [TTP(i,2) TTP(i,3)], 'Marker', 'o', 'Color', [0.75 0 0]); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            TTP(i,4) = nanmean(dataset_NR_R(i).timetopeak,2);
            plot(4, TTP(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(TTP); hold on;
    elseif Perc_R_R == 0
        for i = 1:size(dataset_R_NR,1)
            TTP(i,1) = nanmean(dataset_R_NR(i).timetopeak_ct,2);
            plot(1, TTP(i,1), 'or'); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            TTP(i,4) = nanmean(dataset_NR_R(i).timetopeak,2);
            plot(4, TTP(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(TTP); hold on;
    elseif Perc_R_R == 1
        for i = 1:size(dataset_R_R,1)
            TTP(i,2) = nanmean(dataset_R_R(i).timetopeak_ct,2);
            TTP(i,3) = nanmean(dataset_R_R(i).timetopeak,2);
            line([2 3], [TTP(i,2) TTP(i,3)], 'Marker', 'o', 'Color', [0.75 0 0]); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            TTP(i,4) = nanmean(dataset_NR_R(i).timetopeak,2);
            plot(4, TTP(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(TTP); hold on;
    end
    [h, p1] = ttest2(TTP(:,1), TTP(:,4)); sigstar_LFD([1 4], p1);
    [h, p2] = ttest(TTP(:,2), TTP(:,3)); sigstar_LFD([2 3], p2);
    axis([0.5 4.5 0 10]);
    set(gca, 'xtick', [1,2.5,4]); set(gca, 'xticklabel', {'R-NR', 'R-R', 'NR-R'});
    ylabel('Time to peak (s)');
subplot(4,3,12)
    Decay = nan(M,4);
    if Perc_R_R ~= 0 && Perc_R_R ~= 1
        for i = 1:size(dataset_R_NR,1)
            Decay(i,1) = nanmean(dataset_R_NR(i).decay_ct,2);
            plot(1, Decay(i,1), 'or'); hold on;
        end
        for i = 1:size(dataset_R_R,1)
            Decay(i,2) = nanmean(dataset_R_R(i).decay_ct,2);
            Decay(i,3) = nanmean(dataset_R_R(i).decay,2);
            line([2 3], [Decay(i,2) Decay(i,3)], 'Marker', 'o', 'Color', [0.75 0 0]); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            Decay(i,4) = nanmean(dataset_NR_R(i).decay,2);
            plot(4, TTP(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(Decay); hold on;
    elseif Perc_R_R == 0 
        for i = 1:size(dataset_R_NR,1)
            Decay(i,1) = nanmean(dataset_R_NR(i).decay_ct,2);
            plot(1, Decay(i,1), 'or'); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            Decay(i,4) = nanmean(dataset_NR_R(i).decay,2);
            plot(4, Decay(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(Decay); hold on;
    elseif Perc_R_R ==1 
        for i = 1:size(dataset_R_R,1)
            Decay(i,2) = nanmean(dataset_R_R(i).decay_ct,2);
            Decay(i,3) = nanmean(dataset_R_R(i).decay,2);
            line([2 3], [Decay(i,2) Decay(i,3)], 'Marker', 'o', 'Color', [0.75 0 0]); hold on;
        end
        for i = 1:size(dataset_NR_R,1)
            Decay(i,4) = nanmean(dataset_NR_R(i).decay,2);
            plot(4, Decay(i,4), 'ok'); hold on;
        end
        jitter;
        boxplot(Decay); hold on;
    end
    [h, p3] = ttest2(Decay(:,1), Decay(:,4)); sigstar_LFD([1 4], p3);
    [h, p4] = ttest(Decay(:,2), Decay(:,3)); sigstar_LFD([2 3], p4);
    axis([0.5 4.5 0 12]);
    set(gca, 'xtick', [1,2.5,4]); set(gca, 'xticklabel', {'R-NR', 'R-R', 'NR-R'});
    ylabel('Decay (s)');