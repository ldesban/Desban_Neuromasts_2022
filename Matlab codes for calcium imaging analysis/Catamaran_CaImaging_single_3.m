function Catamaran_CaImaging_single_3

%% 1. load the dataset

uiwait(msgbox('Choose the dataset file'));
datasetFile = uigetfile({'*.mat*'},'File Selector');
load(datasetFile, 'dataset');

%% 2. indicate which condition you want to analyze

Code = {'aCSF1', '250然 aa pool1', '250然 aa pool2', '1mM 5-HT', 'skin extract', '250然 aa pool2 w/o Glu', '250然 Glu', '1mM Oleic acid', '100然 2.5-DMP', 'Hypotonic (265 mmol/g)', 'pH 6.2-6.54', 'pH 8.45-8.8', 'pH 5.2-5.3', 'pH 9.48-9.7', '100然 PGF2a', '100然 pHPAA', 'pH 5.2-5.3 post-BAPTA', 'pH 9.48-9.7 post-BAPTA', 'aCSF2', 'aCSF +1% DMSO', 'Mustard oil', '25然 aa pool3'};
uiwait(msgbox('Indicate which condition you want to analyze'));
cond = input('Choose among 1=aa pool1, 2=aa pool2, 3=5-HT, 4=skin extract, 5=aa pool2 w/o Glu, 6=Glu, 7=oleic acid, 8=2,5-DMP, 9=hypotonic, 10=pH 6.2-6.5, 11=pH 8.45-8.8, 12=pH 5.2-5.3, 13=pH 9.48-9.7, 14=PGF2a, 15=pHPAA, 16=pH 5.2-5.3 post BAPTA, 17=pH 9.48-9.7 post BAPTA, 18=aCSF2, 19=aCSF + 1% DMSO, 20=mustard oil, 21=aa pool3: ');

%% 3. generate dataset with data of interest

dataset2 = struct('Experiment_ID', [], 'FrameRate', [], 'Fish', [], 'Trial_ID', [], 'Neuromast_ID', [], 'Condition', [], 'ROI_ID', [], 'ROI', [], 'raw', [], 'raw_ct', []);

% screen for ROIs that were stimulated specifically with cond
D = dataset([dataset.Condition] == cond);

% if control trial with aCSF only exists, add to dataset_cond structure
nc = 1;
for c = 1:size(D,2)
    d_ct = dataset(strcmp([dataset.Experiment_ID], D(c).Experiment_ID) & [dataset.Fish] == D(c).Fish & [dataset.Neuromast_ID] == D(c).Neuromast_ID & [dataset.ROI_ID] == D(c).ROI_ID & [dataset.Condition] == 0);
    if isempty(d_ct) == 0
        dataset2(nc).Experiment_ID = D(c).Experiment_ID;
        f = D(c).FrameRate;
        dataset2(nc).FrameRate = f;
        dataset2(nc).Fish = D(c).Fish;
        dataset2(nc).Trial_ID = D(c).Trial_ID;
        dataset2(nc).Neuromast_ID = D(c).Neuromast_ID;
        dataset2(nc).Condition = Code{cond+1};
        dataset2(nc). ROI_ID = D(c).ROI_ID;
        dataset2(nc).ROI = nc;
        dataset2(nc).raw = D(c).raw;
        dataset2(nc).raw_ct = d_ct.raw;
        nc = nc+1;
    end
end

%% 4. calculate the mean trace over the 3 stimulations 

dataset_cond = getSingleStim(dataset2); 

%% 5. separate cells that respond from cells that do not respond during control trial1 with aCSF only

[dataset_R1, dataset_NR1, Traces_R1, Traces_NR1, Perc_R1] = getRespCells_Trial1_single(dataset_cond, 3);
dataset_R1 = getKinematics_Trial1(dataset_R1, 10); % extracts decay and time to peak for responses over threshold

%% 6. separate cells that respond from cells that do not respond during second trial

% a) among responding cells during trial 1
[dataset_R1_R2, dataset_R1_NR2, Traces_R1_R2, Traces_R1_NR2, Perc_R1_R2] = getRespCells_Trial2_single(dataset_R1, 3);
dataset_R1_R2 = getKinematics_Trial2(dataset_R1_R2, 10); % extracts decay and time to peak for responses over threshold

% b) among non-responding cells during trial 1
[dataset_NR1_R2, dataset_NR1_NR2, Traces_NR1_R2, Traces_NR1_NR2, Perc_NR1_R2] = getRespCells_Trial2_single(dataset_NR1, 3);
dataset_NR1_R2 = getKinematics_Trial2(dataset_NR1_R2, 10); % extracts decay and time to peak for responses over threshold

%% 7. plot

[h1, p_ttp_mech_vs_chem, p_ttp_R1_vs_R2, p_dec_mech_vs_chem, p_dec_R1_vs_R2]  = plot_Resp_vs_NonResp_single(dataset_R1, dataset_NR1, Traces_R1, Traces_NR1, Perc_R1, dataset_NR1_R2, dataset_NR1_NR2, Traces_NR1_R2, Traces_NR1_NR2, Perc_NR1_R2, dataset_R1_R2, dataset_R1_NR2, Traces_R1_R2, Traces_R1_NR2, Perc_R1_R2);

%% 9. save

uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

time = datestr(now);
time = strrep(time,' ','_');
time = strrep(time,':','-');

save(['Dataset_CaImaging_Single_', Code{cond+1}, ' ', time '.mat'], 'dataset_cond', 'dataset_R1', 'dataset_NR1', 'Traces_R1', 'Traces_NR1', 'Perc_R1', 'dataset_NR1_R2', 'dataset_NR1_NR2', 'Traces_NR1_R2', 'Traces_NR1_NR2', 'Perc_NR1_R2', 'dataset_R1_R2', 'dataset_R1_NR2', 'Traces_R1_R2', 'Traces_R1_NR2', 'Perc_R1_R2');
saveas(h1, ['Results_CaImaging_Single_', Code{cond+1}, ' ', time '.fig']);
set(gcf,'renderer','Painters');
print -depsc -tiff -r300 -painters Image.eps
close all
