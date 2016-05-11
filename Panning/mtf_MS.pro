function MTF_MS, MS,ratio,NBands
  N = ratio
  sizes = SIZE(MS)
  toReturn = DBLARR(sizes(1),sizes(2),NBands)
  MTF_Nyq =  [0.28,0.29, 0.29, 0.30]
  fcut = 1./N;
  NFILTER=41.
  MS4 = DBLARR(sizes(1),sizes(2),NBands)
  
  FOR i=0,NBands-1 DO BEGIN
    sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(i))) )
    toReturn(*,*,i)= GAUSS_SMOOTH(MS(*,*,i),sigma,/EDGE_MIRROR, WIDTH=NFILTER)
  endfor
  
  return, toReturn
end