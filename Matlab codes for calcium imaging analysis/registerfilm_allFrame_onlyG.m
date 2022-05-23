function [Gr] = registerfilm_allFrame_onlyG(Go,FrameRef);

%%
fig = figure(1);
imshow(FrameRef);

% [xmin ymin width height]
rect = floor(getrect(fig));

rectindX = [rect(1):(rect(1)+rect(3))];
rectindY = [rect(2):(rect(2)+rect(4))];

template = Go(rectindY, rectindX, 1);

% bigrectX = [max(1,rect(1)-20):min(size(M,2),(rect(1)+rect(3)+20))];
% bigrectY = [max(1,rect(2)-20):min(size(M,1),(rect(2)+rect(4)+20))];

bigrectX=1:size(Go,2);
bigrectY=1:size(Go,1);

Gr = Go;

for i=1:size(Go,3)
    out = normxcorr2(template,Go(bigrectY,bigrectX,i));
    imshow(out);
    size(out);
    [maxval,ind] = max(abs(out(:)));
    [Yp,Xp] = ind2sub(size(out),ind);
    % bottom right corner matters
    Yoffset = (Yp-size(template,1))-(rect(2))+1;
    Xoffset = (Xp-size(template,2))-(rect(1))+1;
    %pause
    % [BW,xi,yi] = roipoly(M(:,:,1));
    se = translate(strel(1), [-Yoffset -Xoffset]);
    Gr(:,:,i) = imdilate(Go(:,:,i),se);
end

% save data
%save([R_dir '_registered.mat'], 'Rr');
%for i=1:size(Mr,3)
    %imwrite(Mr(:,:,i), [M '_registered' num2str(i) '.tif']);
%end  
%save([G_dir '_registered.mat'], 'Gr');
%for i=1:size(Nr,3)
%    imwrite(Nr(:,:,i), [N '_registered' num2str(i) '.tif']);
%end 

close all