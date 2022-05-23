function [output] = getParamForMouv_20210413(mouv,organization,param)

  if strcmp(param,'duration')
  
    duration = double(mouv.BoutEnd-mouv.BoutStart+1) / organization.fps;
    output = duration;
    
  elseif strcmp(param,'totalDist')
  
    distance=0;
    posX=mouv.HeadX';
    %n=size(posX,1);
    %posX=posX(1:4:n,:);
    posY=mouv.HeadY';
    %posY=posY(1:4:n,:);        
    r=size(posX,1);
    for j=1:r-1
        distance=distance+sqrt((posX(j+1,1)-posX(j,1))^2 + (posY(j+1,1)-posY(j,1))^2);
    end
    output = distance * organization.pixelSize;
  
  elseif strcmp(param,'meanSpeed')
  
    distance=0;
    posX=mouv.HeadX';
    %n=size(posX,1);
    %posX=posX(1:4:n,:);
    posY=mouv.HeadY';
    %posY=posY(1:4:n,:);        
    r=size(posX,1);
    for j=1:r-1
        distance=distance+sqrt( (posX(j+1,1)-posX(j,1))^2 + (posY(j+1,1)-posY(j,1))^2);
    end
    distance = distance * organization.pixelSize;
    duration = double(mouv.BoutEnd-mouv.BoutStart+1) / organization.fps;
    output = distance / duration;
  
  elseif strcmp(param,'InstantaneousSpeed')
  
    posX  = mouv.HeadX';
    posY  = mouv.HeadY';
    n     = size(posX,1);
    speed = zeros(1,n-1);
    for j = 1:n-1
      speed(j) = sqrt( (posX(j+1,1)-posX(j,1))^2 + (posY(j+1,1)-posY(j,1))^2) / organization.fps;
    end
    output = speed;
    
  elseif strcmp(param,'NumberOfOscillation')
  
    output = size(mouv.Bend_Timing,2)/2;
  
  elseif strcmp(param,'AmplitudeOfAllBends')
  
    output = mouv.Bend_Amplitude * (180 / pi);
  
  elseif strcmp(param,'InstantaneousTailBendFrequency')
  
    Bend_Timing = mouv.Bend_Timing;
    n = size(Bend_Timing,2);
    output = zeros(1,n);
    if (Bend_Timing(1) > 1)
      output(1) = organization.fps / (2 * (Bend_Timing(1) - 1) );
    else
      output(1) = organization.fps / (2 * (Bend_Timing(1) - 0) );
    end
    for i=1:n-1
      output(i+1) = organization.fps / (2 * (Bend_Timing(i+1) - Bend_Timing(i)) );
    end

  elseif strcmp(param,'angularVelocity')
  
    TailAngle_smoothed = mouv.TailAngle_smoothed;
    output = diff(TailAngle_smoothed);
      
  end
  
end