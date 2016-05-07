function GS2_GLP,PAN,MS,ratio
  sizes = SIZE(MS)
  Nbands = sizes(3)
  PANIMAGE4 = DBLARR(sizes(1),sizes(2),NBands)
  PANIMAGE4(*,*,0) = PAN
  PANIMAGE4(*,*,1) = PAN
  PANIMAGE4(*,*,2) = PAN
  PANIMAGE4(*,*,3) = PAN
  
  MTF_PANIMAGE = mtf_pan(PAN,ratio,Nbands)

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;; Blurring PAN Image ;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  PANIMAGERIC = DBLARR(sizes(1),sizes(2),sizes(3))
  FOR ii=0,sizes(3)-1 DO BEGIN
    PANIMAGERIC(*,*,ii) = sresize(MTF_PANIMAGE(*,*,ii), ratio)
  ENDFOR
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;;; Compute Gains Gk ;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  var_pl1 = variance(PANIMAGERIC(*,*,0))
  var_pl2 = variance(PANIMAGERIC(*,*,1))
  var_pl3 = variance(PANIMAGERIC(*,*,2))
  var_pl4 = variance(PANIMAGERIC(*,*,3))

  ms1pl_cov = correlate(MS(*,*,0),PANIMAGERIC(*,*,0),/covariance) ;
  ms2pl_cov = correlate(MS(*,*,1),PANIMAGERIC(*,*,1),/covariance) ;
  ms3pl_cov = correlate(MS(*,*,2),PANIMAGERIC(*,*,2),/covariance) ;
  ms4pl_cov = correlate(MS(*,*,3),PANIMAGERIC(*,*,3),/covariance) ;

  G1 = ms1pl_cov/var_pl1
  G2 = ms2pl_cov/var_pl2
  G3 = ms3pl_cov/var_pl3
  G4 = ms4pl_cov/var_pl4

  ;;;;       Fuse     ;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;
  DELTA_PAN = DBLARR(sizes(1),sizes(2),sizes(3))
  FOR j=0,sizes(1)-1 DO BEGIN
    FOR i=0,sizes(2)-1 DO BEGIN
      FOR b=0,sizes(3)-1 DO BEGIN
        DELTA_PAN(j,i,b) = PANIMAGE4(j,i,b) - PANIMAGERIC(j,i,0)
      ENDFOR
    ENDFOR
  ENDFOR

  GAIN_PAN = DBLARR(sizes(1),sizes(2), sizes(3))
  GAIN_PAN(*, *,0) = G1*DELTA_PAN(*,*,0)
  GAIN_PAN(*, *,1) = G2*DELTA_PAN(*,*,1)
  GAIN_PAN(*, *,2) = G3*DELTA_PAN(*,*,2)
  GAIN_PAN(*, *,3) = G4*DELTA_PAN(*,*,3)

  FUSED_MS = DBLARR(sizes(1),sizes(2),sizes(3))
  FOR j=0,sizes(1)-1 DO BEGIN
    FOR i=0,sizes(2)-1 DO BEGIN
      FOR b=0,sizes(3)-1 DO BEGIN
        FUSED_MS(j,i,b) = (GAIN_PAN(j,i,b) + MS(j,i,b))
      ENDFOR
    ENDFOR
  ENDFOR

  im = image(PAN)
  im = image(MS[*,*,0:2])
  im = image(FUSED_MS[*,*,0:2])

  SAVE, FILENAME = PATH_TO_PANNED, FUSED_MS
  
  return, FUSED_MS
end
