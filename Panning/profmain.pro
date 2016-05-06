@paths.pro
HDFID = hdf_sd_start('D:\Gianluigi\Documenti\Universita\Telerilevamento\Progetto\Panning\prof2.hdf')

index=hdf_sd_nametoindex(hdfid,'PAN_image')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, IM1CROPPAN
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'I_MS_LR')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, MS_LR
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'I_MS')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, MS
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'DELTA_PAN_MATLAB')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, DELTA_PAN_MATLAB
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'FUSED_MS_MATLAB')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, FUSED_MS_MATLAB
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'g')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, g
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'PAN_MTF_MATLAB')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, PAN_MTF_MATLAB
hdf_sd_endaccess, varid

index=hdf_sd_nametoindex(hdfid,'PAN_RESIZE_MATLAB')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, PAN_RESIZE_MATLAB
hdf_sd_endaccess, varid

hdf_sd_end, hdfid

sizes = SIZE(MS) ;[N_DIM,DIM1,DIM2,DIM3,..,N_ELEM]
N = 4
ORIGINAL = DBLARR(sizes(1),sizes(2),sizes(3))
ORIGINAL(*,*,0) = IM1CROPPAN(*,*,0)
ORIGINAL(*,*,1) = IM1CROPPAN(*,*,0)
ORIGINAL(*,*,2) = IM1CROPPAN(*,*,0)
ORIGINAL(*,*,3) = IM1CROPPAN(*,*,0)
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       MTF      ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
MTF_PANIMAGE = DBLARR(sizes(1),sizes(2),sizes(3)) 
MTF_Nyq =  [0.29, 0.29, 0.28, 0.30]
fcut = 1./N
NFILTER=41.
FOR ii=0,sizes(3)-1 DO BEGIN
  sigma = SQRT( ((NFILTER*(fcut/2.))^2) / (-2.*alog(MTF_Nyq(ii))) )
  MTF_PANIMAGE(*,*,ii) = GAUSS_SMOOTH(ORIGINAL(*,*,ii),sigma,/EDGE_MIRROR, KERNEL = k, WIDTH=NFILTER)
ENDFOR
;MTF_PANIMAGE = PAN_MTF_MATLAB
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

ms1pl_cov = correlate(PANIMAGERIC(*,*,0),MS(*,*,0),/covariance) ;
ms2pl_cov = correlate(PANIMAGERIC(*,*,1),MS(*,*,1),/covariance) ;
ms3pl_cov = correlate(PANIMAGERIC(*,*,2),MS(*,*,2),/covariance) ;
ms4pl_cov = correlate(PANIMAGERIC(*,*,3),MS(*,*,3),/covariance) ;

G1 = ms1pl_cov/var_pl1
G2 = ms2pl_cov/var_pl2
G3 = ms3pl_cov/var_pl3
G4 = ms4pl_cov/var_pl4
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       Fuse     ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELTA_PAN = DBLARR(sizes(1),sizes(2),sizes(3)) 
FOR j=0,sizes(1)-1 DO BEGIN
  FOR i=0,sizes(2)-1 DO BEGIN
    FOR b=0,sizes(3)-1 DO BEGIN
      DELTA_PAN(j,i,b) = ORIGINAL(j,i,b) - PANIMAGERIC(j,i,0)
      ENDFOR
  ENDFOR
ENDFOR

GAIN_PAN = DBLARR(sizes(1),sizes(2), sizes(3))
GAIN_PAN(*, *,0) = G(0)*DELTA_PAN(*, *,0)
GAIN_PAN(*, *,1) = G(1)*DELTA_PAN(*, *,1)
GAIN_PAN(*, *,2) = G(2)*DELTA_PAN(*, *,2)
GAIN_PAN(*, *,3) = G(3)*DELTA_PAN(*, *,3)

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
