function [experimentsAgglo] = addVideoInExpAggloPerFishLFD_20210416(experimentsAgglo,videoResults,includes)

  if size(experimentsAgglo,2) == 1
    if (size(experimentsAgglo(1).Trial_ID))
      n = 2;
    else
      n = 1;
    end
  else
    n = size(experimentsAgglo,2) + 1;
  end

  wellPoissMouv = videoResults.videoDataResults.wellPoissMouv;
  
  if (size(wellPoissMouv,1) ~= size(videoResults.videoDataResults.organization.wellCondition,2))
    disp(['WARNING!!! Incorrect number of conditions.'])
  end
  if (size(wellPoissMouv,1) ~= size(videoResults.videoDataResults.organization.genotype,2))
    disp(['WARNING!!! Incorrect number of genotypes.'])
  end
  
  for well=1:size(wellPoissMouv,1)
    if (includes(well))
%      for poiss=1:size(wellPoissMouv{well},2)        
        fish = wellPoissMouv{well}; 
        experimentsAgglo(n).Trial_ID  = videoResults.videoDataResults.organization.videoName;
        experimentsAgglo(n).Well_ID   = well;
        experimentsAgglo(n).Fish_ID   = 1;
        experimentsAgglo(n).Condition = videoResults.videoDataResults.organization.wellCondition{well};
        experimentsAgglo(n).Genotype  = videoResults.videoDataResults.organization.genotype{well};
        experimentsAgglo(n).Recovery  = videoResults.videoDataResults.organization.recovery{well};
        experimentsAgglo(n).fps       = videoResults.videoDataResults.organization.fps;
        experimentsAgglo(n).Nframes   = videoResults.videoDataResults.organization.Nframes;
        experimentsAgglo(n).pixelSize = videoResults.videoDataResults.organization.pixelSize;
        experimentsAgglo(n).NTotBout  = size(fish,2);
        experimentsAgglo(n).MeanIBI   = getParamForFishLFD_20210413(fish,videoResults.videoDataResults.organization,'IBI');
        experimentsAgglo(n).TotalDistanceInActiveMotion         = getParamForFishLFD_20210413(fish,videoResults.videoDataResults.organization,'TotalDistWhenActiveMotion');
        experimentsAgglo(n).TotalDistanceActiveMotionAndGliding = getParamForFishLFD_20210413(fish,videoResults.videoDataResults.organization,'TotalDistWhenMotionAndGliding');
        
        n = n + 1;
      end
%    end
  end
end