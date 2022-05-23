function [experimentsAgglo] = addVideoInExpAggloPerBoutLFD_20210416(experimentsAgglo,videoResults,includes)

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
%      for poiss=1:size(wellPoissMouv{well},1)
        for numMouv=1:size(wellPoissMouv{well},2)
          
          mouv = wellPoissMouv{well}{numMouv};
          
          % General information about where the bout is coming from
          experimentsAgglo(n).Trial_ID     = videoResults.videoDataResults.organization.videoName;
          experimentsAgglo(n).Well_ID      = well;
          experimentsAgglo(n).Fish_ID      = 1;
          experimentsAgglo(n).NumBout      = numMouv;
          experimentsAgglo(n).BoutStart    = mouv.BoutStart;
          experimentsAgglo(n).BoutEnd      = mouv.BoutEnd;
          experimentsAgglo(n).Condition    = videoResults.videoDataResults.organization.wellCondition{well};
          experimentsAgglo(n).Genotype     = videoResults.videoDataResults.organization.genotype{well};
          experimentsAgglo(n).Recovery     = videoResults.videoDataResults.organization.recovery{well};
          if isfield(wellPoissMouv{well}{numMouv},'flag')
            experimentsAgglo(n).Flag = wellPoissMouv{well}{numMouv}.flag;
          else
            experimentsAgglo(n).Flag = 0;
          end
          experimentsAgglo(n).fps       = videoResults.videoDataResults.organization.fps;
          experimentsAgglo(n).pixelSize = videoResults.videoDataResults.organization.pixelSize;
          experimentsAgglo(n).Nframes   = videoResults.videoDataResults.organization.Nframes;
          
          % One value "global parameters"
          experimentsAgglo(n).BoutDuration  = getParamForMouv_20210413(mouv,videoResults.videoDataResults.organization,'duration');
          experimentsAgglo(n).TotalDistance = getParamForMouv_20210413(mouv,videoResults.videoDataResults.organization,'totalDist');
          experimentsAgglo(n).Speed         = getParamForMouv_20210413(mouv,videoResults.videoDataResults.organization,'meanSpeed');
%          experimentsAgglo(n).NumberOfOscillations = getParamForMouv(mouv,videoResults.videoDataResults.organization,'NumberOfOscillation');
          
          % Array parameters
%          experimentsAgglo(n).AmplitudeOfAllBends  = getParamForMouv(mouv,videoResults.videoDataResults.organization,'AmplitudeOfAllBends');
%          experimentsAgglo(n).InstantaneousTBF     = getParamForMouv(mouv,videoResults.videoDataResults.organization,'InstantaneousTailBendFrequency');
          experimentsAgglo(n).InstantaneousSpeed   = getParamForMouv_20210413(mouv,videoResults.videoDataResults.organization,'InstantaneousSpeed');
%          experimentsAgglo(n).angularVelocity   = getParamForMouv(mouv,videoResults.videoDataResults.organization,'angularVelocity');
          if (numMouv > 1)
            prevMouv = wellPoissMouv{well}{numMouv-1};
            experimentsAgglo(n).InstantaneousIBI = getInstantaneousIBI(prevMouv,mouv,videoResults.videoDataResults.organization);
          else
            experimentsAgglo(n).InstantaneousIBI = NaN;
          end
          
          % transfering parameters directly from the superstructure
%          experimentsAgglo(n).TailAngle_smoothed     = wellPoissMouv{well}{poiss}{numMouv}.TailAngle_smoothed;
          experimentsAgglo(n).HeadX                  = wellPoissMouv{well}{numMouv}.HeadX;
          experimentsAgglo(n).HeadY                  = wellPoissMouv{well}{numMouv}.HeadY;
          experimentsAgglo(n).Heading                = wellPoissMouv{well}{numMouv}.Heading;
          experimentsAgglo(n).TailX_VideoReferential = wellPoissMouv{well}{numMouv}.TailX_VideoReferential;
          experimentsAgglo(n).TailY_VideoReferential = wellPoissMouv{well}{numMouv}.TailY_VideoReferential;
%           experimentsAgglo(n).Bend_Timing            = wellPoissMouv{well}{poiss}{numMouv}.Bend_Timing;
%           experimentsAgglo(n).Bend_Amplitude         = wellPoissMouv{well}{poiss}{numMouv}.Bend_Amplitude;
          
          n = n + 1;
        end
%      end
    end
  end
end