function MTF, IMG,ratio,NBands, MTF_Nyq
  N = ratio
  sizes = SIZE(IMG)
  toReturn = DBLARR(sizes(1),sizes(2),NBands)
  fcut = 1./N;
  NFILTER=41.
  if size(MTF_Nyq,/DIMENSION) LT NBands then begin
    MTF_Nyq = replicate(MTF_Nyq,Nbands)
  endif
  
  FOR i=0,NBands-1 DO BEGIN
    sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(i))) )
    toReturn(*,*,i)= GAUSS_SMOOTH(IMG(*,*,i),sigma,/EDGE_MIRROR, WIDTH=NFILTER)
  endfor
  
  return, toReturn
end