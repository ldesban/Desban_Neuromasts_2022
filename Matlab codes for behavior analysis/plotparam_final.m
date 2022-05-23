function [h, Output] = plotparam_final(dataFish, dataBout, code_c, code_g, N, param)

Nf = N(1,1);
Nc = N(1,2);
Ng = N(1,3);

color = {[0.5 0.5 0.5], [1 0 0], [0 0 1]};

h = figure(); %'Position', [1950 300 1400 800]
Output = nan(Nf,Nc*Ng);
for f = 1:Nf
	AllFish = dataFish([dataFish.Fish_ID] == f);
    for i = 1:size(AllFish,2)
        data_Fish_i = AllFish(1,i);
        t = data_Fish_i.Trial_ID;
        c = data_Fish_i.Condition;
        g = data_Fish_i.Genotype;
        data_Bout_i = dataBout(strcmp({dataBout.Trial_ID}, t) & [dataBout.Fish_ID] == f & [dataBout.Condition] == c & [dataBout.Genotype] == g);
        if strcmp(param,'bouts')
            data = data_Fish_i.NTotBout;
            ylabel('Total number of bouts');
        elseif strcmp(param,'IBI')
            d = [data_Bout_i.InstantaneousIBI]*1000;
            if size(d,2) > 1
                fr = data_Fish_i.fps;
                Nframes = data_Fish_i.Nframes;
                BS = (data_Bout_i(1).BoutStart)*1000/fr;
                BE = (data_Bout_i(end).BoutEnd)*1000/fr;
                d = [BS d (Nframes/fr)*1000-BE];
                data = nanmedian(d,2);
            elseif isnan(d) == 1
                fr = data_Fish_i.fps;
                Nframes = data_Fish_i.Nframes;
                BS = (data_Bout_i.BoutStart)*1000/fr;
                BE = (data_Bout_i.BoutEnd)*1000/fr;
                data = nanmedian([BS, (Nframes/fr)*1000-BE],2);
            elseif isempty(d) == 1
                fr = data_Fish_i.fps;
                Nframes = data_Fish_i.Nframes;
                data = (Nframes/fr)*1000;
            end
            ylabel('Median IBI (in ms)');
        elseif strcmp(param, 'swim')
            d = [data_Bout_i.BoutDuration];
            if isempty(d) == 1
                data = 0;
            else
                data = sum(d)*100*data_Fish_i.fps/data_Fish_i.Nframes;
            end
            ylabel('Percentage of time swimming (%)');            
        elseif strcmp(param,'speed')
            if isempty(data_Bout_i) ~= 1
                data = nanmedian([data_Bout_i.Speed],2);
            else
                data = NaN;
            end
            ylabel('Median speed (in mm.s-1)');
        elseif strcmp(param, 'boutduration')
            if isempty(data_Bout_i) ~= 1
                data = nanmean([data_Bout_i.BoutDuration],2)*1000;
            else
                data = NaN;
            end
            ylabel('Mean bout duration (in ms)');
        elseif strcmp(param, 'distbout')
            if isempty(data_Bout_i) ~= 1
                data = nanmean([data_Bout_i.TotalDistance],2);
            else
                data = 0;
            end
            ylabel('Mean distance per bout (in mm)');
        elseif strcmp(param,'turns')
            if isempty(data_Bout_i) ~= 1
                nTurn = size(find([data_Bout_i.DeltaHead] > 30 | [data_Bout_i.DeltaHead] < -30),2);
                data = nTurn*100/size(data_Bout_i,2);
            else 
                data = NaN;
            end
            ylabel('Proportion of turns (%)');
        elseif strcmp(param,'tbf')
            if isempty(data_Bout_i) ~= 1
                data = nanmean([data_Bout_i.InstantaneousTBF],2);
            else
                data = NaN;
            end
            ylabel('Tail beat frequency (in Hz)');
        elseif strcmp(param, 'totdur')
            if isempty(data_Bout_i) ~= 1
                data = nansum([data_Bout_i.BoutDuration],2);
            else 
                data = NaN;
            end
            ylabel('Total duration (in s)');
        elseif strcmp(param,'totdist')
            data = data_Fish_i.TotalDistanceInActiveMotion;
            ylabel('Total distance (active,in mm)');
        elseif strcmp(param,'totdistglid')
            data = data_Fish_i.TotalDistanceActiveMotionAndGliding;
            ylabel('Total distance (active and passive, in mm)');
        end
        Output(f,g+1+c*Ng) = data;
    end
end
r = rand(Nf,1); r = r-mean(r);
for c = 0:Nc-1
    for g = 0:Ng-1
        plot(r*0.25+g+1+c*Ng, Output(:,g+1+c*Ng), 'o', 'Color', [color{c+1}], 'MarkerSize', 4);hold on;
        plot([g+0.75+c*Ng g+1.25+c*Ng], [nanmean(Output(:,g+1+c*Ng),1)  nanmean(Output(:,g+1+c*Ng),1)], '-k', 'LineWidth', 2);hold on;        
    end
end
xticks(1:Ng*Nc); xticklabels(code_g);
hold on;
boxplot(Output);
