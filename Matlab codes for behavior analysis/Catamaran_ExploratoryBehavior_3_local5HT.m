function Catamaran_ExploratoryBehavior_3_local5HT

%% 1. load data

uiwait(msgbox('Choose the Analyzed file'));
[filename, path] = uigetfile({'*.mat*'},'File Selector');
load([path '\' filename]);

Outliers = zeros(N(1,1),1);
out = input('Vector of the Fish_ID of outliers');
if isempty(out) == 0
    Outliers(out,1) = 1;
end

%% 2. reorganize data into one matrix called DATA

DATA_local_5HT = struct('Trial_ID', [], 'Fish_ID', [], 'Condition', [], 'Outlier', [], 'Swim', [], 'FQ', [], 'Speed', [], 'Turns', [], 'allHeadX', [], 'allHeadY', []);

ID_CT = [datasetPerFish_ID([datasetPerFish_ID.Condition] == 0 & [datasetPerFish_ID.Genotype] == 0).Fish_ID];
ID_CT(2,:) = deal(0);
ID_5HT = [datasetPerFish_ID([datasetPerFish_ID.Condition] == 1 & [datasetPerFish_ID.Genotype] == 0).Fish_ID];
ID_5HT(2,:) = deal(1);
ID_all = [ID_CT ID_5HT];

Swim = nan(N(1,1),2);
FQ = nan(N(1,1),2);
Speed = nan(N(1,1),2);
Turns = nan(N(1,1),2);

for f = 1:N(1,1)
    DATA_local_5HT(f,1).Trial_ID = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f) & [datasetPerFish_ID.Condition] == ID_all(2,f)).Trial_ID;
    DATA_local_5HT(f,1).Fish_ID = ID_all(1,f);
    DATA_local_5HT(f,1).Outlier = Outliers(ID_all(1,f),1);
    if ID_all(2,f) == 0
        DATA_local_5HT(f,1).Condition = 'E3';
        j = 1;
    elseif ID_all(2,f) == 1
        DATA_local_5HT(f,1).Condition = 'Local 5-HT';
        j = 2;
    end
    DATA_local_5HT(f,1).Swim = pSwim(ID_all(1,f),j);
    DATA_local_5HT(f,1).FQ = 1000/MedianIBI(ID_all(1,f),j);  
    DATA_local_5HT(f,1).Speed = MedianSpeed(ID_all(1,f),j);
    DATA_local_5HT(f,1).Turns = pTurns(ID_all(1,f),j);    
    DATA_local_5HT(f,1).allHeadX = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f)).allHeadX;
    DATA_local_5HT(f,1).allHeadY = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f)).allHeadY;
    if Outliers(ID_all(1,f),1) == 0
        Swim(f,j) = pSwim(ID_all(1,f),j);
        FQ(f,j) = 1000/MedianIBI(ID_all(1,f),j);   
        Speed(f,j) = MedianSpeed(ID_all(1,f),j);
        Turns(f,j) = pTurns(ID_all(1,f),j);
    end
end

%% 3. plot

Nf = [sum(~isnan(Swim),1)];

% 1/ plot global effects on speed and IBI of presence of local 5-HT
h1 = figure();
subplot(2,2,1)
    plot(ones(N(1,1),1), Swim(:,1), 'ok', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Swim(:,2), 'ok', 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Swim);
    axis([0.5 2.5 -0.5 105]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'E3', 'local 5HT'});
    ylabel('Percentage of time spent swimming');
    pSwim = ranksum(Swim(:,1), Swim(:,2));
    sigstar_LFD([1 2], pSwim);
subplot(2,2,2)
    plot(ones(N(1,1),1), FQ(:,1), 'ok', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, FQ(:,2), 'ok', 'MarkerSize', 8); hold on;
    jitter;
    boxplot(FQ);
    axis([0.5 2.5 -0.5 6]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'E3', 'local 5HT'});
    ylabel('FQ (s-1)');
    pFQ = ranksum(FQ(:,1), FQ(:,2));
    sigstar_LFD([1 2], pFQ);
subplot(2,2,3)
    plot(ones(N(1,1),1), Speed(:,1), 'ok', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Speed(:,2), 'ok', 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Speed);
    axis([0.5 2.5 -0.5 10]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'E3', 'local 5HT'});
    ylabel('Speed (mm.s-1)');
    pSpeed = ranksum(Speed(:,1), Speed(:,2));
    sigstar_LFD([1 2], pSpeed);
subplot(2,2,4)
    plot(ones(N(1,1),1), Turns(:,1), 'ok', 'MarkerSize', 8); hold on;
    plot(ones(N(1,1),1)*2, Turns(:,2), 'ok', 'MarkerSize', 8); hold on;
    jitter;
    boxplot(Turns);
    axis([0.5 2.5 0 105]); set(gca, 'xtick', 1:2); set(gca, 'tickdir', 'out');
    xticklabels({'E3', 'local 5HT'});
    ylabel('Turns (%)');
    pTurns = ranksum(Turns(:,1), Turns(:,2));
    sigstar_LFD([1 2], pTurns);
saveas(h1, '220405 - Global effects of local 5HT (6abc8ab, without outliers #55,57,112)');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps
P_MW_CT_versus_local5HT = [pSwim, pFQ, pSpeed, pTurns];

% % 2/ plot area of exploration of each larva color-coded depending on parameter of choice (speed, IBI, ... etc) 
% trials = unique([{DATA_local_5HT.Trial_ID}])';
% for t = 1:size(trials,1)
%     h = plotExplorationXParam_local5HT(datasetPerBout_ID(find(strcmp({datasetPerBout_ID.Trial_ID}, trials(t,1)))), code_condition, 'Speed');    
%     saveas(h, char(join(['191107 - Exploration of individual larvae colorcoded according to speed in' trials(t,1) '.fig'])));
% end
% close all

% 3/ plot graphs of distribution of parameter of choice depending on localization in well
[h2, distrSpeed, distr_ID, P_Speed] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'Speed', 2, Outliers);
saveas(h2, '220405 - Local effects on MEAN speed of local 5-HT (every 2cm, 6abc8ab, without outliers #55,57,112).fig');
[h3, distrFQ, distr_ID, P_FQ] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'FQ', 2, Outliers);
saveas(h3, '220405 - Local effects on MEAN frequency of local 5-HT (every 2 cm, 6abc8ab, without outliers #55,57,112).fig');
[h4, distrTime, distr_ID, P_Time] = plotParamInX_local5HT(datasetPerFish_ID, code_condition, N(1,1), 'Time', 2, Outliers);
saveas(h4, '220405 - Local effects on time spent (every 2 cm, 6abc8ab, without outliers #55,57,112).fig');
[h5, distrTurns, distr_ID, P_Turns] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'Turns', 2, Outliers);
saveas(h5, '220405 - Local effects on routine turn MEAN proportion (every 2 cm, 6abc8ab, without outliers #55,57,112).fig');

% 4/ plot graphs of distribution of parameter of choice depending on distance from the source of 5-HT
% [h, distrSpeed14, distr_ID, p] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'Speed', 1);
% [h7, distrSpeed2, P_Speed2] = plotsymParamInX_local5HT(distrSpeed14, distr_ID, 'Speed');
% saveas(h7, '191122 - Local effects on speed away from local 5-HT (every 1 cm, 6abc 8ab).fig');
% [h, distrIBI14, distr_ID, p] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'IBI', 1);
% [h8, distrIBI2, P_IBI2] = plotsymParamInX_local5HT(distrIBI14, distr_ID, 'IBI');
% saveas(h8, '191122 - Local effects on log(IBI) away from local 5-HT (every 1 cm, 6abc 8ab).fig');
% [h, distrTime14, distr_ID, p] = plotParamInX_local5HT(datasetPerFish_ID, code_condition, N(1,1), 'Time', 1);
% [h9, distrTime2, P_Time2] = plotsymParamInX_local5HT(distrTime14, distr_ID, 'Time');
% saveas(h9, '191122 - Local effects on time spent away from the local 5-HT (every 1 cm, 6abc 8ab).fig');
% [h, distrTurns14, distr_ID, p] = plotParamInX_local5HT(datasetPerBout_ID, code_condition, N(1,1), 'Turns', 1);
% [h10, distrTurns2, P_Turns2] = plotsymParamInX_local5HT(distrTurns14, distr_ID, 'Turns');
% saveas(h10, '191122 - Local effects on routine turn proportion away from the local 5-HT (every 1 cm, 6abc 8ab).fig');
% [h, distrPercEdge14, distr_ID, p] = plotParamInX_local5HT(datasetPerFish_ID, code_condition, N(1,1), 'PercEdge', 1);
% [h12, distrPercEdge2, P_PercEdge2] = plotsymParamInX_local5HT(distrPercEdge14, distr_ID, 'PercEdge');
% saveas(h12, '191122 - Local effects on percentage of time spent on the edge away from the local 5-HT (every 1 cm, 6abc 8ab).fig');

%% 4. save

close all
uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

save(['220405 - Effects of local 5-HT (6abc8ab, without outliers #55,57,112).mat'], 'DATA_local_5HT', 'Outliers', 'ID_all', 'Swim', 'FQ', 'Speed', 'Turns', 'Nf', 'distr_ID', 'distrSpeed', 'distrFQ', 'distrTurns', 'P_Speed', 'P_FQ', 'P_Turns', 'P_MW_CT_versus_local5HT');
