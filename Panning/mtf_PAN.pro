function MTF_PAN, PAN,ratio,NBands
  N = ratio
  sizes = SIZE(PAN)
  toReturn = DBLARR(sizes(1),sizes(2),NBands)
  MTF_Nyq =  [0.28,0.29, 0.29, 0.30]
  fcut = 1./N;
  NFILTER=41.
  
  PANIMAGE4 = DBLARR(sizes(1),sizes(2),NBands)
  PANIMAGE4(*,*,0) = PAN
  PANIMAGE4(*,*,1) = PAN
  PANIMAGE4(*,*,2) = PAN
  PANIMAGE4(*,*,3) = PAN
  
  FOR i=0,NBands-1 DO BEGIN
    sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(i))) )
    toReturn(*,*,i)= GAUSS_SMOOTH(PANIMAGE4(*,*,i),sigma,/EDGE_MIRROR, WIDTH=NFILTER)
  endfor
  
  return, toReturn
end