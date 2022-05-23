function Catamaran_ExploratoryBehavior_3_homogenous5HT

%% 1. load data

uiwait(msgbox('Choose the data file you want to plot from'));
[filename1, path1] = uigetfile({'*.mat*'},'File Selector');
load([path1 '\' filename1]);

% Specify outliers
Outliers = zeros(N(1,1),1);
out = input('Vector of the Fish_ID of outliers');
if isempty(out) == 0
    Outliers(out,1) = 1;
end

%% 2. reorganize data into one matrix called DATA_5HT

DATA_5HT = struct('Trial_ID', [], 'Fish_ID', [], 'Condition', [], 'Outlier', [], 'Swim_t0', [], 'Swim_t10', [], 'FQ_t0', [], 'FQ_t10', [], 'Speed_t0', [], 'Speed_t10', [], 'Turns_t0', [], 'Turns_t10', []);

ID_CT = [datasetPerFish_ID([datasetPerFish_ID.Condition] == 1).Fish_ID];
ID_CT(2,:) = deal(1);
ID_5HT = [datasetPerFish_ID([datasetPerFish_ID.Condition] == 2).Fish_ID];
ID_5HT(2,:) = deal(2);
ID_all = [ID_CT ID_5HT];

Swim = nan(N(1,1),4);
FQ  = nan(N(1,1),4);
Speed = nan(N(1,1),4);
Turns = nan(N(1,1),4);

for f = 1:N(1,1)
    DATA_5HT(f,1).Trial_ID = datasetPerFish_ID([datasetPerFish_ID.Fish_ID] == ID_all(1,f) & [datasetPerFish_ID.Condition] == 0).Trial_ID;
    DATA_5HT(f,1).Fish_ID = ID_all(1,f);
    DATA_5HT(f,1).Outlier = Outliers(ID_all(1,f),1);
    if ID_all(2,f) == 1
        DATA_5HT(f,1).Condition = 'E3';
        j = 2;
    elseif ID_all(2,f) == 2
        DATA_5HT(f,1).Condition = '5-HT';
        j = 3;
    end
    DATA_5HT(f,1).Swim_t0 = pSwim(ID_all(1,f),1);
    DATA_5HT(f,1).Swim_t10 = pSwim(ID_all(1,f),j);
    DATA_5HT(f,1).FQ_t0 = 1000/MedianIBI(ID_all(1,f),1);
    DATA_5HT(f,1).FQ_t10 = 1000/MedianIBI(ID_all(1,f),j);
    DATA_5HT(f,1).Speed_t0 = MedianSpeed(ID_all(1,f),1);
    DATA_5HT(f,1).Speed_t10 = MedianSpeed(ID_all(1,f),j);
    DATA_5HT(f,1).Turns_t0 = pTurns(ID_all(1,f),1);
    DATA_5HT(f,1).Turns_t10 = pTurns(ID_all(1,f),j);
    if Outliers(ID_all(1,f),1) == 0
        j2 = (ID_all(2,f)-1)*2+1;
        Swim(f,j2) = pSwim(ID_all(1,f),1);
        Swim(f,j2+1) = pSwim(ID_all(1,f),j);
        FQ(f,j2) = 1000/MedianIBI(ID_all(1,f),1);
        FQ(f,j2+1) = 1000/MedianIBI(ID_all(1,f),j);
        Speed(f,j2) = MedianSpeed(ID_all(1,f),1);
        Speed(f,j2+1) = MedianSpeed(ID_all(1,f),j);
        Turns(f,j2) = pTurns(ID_all(1,f),1);
        Turns(f,j2+1) = pTurns(ID_all(1,f),j);
    end
end
        
%% 3. plot

Nf = [sum(~isnan(Swim(:,1))); sum(~isnan(Swim(:,3)))];

h1 = figure();
subplot(2,2,1)
    for i = 1:size(Swim,1)
        plot([1 2], [Swim(i,1) Swim(i,2)], 'o--', 'Color', [0.75 0.75 0.75], 'MarkerSize', 8);hold on
    end
    for i = 1:size(Swim,1)
        plot([3 4], [Swim(i,3) Swim(i,4)], 'o--', 'Color', [0 0.75 0], 'MarkerSize', 8);hold on
    end
    jitter;
    plot([1 2], [nanmean(Swim(:,1),1) nanmean(Swim(:,2),1)], 'o-k', 'LineWidth', 4, 'MarkerSize', 10);
    plot([3 4], [nanmean(Swim(:,3),1) nanmean(Swim(:,4),1)], 'o-g', 'LineWidth', 4, 'MarkerSize', 10);
    boxplot(Swim);
    axis([0.5 4.5 -0.5 60]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
    xticklabels({'Control', '5HT'});
    ylabel('Time spent swimming (%)');
        p = ranksum(Swim(:,1), Swim(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Swim(:,1); Swim(:,3)];
            y10 = [Swim(:,2); Swim(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSwim = cell2mat(a(2,6));
                aSwim = a;
                sigstar_LFD([1.5 3.5], pSwim);
            else
                pSwim = NaN; aSwim = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSwim = NaN; aSwim = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,2)
    for i = 1:size(FQ,1)
        plot([1 2], [FQ(i,1) FQ(i,2)], 'o--', 'Color', [0.75 0.75 0.75], 'MarkerSize', 8);hold on
    end
    for i = 1:size(FQ,1)
        plot([3 4], [FQ(i,3) FQ(i,4)], 'o--', 'Color', [0 0.75 0], 'MarkerSize', 8);hold on
    end
    jitter;
    plot([1 2], [nanmean(FQ(:,1),1) nanmean(FQ(:,2),1)], 'o-k', 'LineWidth', 4, 'MarkerSize', 10);
    plot([3 4], [nanmean(FQ(:,3),1) nanmean(FQ(:,4),1)], 'o-g', 'LineWidth', 4, 'MarkerSize', 10);
    boxplot(FQ);
    axis([0.5 4.5 0 6]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
    xticklabels({'Control', '5HT'});
    ylabel('FQ (s-1)');
        p = ranksum(FQ(:,1), FQ(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [FQ(:,1); FQ(:,3)];
            y10 = [FQ(:,2); FQ(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pFQ = cell2mat(a(2,6));
                aFQ = a;
                sigstar_LFD([1.5 3.5], pFQ);
            else
                pFQ = NaN; aFQ = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pFQ = NaN; aFQ = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,3)
    for i = 1:size(Speed,1)
        plot([1 2], [Speed(i,1) Speed(i,2)], 'o--', 'Color', [0.75 0.75 0.75], 'MarkerSize', 8);hold on
    end
    for i = 1:size(Speed,1)
        plot([3 4], [Speed(i,3) Speed(i,4)], 'o--', 'Color', [0 0.75 0], 'MarkerSize', 8);hold on
    end
    jitter;
    plot([1 2], [nanmean(Speed(:,1),1) nanmean(Speed(:,2),1)], 'o-k', 'LineWidth', 4, 'MarkerSize', 10);
    plot([3 4], [nanmean(Speed(:,3),1) nanmean(Speed(:,4),1)], 'o-g', 'LineWidth', 4, 'MarkerSize', 10);
    boxplot(Speed);
    axis([0.5 4.5 0 15]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
    xticklabels({'Control', '5HT'});
    ylabel('Speed (mm.s-1)');
        p = ranksum(Speed(:,1), Speed(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Speed(:,1); Speed(:,3)];
            y10 = [Speed(:,2); Speed(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pSpeed = cell2mat(a(2,6));
                aSpeed = a;
                sigstar_LFD([1.5 3.5], pSpeed);
            else
                pSpeed = NaN; aSpeed = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pSpeed = NaN; aSpeed = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
subplot(2,2,4)
    for i = 1:size(Turns,1)
        plot([1 2], [Turns(i,1) Turns(i,2)], 'o--', 'Color', [0.75 0.75 0.75], 'MarkerSize', 8);hold on
    end
    for i = 1:size(Turns,1)
        plot([3 4], [Turns(i,3) Turns(i,4)], 'o--', 'Color', [0 0.75 0], 'MarkerSize', 8);hold on
    end
    jitter;
    plot([1 2], [nanmean(Turns(:,1),1) nanmean(Turns(:,2),1)], 'o-k', 'LineWidth', 4, 'MarkerSize', 10);
    plot([3 4], [nanmean(Turns(:,3),1) nanmean(Turns(:,4),1)], 'o-g', 'LineWidth', 4, 'MarkerSize', 10);
    boxplot(Turns);
    axis([0.5 4.5 -0.5 100]); set(gca, 'xtick', 1.5:2:3.5); set(gca, 'tickdir', 'out');
    xticklabels({'Control', '5HT'});
    ylabel('Proportion of turns (%)');
        p = ranksum(Turns(:,1), Turns(:,3));
        if p > 0.05
            x = [zeros(N(1,1),1); ones(N(1,1),1)];
            y0 = [Turns(:,1); Turns(:,3)];
            y10 = [Turns(:,2); Turns(:,4)];
            [h,a,c,s] = aoctool(y0, y10, x);
            if cell2mat(a(4,6)) > 0.05
                pTurns = cell2mat(a(2,6));
                aTurns = a;
                sigstar_LFD([1.5 3.5], pTurns);
            else
                pTurns = NaN; aTurns = NaN;
                uiwait(msgbox('Non homogenous regression!'));
            end
        else
            pTurns = NaN; aTurns = NaN;
            uiwait(msgbox('The baseline between the 2 groups is significantly different'));    
        end
P = [pSwim pFQ pSpeed pTurns];
saveas(h1, '220311 - Effect of 5-HT (3bd4a5gh, without outliers #40,43,62,83,95).fig');
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps

%% 3. save

close all
uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

save(['220311 - Effect of 5-HT (3bd4a5gh, without outliers #40,43,62,83,95).mat'], 'DATA_5HT', 'Outliers', 'ID_all', 'Swim', 'FQ', 'Speed', 'Turns', 'Nf');
%, 'P', 'aSwim', 'aFQ', 'aSpeed', 'aTurns'