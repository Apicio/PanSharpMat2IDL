@paths.pro
RESTORE, PATH_TO_LOAD_MS
sizes = SIZE(MS) ;[N_DIM,DIM1,DIM2,DIM3,..,N_ELEM]
PANIMAGE4 = DBLARR(sizes(1),sizes(2),sizes(3)) 
PANIMAGE4(*,*,0) = IM1CROPPAN
PANIMAGE4(*,*,1) = IM1CROPPAN
PANIMAGE4(*,*,2) = IM1CROPPAN
PANIMAGE4(*,*,3) = IM1CROPPAN
N = 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       MTF      ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
MTF_PANIMAGE = DBLARR(sizes(1),sizes(2),sizes(3))
MTF_Nyq =  [0.28,0.29, 0.29, 0.30]  
fcut = 1./N;
NBands = sizes(3)
NFILTER=41.
FOR i=0,NBands-1 DO BEGIN
  sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(i))) ) 
  MTF_PANIMAGE(*,*,i)= GAUSS_SMOOTH(PANIMAGE4(*,*,i),sigma,/EDGE_MIRROR, WIDTH=NFILTER)
endfor
;MTF_PANIMAGE = PANIMAGE4
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Blurring PAN Image ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
PANIMAGERIC = DBLARR(sizes(1),sizes(2),sizes(3)) 
FOR ii=0,sizes(3)-1 DO BEGIN
  PANIMAGERIC(*,*,ii) = sresize(MTF_PANIMAGE(*,*,ii), N)
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
;mean_pl1 = mean(PANIMAGERIC_H(*,*,0))
;mean_pl2 = mean(PANIMAGERIC_H(*,*,1))
;mean_pl3 = mean(PANIMAGERIC_H(*,*,2))
;mean_pl4 = mean(PANIMAGERIC_H(*,*,3))
;
;mean_ms1 = mean(MS(*,*,0))
;mean_ms2 = mean(MS(*,*,1))
;mean_ms3 = mean(MS(*,*,2))
;mean_ms4 = mean(MS(*,*,3))

;ms1pl_cov = mean((MS(*,*,0) - mean_ms1)*(PANIMAGERIC_H(*,*,0) - mean_pl1)) ;
;ms2pl_cov = mean((MS(*,*,1) - mean_ms2)*(PANIMAGERIC_H(*,*,1) - mean_pl2)) ;
;ms3pl_cov = mean((MS(*,*,2) - mean_ms3)*(PANIMAGERIC_H(*,*,2) - mean_pl3)) ;
;ms4pl_cov = mean((MS(*,*,3) - mean_ms4)*(PANIMAGERIC_H(*,*,3) - mean_pl4)) ;


;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

im = image(IM1CROPPAN)
im = image(MS[*,*,0:2])
im = image(FUSED_MS[*,*,0:2])

end
