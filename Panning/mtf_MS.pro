function MTF_MS, MS,ratio,NBands
  N = ratio
  sizes = SIZE(MS)
  toReturn = DBLARR(sizes(1),sizes(2),NBands)
  MTF_Nyq =  [0.28,0.29, 0.29, 0.30]
  fcut = 1./N;
  NFILTER=41.
  
  MS4 = DBLARR(sizes(1),sizes(2),NBands)
  MS4(*,*,0) = MS[*,*,0]
  MS4(*,*,1) = MS[*,*,1]
  MS4(*,*,2) = MS[*,*,2]
  MS4(*,*,3) = MS[*,*,3]
  
  FOR i=0,NBands-1 DO BEGIN
    sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(i))) )
    toReturn(*,*,i)= GAUSS_SMOOTH(MS4(*,*,i),sigma,/EDGE_MIRROR, WIDTH=NFILTER)
  endfor
  
  return, toReturn
end