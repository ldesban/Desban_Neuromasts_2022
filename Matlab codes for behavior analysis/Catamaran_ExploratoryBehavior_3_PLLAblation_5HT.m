function Catamaran_ExploratoryBehavior_3_PLLAblation_5HT

%% 1. load data

uiwait(msgbox('Choose the Analyzed file'));
[filename, path] = uigetfile({'*.mat*'},'File Selector');
load([path '\' filename]);

Outliers = zeros(N(1,1),1);
out = input('Vector of the Fish_ID of outliers');
if isempty(out) == 0
    Outliers(out,1) = 1;
end

%% 2. reorganise data into a matrix called DATA_OMPAblation_5HT

DATA_PLLAblation_5HT = struct('Trial_ID', [], 'Fish_ID', [], 'Treatment', [], 'Condition', [], 'Outlier', [], 'Swim_t0', [], 'Swim_t10', [], 'FQ_t0', [], 'FQ_t10', [], 'Speed_t0', [], 'Speed_t10', [], 'Turns_t0', [], 'Turns_t10', []);

ID_CT_E3 = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 1 & [datasetPerFish_ID.Genotype] == 0).Fish_ID]);
ID_CT_E3(2,:) = deal(1); ID_CT_E3(3,:) = deal(1); 
ID_CT_5HT = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 2 & [datasetPerFish_ID.Genotype] == 0).Fish_ID]);
ID_CT_5HT(2,:) = deal(2); ID_CT_5HT(3,:) = deal(1); 
ID_PLLAblation_E3 = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 1 & [datasetPerFish_ID.Genotype] == 1).Fish_ID]);
ID_PLLAblation_E3(2,:) = deal(1); ID_PLLAblation_E3(3,:) = deal(2); 
ID_PLLAblation_5HT = unique([datasetPerFish_ID([datasetPerFish_ID.Condition] == 2 & [datasetPerFish_ID.Genotype] == 1).Fish_ID]);
ID_PLLAblation_5HT(2,:) = deal(2); ID_PLLAblation_5HT(3,:) = deal(2); 
ID_all = [ID_CT_E3 ID_CT_5HT ID_PLLAblation_E3 ID_PLLAblation_5HT];
    
Swim = nan(N(1,1),8); 
FQ = nan(N(1,1),8); 
Speed = nan(N(1,1),8); 
Turns = nan(N(1,1),8);

for f = 1:98
    DATA_PLLAblation_5HT(f,1).Trial_ID = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f) & [datasetPerFish_ID.Condition] == ID_all(2,f)).Trial_ID;
    DATA_PLLAblation_5HT(f,1).Fish_ID = ID_all(1,f);
    DATA_PLLAblation_5HT(f,1).Outlier = Outliers(ID_all(1,f),1);
    if ID_all(2,f) == 1 && ID_all(3,f) == 1
        DATA_PLLAblation_5HT(f,1).Condition = 'E3';
        DATA_PLLAblation_5HT(f,1).Treatment = 'Sham ablation';
        j0 = 1;
        j10 = 3;
    elseif ID_all(2,f) == 1 && ID_all(3,f) == 2 
        DATA_PLLAblation_5HT(f,1).Condition = 'E3';
        DATA_PLLAblation_5HT(f,1).Treatment = 'PLL ablation';
        j0 = 2;
        j10 = 4;
    elseif ID_all(2,f) == 2 && ID_all(3,f) == 1 
        DATA_PLLAblation_5HT(f,1).Condition = '5-HT';
        DATA_PLLAblation_5HT(f,1).Treatment = 'Sham ablation';
        j0 = 1;
        j10 = 5;
    elseif ID_all(2,f) == 2 && ID_all(3,f) == 2 
        DATA_PLLAblation_5HT(f,1).Condition = '5-HT';
        DATA_PLLAblation_5HT(f,1).Treatment = 'PLL ablation';
        j0 = 2;
        j10 = 6;
    end
    DATA_PLLAblation_5HT(f,1).Swim_t0 = pSwim(ID_all(1,f),j0);
    DATA_PLLAblation_5HT(f,1).FQ_t0 = 1000/MedianIBI(ID_all(1,f),j0);  
    DATA_PLLAblation_5HT(f,1).Speed_t0 = MedianSpeed(ID_all(1,f),j0);
    DATA_PLLAblation_5HT(f,1).Turns_t0 = pTurns(ID_all(1,f),j0);
    DATA_PLLAblation_5HT(f,1).Swim_t10 = pSwim(ID_all(1,f),j10);
    DATA_PLLAblation_5HT(f,1).FQ_t10 = 1000/MedianIBI(ID_all(1,f),j10);  
    DATA_PLLAblation_5HT(f,1).Speed_t10 = MedianSpeed(ID_all(1,f),j10);
    DATA_PLLAblation_5HT(f,1).Turns_t10 = pTurns(ID_all(1,f),j10);
    if Outliers(ID_all(1,f),1) == 0
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
    Catamaran_ExploratoryBehavior_3_plot(Swim);
    axis([0.5 8.5 -0.5 60]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'PLLAblation', 'PLLAblation+5HT'}); set(gca, 'xticklabelrotation', 45);
    ylabel('Percentage of time swimming');
    % stat to see the effect of 5-HT on untreated larvae
        p = ranksum(Swim(:,1), Swim(:,3));
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
    % stat to see the effect of 5-HT on OMPAblation-treated larvae
        p = ranksum(Swim(:,5), Swim(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Swim(:,5); Swim(:,7)];
            y10 = [Swim(:,6); Swim(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSwim_PLLAblation = cell2mat(a(2,6));
                aSwim_PLLAblation = a;
                sigstar_LFD([5.5 7.5], pSwim_PLLAblation);
            else
                pIBI_PLLPAblation = NaN; aSwim_PLLAblation = NaN;
             end
        else
            pSwim_PLLAblation = NaN; aSwim_PLLAblation = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,2)
    Catamaran_ExploratoryBehavior_3_plot(FQ);
    axis([0.5 8.5 -0.5 6]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'PLLAblation', 'PLLAblation+5HT'}); set(gca, 'xticklabelrotation', 45);
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
    % stat to see the effect of 5-HT on BAPTA-treated larvae
        p = ranksum(FQ(:,5), FQ(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [FQ(:,5); FQ(:,7)];
            y10 = [FQ(:,6); FQ(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pFQ_PLLAblation = cell2mat(a(2,6));
                aFQ_PLLAblation = a;
                sigstar_LFD([5.5 7.5], pFQ_PLLAblation);
            else
                pFQ_PLLAblation = NaN; aFQ_PLLAblation = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pFQ_PLLAblation = NaN; aFQ_PLLAblation = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,3)
    Catamaran_ExploratoryBehavior_3_plot(Speed);
    axis([0.5 8.5 -0.5 16]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'PLLAblation', 'PLLAblation+5HT'}); set(gca, 'xticklabelrotation', 45);
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
    % stat to see the effect of 5-HT on BAPTA-treated larvae
        p = ranksum(Speed(:,5), Speed(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Speed(:,5); Speed(:,7)];
            y10 = [Speed(:,6); Speed(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSpeed_PLLAblation = cell2mat(a(2,6));
                aSpeed_PLLAblation = a;
                sigstar_LFD([5.5 7.5], pSpeed_PLLAblation);
            else
                pSpeed_PLLAblation = NaN; aSpeed_PLLAblation = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSpeed_PLLAblation = NaN; aSpeed_PLLAblation = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,4)
    Catamaran_ExploratoryBehavior_3_plot(Turns);
    axis([0.5 8.5 0 105]); set(gca, 'xtick', 1.5:2:8); set(gca, 'tickdir', 'out');
    xticklabels({'CT', 'CT+5HT', 'PLLAblation', 'PLLAblation+5HT'}); set(gca, 'xticklabelrotation', 45);
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
    % stat to see the effect of 5-HT on BAPTA-treated larvae
        p = ranksum(Turns(:,5), Turns(:,7));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Turns(:,5); Turns(:,7)];
            y10 = [Turns(:,6); Turns(:,8)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pTurns_PLLAblation = cell2mat(a(2,6));
                aTurns_PLLAblation = a;
                sigstar_LFD([5.5 7.5], pTurns_PLLAblation);
            else
                pTurns_PLLAblation = NaN; aTurns_PLLAblation = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pTurns_PLLAblation = NaN; aTurns_PLLAblation = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
saveas(h1, '220430 - Effect of 5-HT on sham or PLL ablated larvae (MEANS, 10fghijk, 5h or more recovery time).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps
P_ANCOVA_t0_versus_t10 = [pSwim_CT, pSwim_PLLAblation, pFQ_CT, pFQ_PLLAblation, pSpeed_CT, pSpeed_PLLAblation, pTurns_CT, pTurns_PLLAblation];

%% 4. Plot effect of PLL ablation only

h2 = figure();
subplot(2,2,1)
    plot(ones(N(1,1),1), pSwim(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, pSwim(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(pSwim(:,[1,2])); 
    axis([0.5 2.5 -0.5 80]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Sham', 'PLLAblation'});
    ylabel('Percentage of time swimming');
    % stat to see the effect of 5-HT on untreated larvae
        pSwim_PLLAblation = ranksum(pSwim(:,1), pSwim(:,2));
        sigstar_LFD([1 2], pSwim_PLLAblation);
subplot(2,2,2)
    plot(ones(N(1,1),1), 1000./MedianIBI(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, 1000./MedianIBI(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(1000./MedianIBI(:,[1,2])); 
    axis([0.5 2.5 -0.5 5]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Sham', 'PLLAblation'});
    ylabel('FQ (s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pFQ_PLLAblation = ranksum(1000./MedianIBI(:,1), 1000./MedianIBI(:,2));
        sigstar_LFD([1 2], pFQ_PLLAblation);
subplot(2,2,3)
    plot(ones(N(1,1),1), MedianSpeed(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, MedianSpeed(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(MedianSpeed(:,[1,2])); 
    axis([0.5 2.5 -0.5 8]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Sham', 'PLLAblation'});
    ylabel('Speed (mm.s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pSpeed_PLLAblation = ranksum(MedianSpeed(:,1), MedianSpeed(:,2));
        sigstar_LFD([1 2], pSpeed_PLLAblation);
subplot(2,2,4)
    plot(ones(N(1,1),1), pTurns(:,1), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, pTurns(:,2), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(pTurns(:,[1,2])); 
    axis([0.5 2.5 -0.5 105]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'Sham', 'PLLAblation'});
    ylabel('Turns (%)');
    % stat to see the effect of 5-HT on untreated larvae
        pTurns_PLLAblation = ranksum(pTurns(:,1), pTurns(:,2));
        sigstar_LFD([1 2], pTurns_PLLAblation);
P_MW_PLLAblation_versus_CT = [pSwim_PLLAblation, pFQ_PLLAblation, pSpeed_PLLAblation, pTurns_PLLAblation];
saveas(h2, '211102 - Effect of PLL ablation (10fghijk, 5h or more recovery time without outliers #14, 29, 56, 68, 84).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps

%% 5. plot effect of 5-HT on PLL-ablated larvae only

h3 = figure();
subplot(2,2,1)
    plot(ones(N(1,1),1), Swim(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Swim(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Swim(:,[6,8])); 
    axis([0.5 2.5 -0.5 60]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'PLL', 'PLL+5HT'});
    ylabel('Percentage of time swimming');
    % stat to see the effect of 5-HT on untreated larvae
        pSwim_5HT = ranksum(Swim(:,6), Swim(:,8));
        sigstar_LFD([1 2], pSwim_5HT);
subplot(2,2,2)
    plot(ones(N(1,1),1), FQ(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, FQ(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(FQ(:,[6,8])); 
    axis([0.5 2.5 -0.5 7]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'PLL', 'PLL+5HT'});
    ylabel('FQ (s-1)');
    % stat to see the effect of 5-HT on untreated larvae
        pFQ_5HT = ranksum(FQ(:,6), FQ(:,8));
        sigstar_LFD([1 2], pFQ_5HT);
subplot(2,2,3)
    plot(ones(N(1,1),1), Speed(:,6), 'LineStyle', 'none', 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Speed(:,8), 'LineStyle', 'none', 'Marker', 'o', 'Color', [0.75 0 0], 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Speed(:,[6,8])); 
    axis([0.5 2.5 -0.5 8]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'PLL', 'PLL+5HT'});
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
    xticklabels({'PLL', 'PLL+5HT'});
    ylabel('Turns (%)');
    % stat to see the effect of 5-HT on untreated larvae
        pTurns_5HT = ranksum(Turns(:,6), Turns(:,8));
        sigstar_LFD([1 2], pTurns_5HT);
P_MW_PLL_E3_versus_5HT = [pSwim_5HT, pFQ_5HT, pSpeed_5HT, pTurns_5HT];
saveas(h3, '211129 - Effect of 5-HT on PLL-ablated larvae (10fghijk, 5h or more recovery time without outliers #14, 29, 56, 68, 84).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps

%% 6. save

close all

uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

save(['220430 - Effect of 5-HT on PLLAblated larvae (10fghijk, 5h or more recovery time).mat'], 'DATA_PLLAblation_5HT', 'ID_all', 'Swim', 'FQ', 'Speed', 'Turns', 'Nf');
%'P_ANCOVA_t0_versus_t10', 'P_MW_PLLAblation_versus_CT', 'P_MW_PLL_E3_versus_5HT'