function Catamaran_CaImaging_2_210604

%% 1. import the excel file 

overviewFile = uigetfile({'*.xls*'},'File Selector');
overview = readtable(overviewFile);

%% 2. concatenate all 'analysis.mat' files in experiments of interest

dataset = struct('Experiment_ID', [], 'FrameRate', [], 'StimOnset', [], 'Fish', [], 'Trial_ID', [], 'Neuromast_ID', [], 'Condition', [], 'ROI_ID', [], 'dff', [], 'raw', [], 'x_peak_dff', [], 'EffectSize_dff',[], 'x_peak_raw', [], 'EffectSize_raw',[]);

n = 1; % counter
for i = 1:size(overview,1)
    if overview.include(i) == 1
        file_path = char(overview.path(i));
        %load the analysis matlab file for this trial
        load([file_path 'Analysis.mat']);
        %load data for each ROI from this file
        ncells = size(dff2,2); % take the number of ROIs
        for j = 1:ncells
            dataset(n).Experiment_ID = overview.experiment_id(i);
            dataset(n).FrameRate = overview.frequency(i);
            dataset(n).StimOnset = stim_onset;
            dataset(n).Fish = overview.fish_id(i);
            dataset(n).Trial_ID = char(overview.test_id(i));
            dataset(n).Neuromast_ID = overview.neuromast_id(i);
            dataset(n).Condition = overview.code_analysis(i);
            dataset(n).ROI_ID = j;
            dataset(n).dff = dff2(1:end,j)';
            dataset(n).raw = raw2(1:end,j)';
            % re-calculate peak and effect size for each stim 
            [x, EffectSize] = findxpeak(dff_single(:,:,j), round(stim_onset/10000), overview.frequency(i));
            dataset(n).x_peak_dff = x;
            dataset(n).EffectSize_dff = EffectSize;
            [x, EffectSize] = findxpeak(raw_single(:,:,j), round(stim_onset/10000), overview.frequency(i));
            dataset(n).x_peak_raw = x;
            dataset(n).EffectSize_raw = EffectSize;
            n = n+1;
        end
    end
end

%% 3. save in the folder of your choice

uiwait(msgbox('Choose the folder in which you want to save your dataset'));
savePath = uigetdir;
cd(savePath);

time = datestr(now);
time = strrep(time,' ','_');
time = strrep(time,':','-');

save(['Dataset_CaImaging_Antago', ' ', time '.mat'], 'dataset');