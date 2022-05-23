function [output] = getInstantaneousIBI(prevMouv,mouv,organization)

  fin = prevMouv.BoutEnd;
  beg = mouv.BoutStart;
  output = double(beg - fin) / organization.fps;
  
end