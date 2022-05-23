function [output] = getParamForFishLFD_20210413(fish,organization,param)

  if strcmp(param,'IBI')
    
    if (size(fish,2) > 1)
      IB = zeros(1,size(fish,2)-1);
      for i=1:size(fish,2)-1
        fin = fish{i}.BoutEnd;
        beg = fish{i+1}.BoutStart;
        IB(i) = double(beg - fin) / organization.fps;
      end
      output = mean(IB);
    elseif (size(fish,2) == 1)
      output = (organization.Nframes - fish{1}.BoutEnd) / organization.fps; 
    elseif (size(fish,2) == 0)
      output = organization.Nframes / organization.fps;
    end
    
  elseif strcmp(param,'TotalDistWhenActiveMotion')
  
    if (size(fish,2) > 0)
      TotalDistWhenActiveMotion = zeros(1,size(fish,2));
      for i=1:size(fish,2)
        TotalDistWhenActiveMotion(i) = getParamForMouv_20210413(fish{i},organization,'totalDist');
      end
      output = sum(TotalDistWhenActiveMotion);
    else
      output = 0;
    end
  
  elseif strcmp(param,'TotalDistWhenMotionAndGliding')
  
    if (size(fish,2) > 1)
      TotalDistWhenActiveMotion = zeros(1,size(fish,2));
      TotalDistWhenInactive     = zeros(1,size(fish,2)-1);
      for i=1:size(fish,2)
        TotalDistWhenActiveMotion(i) = getParamForMouv_20210413(fish{i},organization,'totalDist');
      end
      for i=1:size(fish,2)-1
        posX1 = fish{i}.HeadX';
        posY1 = fish{i}.HeadY';
        n1    = size(posX1,1);
        posX2 = fish{i+1}.HeadX';
        posY2 = fish{i+1}.HeadY';
        distance = sqrt( (posX1(n1,1)-posX2(1,1))^2 + (posY1(n1,1)-posY2(1,1))^2);
        TotalDistWhenInactive(i) = distance;
      end
      output = sum(TotalDistWhenActiveMotion) + sum(TotalDistWhenInactive);
    elseif (size(fish,2) == 1)
      output = getParamForMouv_20210413(fish{1},organization,'totalDist');
    else
      output = 0;
    end
  
  end
  
end