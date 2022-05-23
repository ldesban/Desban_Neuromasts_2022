function Catamaran_ExploratoryBehavior_3_plot(dataset)

for j = 1:size(dataset,2)/2
    for i = 1:size(dataset,1)
        line([(j-1)*2+1 (j-1)*2+2], [dataset(i,(j-1)*2+1) dataset(i,(j-1)*2+2)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8); hold on;
    end
    jitter;
    line([(j-1)*2+1 (j-1)*2+2], [nanmean(dataset(:,(j-1)*2+1),1) nanmean(dataset(:,(j-1)*2+2),1)], 'Marker', 'o', 'Color', 'k', 'MarkerSize', 8, 'LineWidth', 3); hold on;
end
boxplot(dataset);
