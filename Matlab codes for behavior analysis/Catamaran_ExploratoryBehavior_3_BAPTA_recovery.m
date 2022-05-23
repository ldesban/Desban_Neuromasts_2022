function Catamaran_ExploratoryBehavior_3_BAPTA_recovery

%% 1. load data

uiwait(msgbox('Choose the Analyzed file'));
[filename, path] = uigetfile({'*.mat*'},'File Selector');
load([path '\' filename]);

% Specify outliers
Outliers = zeros(N(1,1),1);
out = input('Vector of the Fish_ID of outliers');
if isempty(out) == 0
    Outliers(out,1) = 1;
end

%% 2. reorganise data into a matrix called DATA_BAPTA_recovery

DATA_BAPTA_recovery = struct('Trial_ID', [], 'Fish_ID', [], 'Treatment', [], 'Condition', [], 'Outlier', [], 'Swim_t0', [], 'Swim_t1h', [], 'FQ_t0', [], 'FQ_t1h', [], 'Speed_t0', [], 'Speed_t1h', []);

ID_CT = unique([datasetPerFish_ID([datasetPerFish_ID.Genotype] == 1).Fish_ID]);
ID_CT(2,:) = deal(1);
ID_BAPTA = unique([datasetPerFish_ID([datasetPerFish_ID.Genotype] == 2).Fish_ID]);
ID_BAPTA(2,:) = deal(2);
ID_all = [ID_CT ID_BAPTA];

Swim = nan(N(1,1),4);
FQ = nan(N(1,1),4);
Speed = nan(N(1,1),4);

for f = 1:N(1,1)
    DATA_BAPTA_recovery(f,1).Trial_ID = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f) & ([datasetPerFish_ID.Genotype] == 0 | [datasetPerFish_ID.Genotype] == 2)).Trial_ID;
    DATA_BAPTA_recovery(f,1).Fish_ID = ID_all(1,f);
    DATA_BAPTA_recovery(f,1).Outlier = Outliers(ID_all(1,f),1); 
    if ID_all(2,f) == 1
        DATA_BAPTA_recovery(f,1).Condition = 'E3';
        DATA_BAPTA_recovery(f,1).Treatment = 'Untreated';
        j0 = 1;
        j1h = 2;
    elseif ID_all(2,f) == 2
        DATA_BAPTA_recovery(f,1).Condition = 'E3';
        DATA_BAPTA_recovery(f,1).Treatment = 'BAPTA';
        j0 = 3;
        j1h = 4;
    end
    DATA_BAPTA_recovery(f,1).Swim_t0 = pSwim(ID_all(1,f),j0);
    DATA_BAPTA_recovery(f,1).Swim_t1h = pSwim(ID_all(1,f),j1h);
    DATA_BAPTA_recovery(f,1).FQ_t0 = 1000/MedianIBI(ID_all(1,f),j0);
    DATA_BAPTA_recovery(f,1).FQ_t1h = 1000/MedianIBI(ID_all(1,f),j1h);
    DATA_BAPTA_recovery(f,1).Speed_t0 = MedianSpeed(ID_all(1,f),j0);
    DATA_BAPTA_recovery(f,1).Speed_t1h = MedianSpeed(ID_all(1,f),j1h);
    if Outliers(f,1) == 0
        Swim(f,j0) = pSwim(ID_all(1,f),j0);
        FQ(f,j0) = 1000/MedianIBI(ID_all(1,f),j0);   
        Speed(f,j0) = MedianSpeed(ID_all(1,f),j0);
        Swim(f,j1h) = pSwim(ID_all(1,f),j1h);
        FQ(f,j1h) = 1000/MedianIBI(ID_all(1,f),j1h);    
        Speed(f,j1h) = MedianSpeed(ID_all(1,f),j1h);
    end
end

%% 3. plot data

Nf = [sum(~isnan(Swim),1)];

h1 = figure();
subplot(1,3,1)
    for i = 1:size(Swim(:,1))
        line([1 2], [Swim(i,1) Swim(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Swim(:,1))
        line([3 4], [Swim(i,3) Swim(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmean(Swim(:,1),1) nanmean(Swim(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmean(Swim(:,3),1) nanmean(Swim(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(Swim);
    axis([0.5 4.5 -0.5 60]); set(gca, 'xtick', 1:4); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'Untreated +1h', 'BAPTA', 'BAPTA +1h'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Time spent swimming (%)');
        % Mann-Whitney test to compare untreated and BAPTA-treated at t0
        pSwim_t0 = ranksum(Swim(:,1), Swim(:,3));
        sigstar_LFD([1 3], pSwim_t0);
        % Mann-Whitney test to compare untreated and BAPTA-treated at t1h
        pSwim_t1 = ranksum(Swim(:,2), Swim(:,4));
        sigstar_LFD([2 4], pSwim_t1);
        % run repeated measures ANOVA to compare t0 and t1 in untreated
        Condition = [zeros(Nf(1,1),1); ones(Nf(1,1),1)];
        Swim_CT = [Swim(1:Nf(1,1),1:2); Swim(1:Nf(1,1),1:2)];
        tSwim = table(Condition, Swim_CT(:,1), Swim_CT(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_Swim = fitrm(tSwim, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_Swim_CT = ranova(rm_Swim); pSwim_CT = ranovatbl_Swim_CT.pValue(1,1);
        sigstar_LFD([1 2], pSwim_CT);
        % run repeated measures ANOVA to compare t0 and t1 in BAPTA-treated
        Condition = [zeros(Nf(1,3),1); ones(Nf(1,3),1)];
        Swim_BAPTA = [Swim(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4); Swim(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4)];
        tSwim = table(Condition, Swim_BAPTA(:,1), Swim_BAPTA(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_Swim = fitrm(tSwim, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_Swim_BAPTA = ranova(rm_Swim); pSwim_BAPTA = ranovatbl_Swim_BAPTA.pValue(1,1);
        sigstar_LFD([3 4], pSwim_BAPTA);
subplot(1,3,2)
    for i = 1:size(FQ(:,1))
        line([1 2], [FQ(i,1) FQ(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(FQ(:,1))
        line([3 4], [FQ(i,3) FQ(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmean(FQ(:,1),1) nanmean(FQ(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmean(FQ(:,3),1) nanmean(FQ(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(FQ);
    axis([0.5 4.5 -0.5 7]); set(gca, 'xtick', 1:4); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'Untreated +1h', 'BAPTA', 'BAPTA +1h'}); set(gca, 'xticklabelrotation', 45);
    ylabel('FQ (s-1)');
        % Mann-Whitney test to compare untreated and BAPTA-treated at t0
        pFQ_t0 = ranksum(FQ(:,1), FQ(:,3));
        sigstar_LFD([1 3], pFQ_t0);
        % Mann-Whitney test to compare untreated and BAPTA-treated at t1h
        pFQ_t1 = ranksum(FQ(:,2), FQ(:,4));
        sigstar_LFD([2 4], pFQ_t1);
        % run repeated measures ANOVA to compare t0 and t1 in untreated
        Condition = [zeros(Nf(1,1),1); ones(Nf(1,1),1)];
        FQ_CT = [FQ(1:Nf(1,1),1:2); FQ(1:Nf(1,1),1:2)];
        tFQ = table(Condition, FQ_CT(:,1), FQ_CT(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_FQ = fitrm(tFQ, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_FQ_CT = ranova(rm_FQ); pFQ_CT = ranovatbl_FQ_CT.pValue(1,1);
        sigstar_LFD([1 2], pFQ_CT);
        % run repeated measures ANOVA to compare t0 and t1 in BAPTA-treated
        Condition = [zeros(Nf(1,3),1); ones(Nf(1,3),1)];
        FQ_BAPTA = [FQ(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4); FQ(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4)];
        tFQ = table(Condition, FQ_BAPTA(:,1), FQ_BAPTA(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_FQ = fitrm(tFQ, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_FQ_BAPTA = ranova(rm_FQ); pFQ_BAPTA = ranovatbl_FQ_BAPTA.pValue(1,1);
        sigstar_LFD([3 4], pFQ_BAPTA);
subplot(1,3,3)
    for i = 1:size(Speed(:,1))
        line([1 2], [Speed(i,1) Speed(i,2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    for i = 1:size(Speed(:,1))
        line([3 4], [Speed(i,3) Speed(i,4)], 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    end
    jitter;
    line([1 2], [nanmean(Speed(:,1),1) nanmean(Speed(:,2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    line([3 4], [nanmean(Speed(:,3),1) nanmean(Speed(:,4),1)], 'Marker', 'o', 'Color', 'r', 'MarkerSize', 8, 'LineWidth', 3); hold on;
    boxplot(Speed);
    axis([0.5 4.5 -0.5 15]); set(gca, 'xtick', 1:4); set(gca, 'tickdir', 'out');
    xticklabels({'Untreated', 'Untreated +1h', 'BAPTA', 'BAPTA +1h'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Speed (mm.s-1)');
        % Mann-Whitney test to compare untreated and BAPTA-treated at t0
        pSpeed_t0 = ranksum(Speed(:,1), Speed(:,3));
        sigstar_LFD([1 3], pSpeed_t0);
        % Mann-Whitney test to compare untreated and BAPTA-treated at t1h
        pSpeed_t1 = ranksum(Speed(:,2), Speed(:,4));
        sigstar_LFD([2 4], pSpeed_t1);
        % run repeated measures ANOVA to compare t0 and t1 in untreated
        Condition = [zeros(Nf(1,1),1); ones(Nf(1,1),1)];
        Speed_CT = [Speed(1:Nf(1,1),1:2); Speed(1:Nf(1,1),1:2)];
        tSpeed = table(Condition, Speed_CT(:,1), Speed_CT(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_Speed = fitrm(tSpeed, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_Speed_CT = ranova(rm_Speed); pSpeed_CT = ranovatbl_Speed_CT.pValue(1,1);
        sigstar_LFD([1 2], pSpeed_CT);
        % run repeated measures ANOVA to compare t0 and t1 in BAPTA-treated
        Condition = [zeros(Nf(1,3),1); ones(Nf(1,3),1)];
        Speed_BAPTA = [Speed(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4); Speed(Nf(1,1)+1:Nf(1,1)+Nf(1,3),3:4)];
        tSpeed = table(Condition, Speed_BAPTA(:,1), Speed_BAPTA(:,2), 'VariableNames',{'Condition','t0','t1'});
        Time = [0 1]';
        rm_Speed = fitrm(tSpeed, 't0-t1 ~Condition', 'WithinDesign', Time);
        ranovatbl_Speed_BAPTA = ranova(rm_Speed); pSpeed_BAPTA = ranovatbl_Speed_BAPTA.pValue(1,1);
        sigstar_LFD([3 4], pSpeed_BAPTA);
P_MW_t0 = [pSwim_t0 pFQ_t0 pSpeed_t0];
P_MW_t1 = [pSwim_t1 pFQ_t1 pSpeed_t1];
P_ANOVA_CT = [pSwim_CT pFQ_CT pSpeed_CT];
P_ANOVA_BAPTA = [pSwim_BAPTA pFQ_BAPTA pSpeed_BAPTA];
saveas(h1, '220405 - Effect of recovery after BAPTA treatment (4a5c).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps


%% 4. save

uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

save(['220405 - Effect of recovery after BAPTA treatment (4a5c).mat'], 'DATA_BAPTA_recovery', 'Swim', 'FQ', 'Speed', 'Nf', 'P_MW_t0', 'P_MW_t1', 'P_ANOVA_CT', 'P_ANOVA_BAPTA');