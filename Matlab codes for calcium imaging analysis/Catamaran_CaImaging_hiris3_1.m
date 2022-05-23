function Catamaran_CaImaging_hiris3_1

%% 1. Set dir to files of interest (calcium imaging & reference frame)

% set dir for green channel (GCaMP5G)
uiwait(msgbox('Choose the .tif recording to analyze'));
[movieG, folder1] = uigetfile('*.tif*', 'File Selector');
Gtrace = strcat(folder1, movieG);
% set dir to the average file to select ROIS (over the 50 first frames)
uiwait(msgbox('Choose the corresponding AVG image'));
[image, folder2] = uigetfile('*.tif*', 'File Selector');
AVGGtrace = strcat(folder2, image);

%% 2. Proceed to registration to avoid motion artefacts

AVG = multitiff2M(AVGGtrace, 1:1);
Nf = 1050; % total number of frames
f = 5; % frame rate of acquisition
Nf_sweep = 350; % number of frames per sweep
Nsweep = 3; % number of sweeps
G = multitiff2M(Gtrace,1:Nf);
[G_r] = registerfilm_allFrame_onlyG(G,AVG);

%% 3. Select ROI to substract background and ROIs to select hair cells

figure();
avg = uint8(AVG);
imshow(avg);

% select ROI for background
disp('Select ROI in background')
bg = getROIcell;
% select ROIS
disp('Choose ROIs')
rois = getROIcell;
Nrois = size(rois,2);
close all

% calculate & substract background signal
Maskbg = roipoly(G_r,bg{1,1}(:,1),bg{1,1}(:,2));
for i = 1:Nf
    g = G_r(:,:,i);
    mg = floor(mean(g(Maskbg))) - 1;
    G_r2(:,:,i) = G_r(:,:,i) - mg;
end

%%  4. calculate the Raw and DFF for each ROI, click for baseline on each ROI

for i=1:size(rois,2) 
    Mask{i} = roipoly(G_r2,rois{i}(:,1),rois{i}(:,2));
end

[dff, raw] = calc_dff(G_r2, Mask, size(rois,2));

save('RawData.mat', 'G', 'G_r', 'G_r2', 'AVG', 'Nf', 'f', 'Nsweep', 'Nf_sweep', 'rois', 'Nrois', 'Mask', 'dff', 'raw');
    
%% 5. Synchronize recording onset to stimulus onset

% Get the clampex file with the traces
file = uigetfile('.abf');
trace = abfload(file);

% Select specifically the camera trace
T_camera = trace(:,3,1);
% Find the onset of camera as a TTL input
D = 0;
i = 0;
while D < 1
    i = i+1;
    D = abs(T_camera(i+1,1) - T_camera(i,1));
end
camera_onset = i+1; % TTL input lasts for 1s = 10000 positions in T

% Select specifically the stimulus trace
T_stim = trace(:,2,1);
% Find the onset of stimulus as a TTL input
D = 0;
i = 0;
while D < 1
    i = i+1;
    D = abs(T_stim(i+1,1) - T_stim(i,1));
end
stim_onset = i+1; 

% Reshape the calcium imaging files accordingly by filling out missed frames at the begining
% (by duplicating first frame enough times) and cutting the last extra frames
% to obtain a total of 3 sweeps of 350 frames each, with stimulus of 1s after 10s of baseline
Nmiss = floor(round(camera_onset/10000,4)*f);
for i = 1:size(rois,2)
	miss_raw(1:Nmiss,1) = raw(1,i);
	miss_dff(1:Nmiss,1) = dff(1,i);
	raw2(:,i) = [miss_raw; raw(1:end-Nmiss,i)];
	dff2(:,i) = [miss_dff; dff(1:end-Nmiss,i)];
	for j = 1:Nsweep
        raw_single(:,j,i) = raw2(1+Nf_sweep*(j-1):Nf_sweep*j,i);
        dff_single(:,j,i) = dff2(1+Nf_sweep*(j-1):Nf_sweep*j,i);
    end
end
    
%% 6. plot the raw and DFF data
    
h1 = figure();
for i=1:size(rois,2)
	subplot(round(size(rois,2)/2),4,i);
	plot(dff2(:,i)); 
	title(['DFF GCaMP for ROI' num2str(i)]);
	hold on; 
	line([50 55], [max(dff2(:,i))+20 max(dff2(:,i))+20], 'Color', 'b', 'LineWidth', 7);hold on;
	line(Nf_sweep+[50 55], [max(dff2(:,i))+20 max(dff2(:,i))+20], 'Color', 'b', 'LineWidth', 7);hold on;
	line(2*Nf_sweep+[50 55], [max(dff2(:,i))+20 max(dff2(:,i))+20], 'Color', 'b', 'LineWidth', 7);hold on;
end
saveas(h1,'dff GCaMP for ROIs.fig');

h2 = figure();
for i=1:size(rois,2)
	subplot(round(size(rois,2)/2),4,i);
	plot(raw2(:,i)); 
	title(['RAW GCaMP for ROI' num2str(i)]);
	hold on; 
	line([50 55], [max(raw2(:,i))+20 max(raw2(:,i))+20], 'Color', 'b', 'LineWidth', 7);
	line(Nf_sweep+[50 55], [max(raw2(:,i))+20 max(raw2(:,i))+20], 'Color', 'b', 'LineWidth', 7);
	line(2*Nf_sweep+[50 55], [max(raw2(:,i))+20 max(raw2(:,i))+20], 'Color', 'b', 'LineWidth', 7);
	hold on;
end
saveas(h2,'Raw GCaMP for ROI.fig');
          
%% 6. Calculate the increase between pre and post-stim

for i = 1:size(rois,2)
    for j = 1:Nsweep
        M_dff = max([dff2(5*f+(j-1)*Nf_sweep:16*f+(j-1)*Nf_sweep,i)]); x_dff(i,j) = find([dff2(5*f+(j-1)*Nf_sweep:16*f+(j-1)*Nf_sweep,i)] == M_dff)+5*f+(j-1)*Nf_sweep-1;
        EffectSize_dff(i,j) = nanmean(dff2(x_dff(i,j)-2:+x_dff(i,j)+2,i),1)-nanmean(dff2(3*f+(j-1)*Nf_sweep:4*f+(j-1)*Nf_sweep-1,i),1);
        M_raw = max([raw2(5*f+(j-1)*Nf_sweep:16*f+(j-1)*Nf_sweep,i)]); x_raw(i,j) = find([raw2(5*f+(j-1)*Nf_sweep:16*f+(j-1)*Nf_sweep,i)] == M_raw)+5*f+(j-1)*Nf_sweep-1;
        EffectSize_raw(i,j) = nanmean(raw2(x_raw(i,j)-2:+x_raw(i,j)+2,i),1)-nanmean(raw2(3*f+(j-1)*Nf_sweep:4*f+(j-1)*Nf_sweep-1,i),1);
    end
end

save('Analysis.mat', 'Mask', 'dff', 'dff2', 'raw', 'raw2', 'dff_single', 'raw_single', 'EffectSize_dff', 'EffectSize_raw', 'x_dff', 'x_raw', 'camera_onset', 'stim_onset');

%% 7. plot results for effect size

h3 = figure();
for i = 1:size(rois,2)
    subplot(1,2,1);
    plot(EffectSize_dff(i,:), 'o-');hold on;
    title(['Effect size of stimulation - dff']);
    set(gca, 'xtick', [1:3]);set(gca, 'xticklabel', {'Stim1' 'Stim2' 'Stim3'});
    axis square
    subplot(1,2,2);
    plot(EffectSize_raw(i,:), 'o-');hold on;
    title(['Effect size of stimulation - raw']);
    set(gca, 'xtick', [1:3]);set(gca, 'xticklabel', {'Stim1' 'Stim2' 'Stim3'});
    axis square
end
saveas(h3,'Size effect across stimulations.fig');

%% 8. save ROI image

h4 = figure();
imshow(AVG);
for i=1:(size(rois,2))
    patch(rois{1,i}(:,1),rois{1,i}(:,2), 'c', 'FaceAlpha', 0.25);
    text(rois{1,i}(1,1),rois{1,i}(1,2), num2str(i) ,'Color','w');
end
title('selected ROIs','FontSize', 18);
saveas(h4,'ROIS.fig');
saveas(h4,'ROIS.png');

close all
