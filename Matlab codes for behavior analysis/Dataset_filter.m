function [datasetBout_filtered, datasetFish_filtered, N_filtered] = Dataset_filter(datasetBout, datasetFish, filter)

% fields1 = fieldnames(datasetFish);
% datasetFish_filtered = cell2struct(cell(size(fields1)), fields1);
% n = 0; % start counter
% for f = 1:size(datasetFish,2)
%     if datasetFish(f).Recovery >= filter
%         n = n+1;
%         datasetFish_filtered = [datasetFish_filtered, datasetFish(f)];
%     end
% end
% 
% N_filtered = n;
% 
% fields2 = fieldnames(datasetBout);
% datasetBout_filtered = cell2struct(cell(size(fields2)), fields2);
% for f = 1:size(datasetBout,2)
%     if datasetBout(f).Recovery >= filter
%         n = n+1;
%         datasetBout_filtered = [datasetBout_filtered, datasetBout(f)];
%     end
% end

datasetFish_filtered = datasetFish([datasetFish.Recovery] >= filter);
N_filtered = size(datasetFish_filtered,2)/2;
datasetBout_filtered = datasetBout([datasetBout.Recovery] >= filter);
