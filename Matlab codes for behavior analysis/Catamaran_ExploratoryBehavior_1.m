function Catamaran_ExploratoryBehavior_1

%% 1. import the excel file 

overviewFile = uigetfile({'*.xls*'},'File Selector');
overviewBehavior = readtable(overviewFile);

%% 2.  concatenate all output structure tables from Zebrazoom in experiments of interest

datasetPerBout =  struct('Trial_ID', [], 'Well_ID', [], 'Fish_ID', [], 'Condition', [], 'Genotype', [], 'Recovery', [], 'fps', [], 'pixelSize', [], 'Nframes', [], 'NumBout', [], 'Flag', [], 'BoutStart', [], 'BoutEnd', [], 'BoutDuration', [], 'TotalDistance', [], 'Speed', [], 'NumberOfOscillations', [], 'AmplitudeOfAllBends', [], 'InstantaneousTBF', [], 'InstantaneousIBI', [], 'InstantaneousSpeed', [], 'angularVelocity', [], 'TailAngle_smoothed', [], 'HeadX', [], 'HeadY', [], 'Heading', [], 'TailX_VideoReferential', [], 'TailY_VideoReferential', [], 'Bend_Timing', [], 'Bend_Amplitude', [], 'DeltaHead', []);
datasetPerFish = struct('Trial_ID', [], 'Well_ID', [], 'Fish_ID', [], 'Condition', [], 'Genotype', [], 'Recovery', [], 'fps', [], 'pixelSize', [], 'Nframes', [], 'MeanIBI', [], 'NTotBout', [], 'TotalDistanceInActiveMotion', [], 'TotalDistanceActiveMotionAndGliding', [], 'allHeadY', [], 'allHeadX', []);

for i = 1:size(overviewBehavior,1)
  includes = jsondecode(overviewBehavior.include{i});
  file_path = char(overviewBehavior.path(i));
  videoResults = load([file_path char(overviewBehavior.trial_id(i)) '.mat']);
  videoResults.videoDataResults.organization.pixelSize = overviewBehavior.pixelsize(i);
  videoResults.videoDataResults.organization.fps = overviewBehavior.fq(i);
  videoResults.videoDataResults.organization.videoName = char(overviewBehavior.trial_id(i));
  videoResults.videoDataResults.organization.Nframes = overviewBehavior.Nframes(i);
  wellCondition = jsondecode(overviewBehavior.code_condition{i});
  for well = 1:size(wellCondition)
      videoResults.videoDataResults.organization.wellCondition{well} = wellCondition(well);
  end
  genotype = jsondecode(overviewBehavior.code_genotype{i});
  for well = 1:size(genotype)
      videoResults.videoDataResults.organization.genotype{well} = genotype(well);
  end
  recovery = jsondecode(overviewBehavior.RecoveryTime{i});
  for well = 1:size(recovery)
      videoResults.videoDataResults.organization.recovery{well} = recovery(well);
  end
  datasetPerBout = addVideoInExpAggloPerBoutLFD_20210416(datasetPerBout,videoResults,includes);
  datasetPerFish = addVideoInExpAggloPerFishLFD_20210416(datasetPerFish,videoResults,includes);
end

%% 3. add the info about continuous tracking if existing

n = 1; DY = {}; DX = {};
for i = 1:size(overviewBehavior,1)
    file_path = char(overviewBehavior.path(i));
    includes = jsondecode(overviewBehavior.include{i});
    videoResults2 = load([file_path char(overviewBehavior.trial_id(i)) '_ALL.mat']);
    wellPoissMouv = videoResults2.videoDataResults.wellPoissMouv;
    for well = 1:size(wellPoissMouv,1)
        if (includes(well))
            if isempty(videoResults2.videoDataResults.wellPoissMouv{well,1}) ~= 1
                DY = videoResults2.videoDataResults.wellPoissMouv{well,1}.HeadY;
                datasetPerFish(n).allHeadY = DY(1, 1:end-1);
                DX = videoResults2.videoDataResults.wellPoissMouv{well,1}.HeadX;
                datasetPerFish(n).allHeadX = DX(1, 1:end-1);
            else
                datasetPerFish(n).allHeadY = [];
                datasetPerFish(n).allHeadX = [];
            end
            n = n+1;
        end
    end
end

%% 4. Calculate deltahead for each bout

for f = 1:size(datasetPerFish, 2)
    Nb = datasetPerFish(f).NTotBout;
    trial = datasetPerFish(f).Trial_ID;
    fish = datasetPerFish(f).Well_ID;
    Nfr = datasetPerFish(f).Nframes;
    dX = datasetPerFish(f).allHeadX;
    dY = datasetPerFish(f).allHeadY;
    x_bouts = find(strcmp({datasetPerBout.Trial_ID}, trial) & [datasetPerBout.Well_ID] == fish);
    if Nb > 2
        % for 1st bout
            prev_X = dX(1,1:datasetPerBout(x_bouts(1,1)).BoutStart);
            prev_Y = dY(1,1:datasetPerBout(x_bouts(1,1)).BoutStart);
            next_X = dX(1,datasetPerBout(x_bouts(1,1)).BoutEnd:datasetPerBout(x_bouts(1,2)).BoutStart);    
            next_Y = dY(1,datasetPerBout(x_bouts(1,1)).BoutEnd:datasetPerBout(x_bouts(1,2)).BoutStart);    
            p_init = polyfit(prev_X, prev_Y, 1);
            p_fin = polyfit(next_X, next_Y, 1);
            theta_init = atan2(p_init(1,1)*(prev_X(1,end) - prev_X(1,1)), (prev_X(1,end) - prev_X(1,1)))*180/pi;
            theta_fin = atan2(p_fin(1,1)*(next_X(1,end) - next_X(1,1)), (next_X(1,end) - next_X(1,1)))*180/pi;
            datasetPerBout(x_bouts(1,1)).DeltaHead = theta_fin - theta_init;
        for b = 2:Nb-1
            prev_X = dX(1,datasetPerBout(x_bouts(1,b-1)).BoutEnd:datasetPerBout(x_bouts(1,b)).BoutStart);
            prev_Y = dY(1,datasetPerBout(x_bouts(1,b-1)).BoutEnd:datasetPerBout(x_bouts(1,b)).BoutStart);
            next_X = dX(1,datasetPerBout(x_bouts(1,b)).BoutEnd:datasetPerBout(x_bouts(1,b+1)).BoutStart);    
            next_Y = dY(1,datasetPerBout(x_bouts(1,b)).BoutEnd:datasetPerBout(x_bouts(1,b+1)).BoutStart);    
            p_init = polyfit(prev_X, prev_Y, 1);
            p_fin = polyfit(next_X, next_Y, 1);
            theta_init = atan2(p_init(1,1)*(prev_X(1,end) - prev_X(1,1)), (prev_X(1,end) - prev_X(1,1)))*180/pi;
            theta_fin = atan2(p_fin(1,1)*(next_X(1,end) - next_X(1,1)), (next_X(1,end) - next_X(1,1)))*180/pi;
            datasetPerBout(x_bouts(1,b)).DeltaHead = theta_fin - theta_init;
        end
    elseif Nb == 1
            prev_X = dX(1,1:datasetPerBout(x_bouts(1,1)).BoutStart);
            prev_Y = dY(1,1:datasetPerBout(x_bouts(1,1)).BoutStart);
            next_X = dX(1,datasetPerBout(x_bouts(1,1)).BoutEnd:size(dX,2));    
            next_Y = dY(1,datasetPerBout(x_bouts(1,1)).BoutEnd:size(dY,2));    
            p_init = polyfit(prev_X, prev_Y, 1);
            p_fin = polyfit(next_X, next_Y, 1);
            theta_init = atan2(p_init(1,1)*(prev_X(1,end) - prev_X(1,1)), (prev_X(1,end) - prev_X(1,1)))*180/pi;
            theta_fin = atan2(p_fin(1,1)*(next_X(1,end) - next_X(1,1)), (next_X(1,end) - next_X(1,1)))*180/pi;
            datasetPerBout(x_bouts(1,1)).DeltaHead = theta_fin - theta_init;
    end
end
for b = 1:size(datasetPerBout,2)
    DH = datasetPerBout(b).DeltaHead;
    if  DH > 180
        datasetPerBout(b).DeltaHead = 360 - DH;
    elseif DH < -180
        datasetPerBout(b).DeltaHead = -(360 + DH);
    end
end  

% for b = 1:size(datasetPerBout,2)
%     HeadX = datasetPerBout(b).HeadX;
%     HeadY = datasetPerBout(b).HeadY;  
%     if size(HeadX,1) >= 5
%         p_init = polyfit(HeadX(1:5,1), HeadY(1:5,1), 1);
%         p_fin = polyfit(HeadX(end-4:end,1), HeadY(end-4:end,1), 1);
%         theta_init = atan2(p_init(1,1)*(HeadX(4,1)-HeadX(1,1)), HeadX(4,1)-HeadX(1,1))*180/pi;
%         theta_fin = atan2(p_fin(1,1)*(HeadX(end-1,1)-HeadX(end-5,1)), HeadX(end-1,1)-HeadX(end-5,1))*180/pi;
%         delt = theta_fin - theta_init;
%         if delt > 180
%             delt = 360 - delt;
%         elseif delt < -180
%             delt = -(360 + delt);
%         end
%         datasetPerBout(b).DeltaHead = delt;
%     else
%         datasetPerBout(b).DeltaHead = NaN;
%     end        
% end
 
% for b = 1:size(datasetPerBout,2)
%     TailX = datasetPerBout(b).TailX_VideoReferential;
%     HeadX = datasetPerBout(b).HeadX;
%     TailY = datasetPerBout(b).TailY_VideoReferential;
%     HeadY = datasetPerBout(b).HeadY;   
%     bX0 = [TailX(1,end-6:end), HeadX(1,1)];
%     bY0 = [TailY(1,end-6:end), HeadY(1,1)];
%     slope0 = atan2((bY0(1,end)-bY0(1,1)),(bX0(1,end)-bX0(1,1)))*180/pi;
%     bX1 = [TailX(end,end-6:end), HeadX(end,1)];
%     bY1 = [TailY(end,end-6:end), HeadY(end,1)];
%     slope1 = atan2((bY1(1,end)-bY1(1,1)),(bX1(1,end)-bX1(1,1)))*180/pi;
%     delt = -(slope1 - slope0);
%     if delt > 180
%         delt = 360 - delt;
%     elseif delt < -180
%         delt = -(360 + delt);
%     end
%     datasetPerBout(b).DeltaHead = delt;
% end

%% 3. save initial structures

uiwait(msgbox('Choose the folder in which you want to save your datasets?'));
savePath = uigetdir;
cd(savePath);

time = datestr(now);
time = strrep(time,' ','_');
time = strrep(time,':','-');

save(['DatasetPerBout_10fghijk', ' ', time '.mat'],'datasetPerBout');
save(['DatasetPerBout_10fghijk', ' ', time '.mat'],'datasetPerFish');

%% 4. create new structures with new ID of well / fish within the entire dataset

[datasetPerBout_ID, datasetPerFish_ID, Nf] = reIDdataset_baseline(datasetPerBout, datasetPerFish); 
% reIDdataset_recBAPTA, reIDdataset_baseline, reIDdataset2, reIDdataset_CuSO4recovery

%% 5. save new structures

save(['DatasetPerBout_ID_10fghijk', ' ', time '.mat'],'datasetPerBout_ID');
save(['DatasetPerFish_ID_10fghijk', ' ', time '.mat'],'datasetPerFish_ID', 'Nf');

%% 6. filter data and keep fish with only >= 5h of recovery in the datasets

[datasetPerBout_ID_filtered, datasetPerFish_ID_filtered, Nf_filtered] = Dataset_filter(datasetPerBout_ID, datasetPerFish_ID, 5); 

%% 7. save new structures

save(['DatasetPerBout_ID_10fghijk (5h or more recovery time)', ' ', time '.mat'],'datasetPerBout_ID_filtered');
save(['DatasetPerFish_ID_10fghijk (5h or more recovery time)', ' ', time '.mat'],'datasetPerFish_ID_filtered', 'Nf_filtered', 'Nf');
