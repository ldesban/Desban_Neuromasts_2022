function [datasetBout_ID, datasetFish_ID, N] = reIDdataset_recBAPTA(datasetBout, datasetFish)

trialsTot = unique({datasetFish.Trial_ID});

datasetBout_ID = datasetBout;
datasetFish_ID = datasetFish;

n = 1; % start counter

for t = 1:3:size(trialsTot,2)
    fish = unique([datasetFish(find(strcmp({datasetFish.Trial_ID},trialsTot{1,t}))).Well_ID]);
    for f = 1:size(fish,2)
        [datasetFish_ID(find(strcmp({datasetFish.Trial_ID},trialsTot{1,t}) & [datasetFish.Well_ID] == fish(f))).Fish_ID] = deal(n);
        [datasetFish_ID(find(strcmp({datasetFish.Trial_ID},trialsTot{1,t+1}) & [datasetFish.Well_ID] == fish(f))).Fish_ID] = deal(n);
        [datasetFish_ID(find(strcmp({datasetFish.Trial_ID},trialsTot{1,t+2}) & [datasetFish.Well_ID] == fish(f))).Fish_ID] = deal(n);
        if isempty(datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t}) & [datasetBout.Well_ID] == fish(f)))) ~= 1
            [datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t}) & [datasetBout.Well_ID] == fish(f))).Fish_ID] = deal(n);
        end
        if isempty(datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t+1}) & [datasetBout.Well_ID] == fish(f)))) ~= 1
            [datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t+1}) & [datasetBout.Well_ID] == fish(f))).Fish_ID] = deal(n);
        end
        if isempty(datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t+2}) & [datasetBout.Well_ID] == fish(f)))) ~= 1
            [datasetBout_ID(find(strcmp({datasetBout.Trial_ID},trialsTot{1,t+2}) & [datasetBout.Well_ID] == fish(f))).Fish_ID] = deal(n);
        end
        n = n+1;
    end
end

N = n-1;