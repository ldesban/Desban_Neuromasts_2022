function [h, distr, distr_ID, P] = plotParamInX_local5HT(data, code, Nf, param, d, outliers)

distr = nan(Nf,14/d); % will be assigned one value per cm of the well's length (l=14cm)
distr_ID = cell(Nf,2); % keeps track of the ID and condition of each fish
P = nan(1, 14/d); % vector with p-values 

for f = 1:Nf
    if outliers(f,1) == 0
        distr_ID{f,1} = f;
        D = data([data.Fish_ID] == f);
        if isempty(D) ~= 1 && size(D,2) >= 2    
            c = D.Condition;
            distr_ID{f,2} = code{1,c+1};
            fq = D(1,1).fps;
            temp = nan(1000,14/d); % create a temporary matrix
            for b = 2:size(D,2)
                pY = D(1,b).HeadY*0.07/10;
                if strcmp(param, 'Speed')
                    temp(b,floor(pY(1,1)/d)+1) = D(1,b).Speed; % for each bout, add the speed in the right column corresponding to the space interval
                elseif strcmp(param, 'IBI')
                    temp(b,floor(pY(1,1)/d)+1) = log(D(1,b).InstantaneousIBI); % for each bout, add the log(IBI) in the right column corresponding to the space interval
                elseif strcmp(param, 'FQ')
                    temp(b,floor(pY(1,1)/d)+1) = 1/D(1,b).InstantaneousIBI; % for each bout, add the 1/IBI in the right column corresponding to the space interval
                elseif strcmp(param, 'Turns')
                    if isempty(D(1,b).DeltaHead) ~= 1
                        temp(b,floor(pY(1,1)/d)+1) = D(1,b).DeltaHead; % for each bout, add the delatheading in the right column corresponding to the space interval                
                    else
                        temp(b,floor(pY(1,1)/d)+1) = NaN;
                    end
                end
            end
            for i = 1:14/d
                if strcmp(param, 'Turns')
                    distr(f,i) = size(find([temp(:,i)] > 30 | [temp(:,i)] < -30),1)*100/sum(~isnan(temp(:,i)));
                else
                    distr(f,i) = nanmean(temp(:,i),1);
                end
            end
        elseif strcmp(param, 'Time')
            c = D.Condition;
            distr_ID{f,2} = code{1,c+1};
            fq = D(1,1).fps;
            temp = zeros(1,14/d); % create a temporary matrix
            DD = D.allHeadY;
            for b = 1:size(DD,2)
                pY = DD(1,b)*0.07/10;
                if pY(1,1) > 0 && pY(1,1) < 14
                    temp(1,floor(pY(1,1)/d)+1) = temp(1,floor(pY(1,1)/d)+1)+1; % add the frame spent in the bin
                elseif pY(1,1) <= 0
                    temp(1,1) = temp(1,1)+1; % add the frame spent in the bin
                elseif pY(1,1) >= 14
                    temp(1,14/d) = temp(1,14/d)+1; % add the frame spent in the bin
                end
            end
            for i = 1:14/d
                distr(f,i) = temp(1,i)/fq;
            end 
        elseif strcmp(param, 'PercEdge')
            c = D.Condition;
            distr_ID{f,2} = code{1,c+1};
            ps = D.pixelSize;
            edge = zeros(1,14/d); % create a temporary matrix
            center = zeros(1,14/d);
            DY = D.allHeadY;
            DX = D.allHeadX;
            for b = 1:size(DY,2)
                y = DY(1,b)*ps/10;
                x = DX(1,b)*ps/10;
                if (x < 0.2 || x > 0.8 || y < 0.2 ||  y > 13.8)
                    if (y > 0  && y < 14)
                        edge(1,floor(y/d)+1) = edge(1,floor(y/d)+1)+1; % add the position in edge in the bin
                    elseif y <= 0
                        edge(1,1) = edge(1,1)+1;
                    elseif y >= 14
                        edge(1,14/d) = edge(1,14/d)+1;
                    end
                else
                    center(1,floor(y/d)+1) = center(1,floor(y/d)+1)+1; % add the frame spent in the bin
                end
            end
            for i = 1:14/d
                distr(f,i) = edge(1,i)*100/(edge(1,i) + center(1,i));
            end          
        end
    end
end

h = figure();
subplot(1,2,1)
for f = 1:Nf
    if strcmp(distr_ID{f,2}, 'E3')
        plot([0.5:d:14], distr(f,:), 'x-k', 'LineWidth', 1, 'MarkerSize', 8); hold on
    elseif strcmp(distr_ID{f,2}, 'Local 5-HT')
        plot([0.5:d:14], distr(f,:), 'x-r', 'LineWidth', 1, 'MarkerSize', 4); hold on
    end
end
xlabel('Position in the well (cm)'); ylabel(param); title('Individual larvae');
subplot(1,2,2)
    plot([0.5:d:14], nanmean(distr(strcmp(distr_ID(:,2), 'E3'),:),1), '+-k', 'LineWidth', 2, 'MarkerSize', 8); hold on;
    errorbar([0.5:d:14], nanmean(distr(strcmp(distr_ID(:,2), 'E3'),:),1), nanstd(distr(strcmp(distr_ID(:,2), 'E3'),:))/sqrt(size(distr(strcmp(distr_ID(:,2), 'E3'),:),1)), '+k', 'LineWidth', 2); hold on;
    plot([0.5:d:14], nanmean(distr(strcmp(distr_ID(:,2), 'Local 5-HT'),:),1), '+-r', 'LineWidth', 2, 'MarkerSize', 8); hold on;
    errorbar([0.5:d:14], nanmean(distr(strcmp(distr_ID(:,2), 'Local 5-HT'),:),1), nanstd(distr(strcmp(distr_ID(:,2), 'Local 5-HT'),:))/sqrt(size(distr(strcmp(distr_ID(:,2), 'Local 5-HT'),:),1)), '+r', 'LineWidth', 2); hold on;
xpos = [0.5:d:14];
for i = 1:14/d
    d_CT = [];
    d_5HT = [];
    for j = 1:size(distr_ID,1)
         if isnan(distr(j,i)) == 0 && strcmp(distr_ID(j,2),'E3') == 1
             d_CT = [d_CT, distr(j,i)];
         elseif isnan(distr(j,i)) == 0 && strcmp(distr_ID(j,2),'Local 5-HT') == 1
             d_5HT = [d_5HT, distr(j,i)];
         end
    end
%    [p,hy] = ranksum(d_CT, d_5HT);
%    P(1,i) = p;
%    sigstar_LFD([xpos(1,i)-0.25 xpos(1,i)+0.25],p);
end
xlabel('Position in the well (cm)'); ylabel(param); title('Median across larvae');
        