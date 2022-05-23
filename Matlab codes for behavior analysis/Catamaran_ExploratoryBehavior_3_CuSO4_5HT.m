function Catamaran_ExploratoryBehavior_3_CuSO4_5HT

%% 1. load data

uiwait(msgbox('Choose the Analyzed file'));
[filename, path] = uigetfile({'*.mat*'},'File Selector');
load([path '\' filename]);

Outliers = zeros(N(1,1),1);
out = input('Vector of the Fish_ID of outliers');
if isempty(out) == 0
    Outliers(out,1) = 1;
end

%% 2. reorganise data into a matrix called DATA_CuSO4_5HT

DATA_CuSO4_5HT = struct('Trial_ID', [], 'Fish_ID', [], 'Treatment', [], 'Condition', [], 'Outlier', [], 'Swim_t0', [], 'Swim_t10', [], 'FQ_t0', [], 'FQ_t10', [], 'Speed_t0', [], 'Speed_t10', [], 'Turns_t0', [], 'Turns_t10', []);

ID_CT_E3 = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 1 & [datasetPerFish_ID.Genotype] == 0).Fish_ID]);
ID_CT_E3(2,:) = deal(1); ID_CT_E3(3,:) = 1;
ID_CT_5HT = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 2 & [datasetPerFish_ID.Genotype] == 0).Fish_ID]);
ID_CT_5HT(2,:) = deal(2); ID_CT_5HT(3,:) = 1;
ID_CuSO4_E3 = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 1 & [datasetPerFish_ID.Genotype] == 1).Fish_ID]);
ID_CuSO4_E3(2,:) = deal(1); ID_CuSO4_E3(3,:) = 2;
ID_CuSO4_5HT = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 2 & [datasetPerFish_ID.Genotype] == 1).Fish_ID]);
ID_CuSO4_5HT(2,:) = deal(2); ID_CuSO4_5HT(3,:) = 2;
ID_all = [ID_CT_E3 ID_CT_5HT ID_CuSO4_E3 ID_CuSO4_5HT];

Swim = nan(N(1,1),8);
FQ = nan(N(1,1),8);
Speed = nan(N(1,1),8);
Turns = nan(N(1,1),8);

for f = 1:N(1,1)
    DATA_CuSO4_5HT(f,1).Trial_ID = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f) & [datasetPerFish_ID.Condition] == ID_all(2,f)).Trial_ID;
    DATA_CuSO4_5HT(f,1).Fish_ID = ID_all(1,f);
    DATA_CuSO4_5HT(f,1).Outlier = Outliers(ID_all(1,f),1);    
    if ID_all(2,f) == 1 && ID_all(3,f) == 1
        DATA_CuSO4_5HT(f,1).Condition = 'E3';
        DATA_CuSO4_5HT(f,1).Treatment = 'Untreated';
        j0 = 1;
        j10 = 3;
    elseif ID_all(2,f) == 1 && ID_all(3,f) == 2 
        DATA_CuSO4_5HT(f,1).Condition = 'E3';
        DATA_CuSO4_5HT(f,1).Treatment = 'CuSO4';
        j0 = 2;
        j10 = 4;
    elseif ID_all(2,f) == 2 && ID_all(3,f) == 1 
        DATA_CuSO4_5HT(f,1).Condition = '5-HT';
        DATA_CuSO4_5HT(f,1).Treatment = 'Untreated';
        j0 = 1;
        j10 = 5;
    elseif ID_all(2,f) == 2 && ID_all(3,f) == 2 
        DATA_CuSO4_5HT(f,1).Condition = '5-HT';
        DATA_CuSO4_5HT(f,1).Treatment = 'CuSO4';
        j0 = 2;
        j10 = 6;
    end
    DATA_CuSO4_5HT(f,1).Swim_t0 = pSwim(ID_all(1,f),j0);
    DATA_CuSO4_5HT(f,1).FQ_t0 = 1000/MedianIBI(ID_all(1,f),j0);  
    DATA_CuSO4_5HT(f,1).Speed_t0 = MedianSpeed(ID_all(1,f),j0);
    DATA_CuSO4_5HT(f,1).Turns_t0 = pTurns(ID_all(1,f),j0);
    DATA_CuSO4_5HT(f,1).Swim_t10 = pSwim(ID_all(1,f),j10);
    DATA_CuSO4_5HT(f,1).FQ_t10 = 1000/MedianIBI(ID_all(1,f),j10);  
    DATA_CuSO4_5HT(f,1).Speed_t10 = MedianSpeed(ID_all(1,f),j10);
    DATA_CuSO4_5HT(f,1).Turns_t10 = pTurns(ID_all(1,f),j10);
    if Outliers(f,1) == 0
        j2 = (ID_all(3,f)-1)*4 + (ID_all(2,f)-1)*2 +1;
        Swim(f,j2) = pSwim(ID_all(1,f),j0);
        FQ(f,j2) = 1000/MedianIBI(ID_all(1,f),j0);   
        Speed(f,j2) = MedianSpeed(ID_all(1,f),j0);
        Turns(f,j2) = pTurns(ID_all(1,f),j0);
        Swim(f,j2+1) = pSwim(ID_all(1,f),j10);
        FQ(f,j2+1) = 1000/MedianIBI(ID_all(1,f),j10);    
        Speed(f,j2+1) = MedianSpeed(ID_all(1,f),j10);
        Turns(f,j2+1) = pTurns(ID_all(1,f),j10);
    end
end

%% 3. plot data

Nf = [sum(~isnan(Swim),1)];

h1 = figure();
subplot(2,2,1)
    for i = 1:size(Swim(:,1))
        line([1 2], [Swim(i,1) Swim(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Swim(:,1))
        line([3 4], [Swim(i,3) Swim(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Swim(:,1))
        line([5 6], [Swim(i,5) Swim(i,6)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Swim(:,1))
        line([7 8], [Swim(i,7) Swim(i,8)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmedian(Swim(:,1),1) nanmedian(Swim(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmedian(Swim(:,3),1) nanmedian(Swim(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([5 6], [nanmedian(Swim(:,5),1) nanmedian(Swim(:,6),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([7 8], [nanmedian(Swim(:,7),1) nanmedian(Swim(:,8),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(Swim);
    axis([0.5 8.5 -0.5 60]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'CuSO4', 'CuSO4+5HT'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Percentage of time spent swimming');
    % stat to see the effect of 5-HT on untreated larvae
        p = ranksum(Swim(:,1), Swim(:,1));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Swim(:,1); Swim(:,3)];
            y10 = [Swim(:,2); Swim(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSwim_CT = cell2mat(a(2,6));
                aSwim_CT = a;
                sigstar_LFD([1.5 3.5], pSwim_CT);
            else
                pSwim_CT = NaN; aSwim_CT = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSwim_CT = NaN; aSwim_CT = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
    % stat to see the effect of 5-HT on CuSO4-treated larvae
        p = ranksum(Swim(:,5), Swim(:,6));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Swim(:,5); Swim(:,7)];
            y10 = [Swim(:,6); Swim(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSwim_CuSO4 = cell2mat(a(2,6));
                aSwim_CuSO4 = a;
                sigstar_LFD([5.5 7.5], pSwim_CuSO4);
            else
                pSwim_CuSO4 = NaN; aSwim_CuSO4 = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSwim_CuSO4 = NaN; aSwim_CuSO4 = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,2)
    for i = 1:size(FQ(:,1))
        line([1 2], [FQ(i,1) FQ(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(FQ(:,1))
        line([3 4], [FQ(i,3) FQ(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    for i = 1:size(FQ(:,1))
        line([5 6], [FQ(i,5) FQ(i,6)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(FQ(:,1))
        line([7 8], [FQ(i,7) FQ(i,8)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmedian(FQ(:,1),1) nanmedian(FQ(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmedian(FQ(:,3),1) nanmedian(FQ(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([5 6], [nanmedian(FQ(:,5),1) nanmedian(FQ(:,6),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([7 8], [nanmedian(FQ(:,7),1) nanmedian(FQ(:,8),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(FQ);
    axis([0.5 8.5 -0.5 6]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'CuSO4', 'CuSO4+5HT'}); set(gca, 'xticklabelrotation', 45);
    ylabel('FQ (s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        p = ranksum(FQ(:,1), FQ(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [FQ(:,1); FQ(:,3)];
            y10 = [FQ(:,2); FQ(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pFQ_CT = cell2mat(a(2,6));
                aFQ_CT = a;
                sigstar_LFD([1.5 3.5], pFQ_CT);
            else
                pFQ_CT = NaN; aFQ_CT = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pFQ_CT = NaN; aFQ_CT = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
    % stat to see the effect of 5-HT on CuSO4-treated larvae
        p = ranksum(FQ(:,5), FQ(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [FQ(:,5); FQ(:,7)];
            y10 = [FQ(:,6); FQ(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pFQ_CuSO4 = cell2mat(a(2,6));
                aFQ_CuSO4 = a;
                sigstar_LFD([5.5 7.5], pFQ_CuSO4);
            else
                pFQ_CuSO4 = NaN; aFQ_CuSO4 = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pFQ_CuSO4 = NaN; aFQ_CuSO4 = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,3)
    for i = 1:size(Speed(:,1))
        line([1 2], [Speed(i,1) Speed(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Speed(:,1))
        line([3 4], [Speed(i,3) Speed(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Speed(:,1))
        line([5 6], [Speed(i,5) Speed(i,6)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Speed(:,1))
        line([7 8], [Speed(i,7) Speed(i,8)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmedian(Speed(:,1),1) nanmedian(Speed(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmedian(Speed(:,3),1) nanmedian(Speed(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([5 6], [nanmedian(Speed(:,5),1) nanmedian(Speed(:,6),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([7 8], [nanmedian(Speed(:,7),1) nanmedian(Speed(:,8),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(Speed);
    axis([0.5 8.5 -0.5 16]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'CuSO4', 'CuSO4+5HT'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Speed (mm.s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        p = ranksum(Speed(:,1), Speed(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Speed(:,1); Speed(:,3)];
            y10 = [Speed(:,2); Speed(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSpeed_CT = cell2mat(a(2,6));
                aSpeed_CT = a;
                sigstar_LFD([1.5 3.5], pSpeed_CT);
            else
                pSpeed_CT = NaN; aSpeed_CT = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSpeed_CT = NaN; aSpeed_CT = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
    % stat to see the effect of 5-HT on CuSO4-treated larvae
        p = ranksum(Speed(:,5), Speed(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Speed(:,5); Speed(:,7)];
            y10 = [Speed(:,6); Speed(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSpeed_CuSO4 = cell2mat(a(2,6));
                aSpeed_CuSO4 = a;
                sigstar_LFD([5.5 7.5], pSpeed_CuSO4);
            else
                pSpeed_CuSO4 = NaN; aSpeed_CuSO4 = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSpeed_CuSO4 = NaN; aSpeed_CuSO4 = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,4)
    for i = 1:size(Turns(:,1))
        line([1 2], [Turns(i,1) Turns(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Turns(:,1))
        line([3 4], [Turns(i,3) Turns(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Turns(:,1))
        line([5 6], [Turns(i,5) Turns(i,6)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Turns(:,1))
        line([7 8], [Turns(i,7) Turns(i,8)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmedian(Turns(:,1),1) nanmedian(Turns(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmedian(Turns(:,3),1) nanmedian(Turns(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([5 6], [nanmedian(Turns(:,5),1) nanmedian(Turns(:,6),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([7 8], [nanmedian(Turns(:,7),1) nanmedian(Turns(:,8),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(Turns);
    axis([0.5 8.5 0 105]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'CuSO4', 'CuSO4+5HT'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Turns (%)');
    % stat to see the effect of 5-HT on untreated larvae
        p = ranksum(Turns(:,1), Turns(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Turns(:,1); Turns(:,3)];
            y10 = [Turns(:,2); Turns(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pTurns_CT = cell2mat(a(2,6));
                aTurns_CT = a;
                sigstar_LFD([1.5 3.5], pTurns_CT);
            else
                pTurns_CT = NaN; aTurns_CT = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pTurns_CT = NaN; aTurns_CT = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
    % stat to see the effect of 5-HT on CuSO4-treated larvae
        p = ranksum(Turns(:,5), Turns(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Turns(:,5); Turns(:,7)];
            y10 = [Turns(:,6); Turns(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pTurns_CuSO4 = cell2mat(a(2,6));
                aTurns_CuSO4 = a;
                sigstar_LFD([5.5 7.5], pTurns_CuSO4);
            else
                pTurns_CuSO4 = NaN; aTurns_CuSO4 = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pTurns_CuSO4 = NaN; aTurns_CuSO4 = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
saveas(h1, '220311 - Effect of 5-HT on untreated and CuSO4-treated larvae (3bd5ah, without outliers #26,179).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps
P_ANCOVA_t0_versus_t10 = [pFQ_CT, pFQ_CuSO4, pSwim_CT, pSwim_CuSO4, pSpeed_CT, pSpeed_CuSO4, pTurns_CT, pTurns_CuSO4];

%% 4. plot only effect of 5-HT on CuSO4-treated larvae

h2 = figure();
subplot(2,2,1)
    plot(ones(N(1,1),1), Swim(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Swim(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Swim(:,[6,8])); 
    axis([0.5 2.5 -5 60]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'CuSO4', 'CuSO4+5HT'});
    ylabel('Percentage of time swimming');
    % stat to see the effect of 5-HT on untreated larvae
        pSwim_5HT = ranksum(Swim(:,6), Swim(:,8));
        sigstar_LFD([1 2], pSwim_5HT);
subplot(2,2,2)
    plot(ones(N(1,1),1), FQ(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, FQ(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(FQ(:,[6,8])); 
    axis([0.5 2.5 -0.5 6]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'CuSO4', 'CuSO4+5HT'});
    ylabel('FQ (s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pFQ_5HT = ranksum(FQ(:,6), FQ(:,8));
        sigstar_LFD([1 2], pFQ_5HT);
subplot(2,2,3)
    plot(ones(N(1,1),1), Speed(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Speed(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Speed(:,[6,8])); 
    axis([0.5 2.5 -0.5 15]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'CuSO4', 'CuSO4+5HT'});
    ylabel('Speed (mm.s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pSpeed_5HT = ranksum(Speed(:,6), Speed(:,8));
        sigstar_LFD([1 2], pSpeed_5HT);
subplot(2,2,4)
    plot(ones(N(1,1),1), Turns(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Turns(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Turns(:,[6,8])); 
    axis([0.5 2.5 -0.5 105]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'CuSO4', 'CuSO4+5HT'});
    ylabel('Turns (%)');
    % stat to see the effect of 5-HT on untreated larvae
        pTurns_5HT = ranksum(Turns(:,6), Turns(:,8));
        sigstar_LFD([1 2], pTurns_5HT);
P_MW_CuSO4_E3_versus_5HT = [pSwim_5HT, pFQ_5HT, pSpeed_5HT, pTurns_5HT];
saveas(h2, '220311 - Effect of 5-HT on CuSO4-treated larvae (3bd5ah).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps

%% 5. Plot effects of CuSO4 treatment

h3 = figure();
subplot(2,2,1)
    plot(ones(N(1,1),1), pSwim(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, pSwim(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(pSwim(:,[1,2])); 
    axis([0.5 2.5 -5 60]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'CuSO4'});
    ylabel('Percentage of time swimming');
    % stat to see the effect of 5-HT on untreated larvae
        pSwim_CuSO4 = ranksum(pSwim(:,1), pSwim(:,2));
        sigstar_LFD([1 2], pSwim_CuSO4);
subplot(2,2,2)
    plot(ones(N(1,1),1), 1000./MedianIBI(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, 1000./MedianIBI(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(1000./MedianIBI(:,[1,2])); 
    axis([0.5 2.5 -0.5 6]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'CuSO4'});
    ylabel('FQ (s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pFQ_CuSO4 = ranksum(1000./MedianIBI(:,1), 1000./MedianIBI(:,2));
        sigstar_LFD([1 2], pFQ_CuSO4);
subplot(2,2,3)
    plot(ones(N(1,1),1), MedianSpeed(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, MedianSpeed(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(MedianSpeed(:,[1,2])); 
    axis([0.5 2.5 -0.5 15]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'CuSO4'});
    ylabel('Speed (mm.s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pSpeed_CuSO4 = ranksum(MedianSpeed(:,1), MedianSpeed(:,2));
        sigstar_LFD([1 2], pSpeed_CuSO4);
subplot(2,2,4)
    plot(ones(N(1,1),1), pTurns(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, pTurns(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(pTurns(:,[1,2])); 
    axis([0.5 2.5 -0.5 105]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'CuSO4'});
    ylabel('Turns (%)');
    % stat to see the effect of 5-HT on untreated larvae
        pTurns_CuSO4 = ranksum(pTurns(:,1), pTurns(:,2));
        sigstar_LFD([1 2], pTurns_CuSO4);
P_MW_CuSO4_versus_CT = [pSwim_CuSO4, pFQ_CuSO4, pSpeed_CuSO4, pTurns_CuSO4];
saveas(h3, '220311 - Effect of CuSO4 treatment (3bd5ah).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps

% %% 5. plot only effect of 5-HT when t0 and t10 recordings
% 
% Nf2 = [sum(~isnan(IBI_CuSO4_E3(:,1))); sum(~isnan(IBI_CuSO4_5HT(:,1)))];
% h3 = figure('Position', [1950 300 1400 800]);
% subplot(2,2,1)
%     for f = 1:Nf2(1,1)
%         line([1 2], [log(IBI_CuSO4_E3(f,1)) log(IBI_CuSO4_E3(f,2))], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
%     end
%     for f = 1:Nf2(2,1)
%         line([3 4], [log(IBI_CuSO4_5HT(f,1)) log(IBI_CuSO4_5HT(f,2))], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8); hold on;
%     end
%     jitter;
%     line([1 2], [nanmedian(log(IBI_CuSO4_E3(:,1)),1) nanmedian(log(IBI_CuSO4_E3(:,2)),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     line([3 4], [nanmedian(log(IBI_CuSO4_5HT(:,1)),1) nanmedian(log(IBI_CuSO4_5HT(:,2)),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     axis([0.5 4.5 -3 8]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
%     xticklabels({'CuSO4+E3', 'CuSO4+5HT'});
%     ylabel('log(IBI) (s)');
%     % stats to compare between t0 and t10 for CuSO4-treated larvae in E3
%     p = ranksum(log(IBI_CuSO4_E3(:,1)), log(IBI_CuSO4_5HT(:,1)));
%         if p > 0.05
%             x = [zeros(Nf2(1,1),1); ones(Nf2(2,1),1)];
%             y0 = [log(IBI_CuSO4_E3(1:Nf2(1,1),1)); log(IBI_CuSO4_5HT(1:Nf2(2,1),1))];
%             y10 = [log(IBI_CuSO4_E3(1:Nf2(1,1),2)); log(IBI_CuSO4_5HT(1:Nf2(2,1),2))];
%             [h,a,c,s] = aoctool(y0, y10, x);
%             if cell2mat(a(4,6)) > 0.05
%                 pIBI_CuSO4_2 = cell2mat(a(2,6));
%                 aIBI_CuSO4_2 = a;
%                 sigstar_LFD([1.5 3.5], pIBI_CuSO4_2);
%             else
%                 pIBI_CuSO4_2 = NaN; aIBI_CuSO4_2 = NaN;
%                 uiwait(msgbox('Non homogenous regression!'));
%             end
%         else
%             pIBI_CuSO4_2 = NaN; aIBI_CuSO4_2 = NaN;
%             uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
%         end
% subplot(2,2,2)
%     for f = 1:Nf2(1,1)
%         line([1 2], [FQ_CuSO4_E3(f,1) FQ_CuSO4_E3(f,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
%     end
%     for f = 1:Nf2(2,1)
%         line([3 4], [FQ_CuSO4_5HT(f,1) FQ_CuSO4_5HT(f,2)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8); hold on;
%     end
%     jitter;
%     line([1 2], [nanmedian(FQ_CuSO4_E3(:,1),1) nanmedian(FQ_CuSO4_E3(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     line([3 4], [nanmedian(FQ_CuSO4_5HT(:,1),1) nanmedian(FQ_CuSO4_5HT(:,2),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     axis([0.5 4.5 -0.5 5]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
%     xticklabels({'CuSO4+E3', 'CuSO4+5HT'});
%     ylabel('FQ (s-1)');
%     % stats to compare between t0 and t10 for CuSO4-treated larvae in E3
%     p = ranksum(FQ_CuSO4_E3(:,1), FQ_CuSO4_5HT(:,1));
%         if p > 0.05
%             x = [zeros(Nf2(1,1),1); ones(Nf2(2,1),1)];
%             y0 = [FQ_CuSO4_E3(1:Nf2(1,1),1); FQ_CuSO4_5HT(1:Nf2(2,1),1)];
%             y10 = [FQ_CuSO4_E3(1:Nf2(1,1),2); FQ_CuSO4_5HT(1:Nf2(2,1),2)];
%             [h,a,c,s] = aoctool(y0, y10, x);
%             if cell2mat(a(4,6)) > 0.05
%                 pFQ_CuSO4_2 = cell2mat(a(2,6));
%                 aFQ_CuSO4_2 = a;
%                 sigstar_LFD([1.5 3.5], pFQ_CuSO4_2);
%             else
%                 pFQ_CuSO4_2 = NaN; aFQ_CuSO4_2 = NaN;
%                 uiwait(msgbox('Non homogenous regression!'));
%             end
%         else
%             pFQ_CuSO4_2 = NaN; aFQ_CuSO4_2 = NaN;
%             uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
%         end
% subplot(2,2,3)
%     for f = 1:Nf2(1,1)
%         line([1 2], [Speed_CuSO4_E3(f,1) Speed_CuSO4_E3(f,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
%     end
%     for f = 1:Nf2(2,1)
%         line([3 4], [Speed_CuSO4_5HT(f,1) Speed_CuSO4_5HT(f,2)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8); hold on;
%     end
%     jitter;
%     line([1 2], [nanmedian(Speed_CuSO4_E3(:,1),1) nanmedian(Speed_CuSO4_E3(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     line([3 4], [nanmedian(Speed_CuSO4_5HT(:,1),1) nanmedian(Speed_CuSO4_5HT(:,2),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     axis([0.5 4.5 -0.5 8]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
%     xticklabels({'CuSO4+E3', 'CuSO4+5HT'});
%     ylabel('Speed (mm.s-1)');
%     % stats to compare between t0 and t10 for CuSO4-treated larvae in E3
%     p = ranksum(Speed_CuSO4_E3(:,1), Speed_CuSO4_5HT(:,1));
%         if p > 0.05
%             x = [zeros(Nf2(1,1),1); ones(Nf2(2,1),1)];
%             y0 = [Speed_CuSO4_E3(1:Nf2(1,1),1); Speed_CuSO4_5HT(1:Nf2(2,1),1)];
%             y10 = [Speed_CuSO4_E3(1:Nf2(1,1),2); Speed_CuSO4_5HT(1:Nf2(2,1),2)];
%             [h,a,c,s] = aoctool(y0, y10, x);
%             if cell2mat(a(4,6)) > 0.05
%                 pSpeed_CuSO4_2 = cell2mat(a(2,6));
%                 aSpeed_CuSO4_2 = a;
%                 sigstar_LFD([1.5 3.5], pSpeed_CuSO4_2);
%             else
%                 pSpeed_CuSO4_2 = NaN; aSpeed_CuSO4_2 = NaN;
%                 uiwait(msgbox('Non homogenous regression!'));
%             end
%         else
%             pSpeed_CuSO4_2 = NaN; aSpeed_CuSO4_2 = NaN;
%             uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
%         end
% subplot(2,2,4)
%     for f = 1:Nf2(1,1)
%         line([1 2], [Turns_CuSO4_E3(f,1) Turns_CuSO4_E3(f,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
%     end
%     for f = 1:Nf2(2,1)
%         line([3 4], [Turns_CuSO4_5HT(f,1) Turns_CuSO4_5HT(f,2)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8); hold on;
%     end
%     jitter;
%     line([1 2], [nanmedian(Turns_CuSO4_E3(:,1),1) nanmedian(Turns_CuSO4_E3(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     line([3 4], [nanmedian(Turns_CuSO4_5HT(:,1),1) nanmedian(Turns_CuSO4_5HT(:,2),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
%     axis([0.5 4.5 -0.5 100.5]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
%     xticklabels({'CuSO4+E3', 'CuSO4+5HT'});
%     ylabel('Turns (%)');
%     % stats to compare between t0 and t10 for CuSO4-treated larvae in E3
%     p = ranksum(Turns_CuSO4_E3(:,1), Turns_CuSO4_5HT(:,1));
%         if p > 0.05
%             x = [zeros(Nf2(1,1),1); ones(Nf2(2,1),1)];
%             y0 = [Turns_CuSO4_E3(1:Nf2(1,1),1); Turns_CuSO4_5HT(1:Nf2(2,1),1)];
%             y10 = [Turns_CuSO4_E3(1:Nf2(1,1),2); Turns_CuSO4_5HT(1:Nf2(2,1),2)];
%             [h,a,c,s] = aoctool(y0, y10, x);
%             if cell2mat(a(4,6)) > 0.05
%                 pTurns_CuSO4_2 = cell2mat(a(2,6));
%                 aTurns_CuSO4_2 = a;
%                 sigstar_LFD([1.5 3.5], pTurns_CuSO4_2);
%             else
%                 pTurns_CuSO4_2 = NaN; aTurns_CuSO4_2 = NaN;
%                 uiwait(msgbox('Non homogenous regression!'));
%             end
%         else
%             pTurns_CuSO4_2 = NaN; aTurns_CuSO4_2 = NaN;
%             uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
%         end
% P_ANCOVA_t0_versus_t10_CuSO4_only = [pIBI_CuSO4_2 pFQ_CuSO4_2 pSpeed_CuSO4_2 pTurns_CuSO4_2];
% saveas(h3, '191026 - Effect of 5-HT and time on CuSO4-treated larvae (3bd,5ah).fig');
% set(gcf,'renderer','Painters');
% print -depsc -tiff -r300 -painters Image.eps
    
%% 6. save

close all

uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

save(['220311 - Effect of 5-HT on CuSO4-treated larvae (3bd5ah, without outliers #26,179).mat'], 'DATA_CuSO4_5HT', 'Swim', 'FQ', 'Speed', 'Turns', 'Nf', 'P_MW_CuSO4_versus_CT');
%'P_ANCOVA_t0_versus_t10', 'P_MW_CuSO4_E3_versus_5HT', 