function dataset2 = getSingleStim210518(dataset)

dataset2 = struct('Experiment_ID', [], 'FrameRate', [], 'Fish', [], 'Neuromast_ID', [], 'ROI_ID', [], 'ROI', [], 'dff', [], 'dff_single', [], 'Integral', [], 'baselineSTD', [], 'x_peak', [], 'EffectSize',[], 'timetopeak', [], 'decay', [], 'dff_ct', [], 'dff_ct_single', [], 'Integral_ct', [], 'baselineSTD_ct', [], 'x_peak_ct', [], 'EffectSize_ct', [], 'timetopeak_ct', [], 'decay_ct', []);

for c = 1:size(dataset, 2)
    dataset2(c).Experiment_ID = dataset(c).Experiment_ID;
    f = dataset(c).FrameRate;
    dataset2(c).FrameRate = f;
    dataset2(c).Fish = dataset(c).Fish;
    dataset2(c).Trial_ID = dataset(c).Trial_ID;
    dataset2(c).Neuromast_ID = dataset(c).Neuromast_ID;
    dataset2(c).Condition = dataset(c).Condition;
    dataset2(c).ROI_ID = dataset(c).ROI_ID;
    dataset2(c).ROI = dataset(c).ROI;
    raw = dataset(c).raw;
    raw1 = raw(1,1:70*f); raw2 = raw(1,70*f+1:140*f); raw3 = raw(1,140*f+1:210*f);
    raw_ct = dataset(c).raw_ct;
    raw1_ct = raw_ct(1,1:70*f); raw2_ct = raw_ct(1,70*f+1:140*f); raw3_ct = raw_ct(1,140*f+1:210*f);
    for t = 1:70*f
        dff1(1,t) = ((raw1(1,t)/nanmean(raw1(1,1:5*f),2))-1)*100;
        dff2(1,t) = ((raw2(1,t)/nanmean(raw2(1,1:5*f),2))-1)*100;
        dff3(1,t) = ((raw3(1,t)/nanmean(raw3(1,1:5*f),2))-1)*100;
        dff1_ct(1,t) = ((raw1_ct(1,t)/nanmean(raw1_ct(1,1:5*f),2))-1)*100;
        dff2_ct(1,t) = ((raw2_ct(1,t)/nanmean(raw2_ct(1,1:5*f),2))-1)*100;
        dff3_ct(1,t) = ((raw3_ct(1,t)/nanmean(raw3_ct(1,1:5*f),2))-1)*100;
    end
    dff = [dff1; dff2; dff3];
    dff_single = nanmean(dff,1);
    dataset2(c).dff = dff;
    dataset2(c).dff_single = dff_single;
    dataset2(c).baselineSTD = std(dff_single(1,3*f:5*f));
    M = max(dff_single(1,:)); x_M = find(dff_single(1,:) == M);
    dataset2(c).x_peak = x_M;
    if x_M <= (size(dff_single,2)-2) && x_M >= 3
        dataset2(c).EffectSize = nanmean(dff_single(1,x_M-2:x_M+2),2);
    elseif x_M > (size(dff_single,2)-2)
        dataset2(c).EffectSize = nanmean(dff_single(1,x_M-2:end),2);
    elseif x_M < 3
        dataset2(c).EffectSize = nanmean(dff_single(1,1:x_M+2),2);        
    end
    dff_ct = [dff1_ct; dff2_ct; dff3_ct];
    dff_ct_single = nanmean(dff_ct,1);
    dataset2(c).dff_ct = dff_ct;
    dataset2(c).dff_ct_single = dff_ct_single;
    dataset2(c).baselineSTD_ct = std(dff_ct_single(1,3*f:5*f));
    M_ct = max(dff_ct_single(1,:)); x_M_ct = find(dff_ct_single(1,:) == M_ct);
    dataset2(c).x_peak_ct = x_M_ct;
    if x_M_ct <= (size(dff_ct_single,2)-2) && x_M_ct >= 3
        dataset2(c).EffectSize_ct = nanmean(dff_ct_single(1,x_M_ct-2:x_M_ct+2),2);
    elseif x_M_ct > (size(dff_ct_single,2)-2)
        dataset2(c).EffectSize_ct = nanmean(dff_ct_single(1,x_M_ct-2:end),2);
    elseif x_M_ct < 3
        dataset2(c).EffectSize = nanmean(dff_single(1,1:x_M_ct+2),2);        
    end
end     