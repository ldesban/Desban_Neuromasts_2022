function dataset = getKinematics_Trial2(dataset, thr)


for c = 1:size(dataset,1)
    figure('Position', [1950 300 1400 800]);
    dff = dataset(c).dff;
    f = dataset(c).FrameRate;
    ttp = nan(1,3);
    decay = nan(1,3);
    for s = 1:3
        dff_s = dff(s,:);
        M = max(dff_s(1,:));
        x_M = find(dff_s(1,:) == M);
        if (x_M > 5*f && x_M <= 15*f && M >= thr)
            subplot(1,3,s)
            ttp(1,s) = (x_M - 5*f)/f;
            E = fit([x_M:x_M+8*f]', dff_s(1,x_M:x_M+8*f)', 'exp1');
            plot(1:70*f, dff_s, '-k'); hold on;
            plot(E, [x_M:x_M+8*f]', dff_s(x_M:x_M+8*f)'); hold on;
            g = input('Is the exponential fit ok? (1 = Yes, 2 = No): ');
            if g == 1
                decay(1,s) = (-1/E.b)/f;
            end
        end
    end
    dataset(c).timetopeak = ttp;
    dataset(c).decay = decay;
    close all
end 
 

