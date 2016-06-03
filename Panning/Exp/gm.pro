@paths.pro
RESTORE, PATH_TO_LOAD_MS
ratio = 3
Nbands = 3
sizes = size(IM1CROPPAN,/dimension)

TIC 
  
  GRAY = DBLARR(sizes(0),sizes(1))
  GRAY = 0.299*MS(*,*,0) + 0.587*MS(*,*,1) + 0.114*MS(*,*,2) 
  var_pl = variance(GRAY)
  ms1pl_cov = correlate(MS(*,*,0),GRAY,/covariance) ;
  ms2pl_cov = correlate(MS(*,*,1),GRAY,/covariance) ;
  ms3pl_cov = correlate(MS(*,*,2),GRAY,/covariance) ;
  G1 = ms1pl_cov/var_pl
  G2 = ms2pl_cov/var_pl
  G3 = ms3pl_cov/var_pl
  
  DELTA_PAN = DBLARR(sizes(0),sizes(1))
  FOR j=0,sizes(0)-1 DO BEGIN
    FOR i=0,sizes(1)-1 DO BEGIN
        DELTA_PAN(j,i) = IM1CROPPAN(j,i) - GRAY(j,i)
    ENDFOR
  ENDFOR
  ; Pesiamo ogni singola delta per il guadagno calcolato precedentemente.
  GAIN_PAN = DBLARR(sizes(0),sizes(1), Nbands)
  GAIN_PAN(*, *,0) = G1*DELTA_PAN
  GAIN_PAN(*, *,1) = G2*DELTA_PAN
  GAIN_PAN(*, *,2) = G3*DELTA_PAN
  ; Inject dei dettagli.
  FUSED_MS = DBLARR(sizes(0),sizes(1),Nbands)
  FOR j=0,sizes(0)-1 DO BEGIN
    FOR i=0,sizes(1)-1 DO BEGIN
      FOR b=0,Nbands-1 DO BEGIN
        FUSED_MS(j,i,b) = (GAIN_PAN(j,i,b) + MS(j,i,b))
      ENDFOR
    ENDFOR
  ENDFOR
  
TOC
RESTORE, PATH_TO_FILE ;Carica PAN e singole Bande
;Serve MS NON interpolata (per il confronto finale).
MS = DBLARR(sizes(0)/ratio,sizes(1)/ratio, Nbands)
MS[*,*,0] = im5CropMS3 ;R
MS[*,*,1] = im4CropMS2 ;G
MS[*,*,2] = im3CropMS1 ;B

D_MS = DBLARR(sizes(0)/ratio,sizes(1)/ratio, Nbands)
D_MS(*,*,0) = sresize(MS(*,*,0),ratio)
D_MS(*,*,1) = sresize(MS(*,*,1),ratio)
D_MS(*,*,2) = sresize(MS(*,*,2),ratio)
D_PAN = IM1CROPPAN(0:*:ratio,0:*:ratio)
sizes = size(D_PAN,/dimension)
; Applicazione pansharpening GS2_GLP a PAN ed MS degradate

D_GRAY = DBLARR(sizes(0),sizes(1))
D_GRAY = 0.299*D_MS(*,*,0) + 0.587*D_MS(*,*,1) + 0.114*D_MS(*,*,2)
var_pl = variance(D_GRAY)
ms1pl_cov = correlate(D_MS(*,*,0),D_GRAY,/covariance) ;
ms2pl_cov = correlate(D_MS(*,*,1),D_GRAY,/covariance) ;
ms3pl_cov = correlate(D_MS(*,*,2),D_GRAY,/covariance) ;
G1 = ms1pl_cov/var_pl
G2 = ms2pl_cov/var_pl
G3 = ms3pl_cov/var_pl

D_DELTA_PAN = DBLARR(sizes(0),sizes(1))
FOR j=0,sizes(0)-1 DO BEGIN
  FOR i=0,sizes(1)-1 DO BEGIN
    D_DELTA_PAN(j,i) = D_PAN(j,i) - D_GRAY(j,i)
  ENDFOR
ENDFOR
; Pesiamo ogni singola delta per il guadagno calcolato precedentemente.
D_GAIN_PAN = DBLARR(sizes(0),sizes(1), Nbands)
D_GAIN_PAN(*, *,0) = G1*D_DELTA_PAN
D_GAIN_PAN(*, *,1) = G2*D_DELTA_PAN
D_GAIN_PAN(*, *,2) = G3*D_DELTA_PAN
; Inject dei dettagli.
FUSED_IMAGE = DBLARR(sizes(0),sizes(1),Nbands)
FOR j=0,sizes(0)-1 DO BEGIN
  FOR i=0,sizes(1)-1 DO BEGIN
    FOR b=0,Nbands-1 DO BEGIN
      FUSED_IMAGE(j,i,b) = (D_GAIN_PAN(j,i,b) + D_MS(j,i,b))
    ENDFOR
  ENDFOR
ENDFOR


; Verifico Qualità
q4 = q2n(FUSED_IMAGE,MS)
scc = scc_indexGM(MS,FUSED_IMAGE)
samidx = sam(ms,FUSED_IMAGE)

print, q4
print, scc
print, samidx

end
