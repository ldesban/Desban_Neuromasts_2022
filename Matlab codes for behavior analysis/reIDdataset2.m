function [datasetBout_ID, datasetFish_ID, N] = reIDdataset2(datasetBout, datasetFish)

datasetBout_ID = datasetBout;
datasetFish_ID = datasetFish;

n = 68;
for f = 1:size(datasetFish,2)
    trial = datasetFish(1,f).Trial_ID;
    fish = datasetFish(1,f).Well_ID;
    datasetFish_ID(1,f).Fish_ID = n;
    [datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trial) & [datasetBout.Well_ID] == fish)).Fish_ID] = deal(n);
    n = n+1;
end

N = n-1;