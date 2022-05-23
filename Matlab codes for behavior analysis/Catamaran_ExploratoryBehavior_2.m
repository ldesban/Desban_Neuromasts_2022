function Catamaran_ExploratoryBehavior_2

%% 1. load datasets of interest

uiwait(msgbox('Choose the datasetPerBout file you want to analyze'));
[filename1, path1] = uigetfile({'*.mat*'},'File Selector');
load([path1 '\' filename1]);
uiwait(msgbox('Choose the datasetPerFish file you want to analyze'));
[filename2, path2] = uigetfile({'*.mat*'},'File Selector');
load([path2 '\' filename2]);

%% 2. calculate general parameters

G = unique([datasetPerFish_ID.Genotype]); Ng = size(G,2); % number of genotypes / treatments (wild-type versus others)
code_genotype = cell(1,Ng);
for g = 1:Ng
    code_genotype(1,g) = cellstr(input(['What is the genotype ' num2str(G(1,g)) '? ']));
end
C = unique([datasetPerFish_ID.Condition]); Nc = size(C,2); % number of conditions (control medium versus others)
code_condition = cell(1,Nc);
for c = 1:Nc
    code_condition(1,c) = cellstr(input(['What is the condition ' num2str(C(1,c)) '? ']));
end

N = [Nf Nc Ng]; % N is a vector recapitulating Nf = Number of fish, Nc = Number of conditions and Ng = Number of genotypes

%% 3. generate two matrices explaining the organizing of the output data (called Org) and indicating the index of Fish in output data (called Index fish)

Org = nan(2,Nc*Ng); % line 1 explains test condition, line 2 explains genotype
for c = 1:Nc
    cond = C(1,c);
    for g = 1:Ng
        gen = G(g);
        Org(1,gen+1+cond*Ng) = cond;
        Org(2,gen+1+cond*Ng) = gen;
    end
end
Index = nan(Nf,Nc*Ng);
for n = 1:size(datasetPerFish_ID,2)
    data_f = datasetPerFish_ID(1,n);
    f_ID = data_f(1).Fish_ID;
    f_G = data_f(1).Genotype;
    f_C = data_f(1).Condition;
    Index(f_ID, f_G+1+f_C*Ng) = f_ID;
    Index(f_ID, f_G+1+f_C*Ng) = f_ID;
end
Nfgc = nan(1,Nc*Ng);
for c = 1:Nc
    for g = 1:Ng
        Nfgc(1,g+(c-1)*Ng) = sum(~isnan(Index(:,g+(c-1)*Ng)));
    end
end

%% 4. calculation global swimming parameters

% total number of bouts
[h1, NBouts] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'bouts');    
saveas(h1, '220430 - Total number of bouts during exploration (10fghijk).fig');

% percentage of time spent swimming
[h7, pSwim] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'swim');
saveas(h7, '220430 - Percentage of time spent swimming (10fghijk).fig');

% mean IBI
[h2, MedianIBI] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'IBI');
saveas(h2, '220430 - Median IBI (in ms)(10fghijk).fig');

% mean bout speed
[h3, MedianSpeed] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'speed');
saveas(h3, '220430 - Median bout speed (in mm.s-1)(10fghijk).fig');

% mean bout duration 
[h4, MeanBoutDur] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'boutduration');
saveas(h4, '220430 - Mean bout duration (in ms)(10fghijk).fig');

% mean bout distance
[h5, DistPerBout] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'distbout');
saveas(h5, '220430 - Average distance travelled during bouts (in mm)(10fghijk).fig');

% proportion of turns
[h6, pTurns] = plotparam_final(datasetPerFish_ID, datasetPerBout_ID, code_condition, code_genotype, N, 'turns');
saveas(h6, '220430 - Proportion of turns (10fghijk).fig');


%% 5. plot distribution over time

% for bouts
% plotDistribution(datasetPerBout_ID, code_genotype, code_condition, 'bouts', 30); % input parameter can be 'bouts', 'IBIs'

% for IBIs
% plotDistribution(datasetPerBout_ID, code_genotype, code_condition, 'IBIs', 30); % input parameter can be 'bouts', 'IBIs'

% for speed
%plotDistribution(datasetPerBout_ID, code_genotype, code_condition, 'boutspeed', 30); % input parameter can be 'bouts', 'IBIs', 'boutspeed'
 
%% 6. save the final output of analyzed data

% Outliers = zeros(N(1,1),1);
% out = input('Vector of the Fish_ID of outliers');
% if isempty(out) == 0
%     Outliers(out,1) = 1;
% end

close all

uiwait(msgbox('Choose the folder in which you want to save your analyzed data?'));
savePath = uigetdir;
cd(savePath);

time = datestr(now);
time = strrep(time,' ','_');
time = strrep(time,':','-');

save(['Analyzed data (10fghijk)', ' ', time '.mat'], 'datasetPerFish_ID', 'datasetPerBout_ID', 'code_condition', 'code_genotype', 'N', 'Org', 'Index', 'Nfgc', 'NBouts', 'pSwim', 'MedianIBI', 'MedianSpeed', 'MeanBoutDur', 'DistPerBout', 'pTurns');