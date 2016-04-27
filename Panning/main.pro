@paths.pro
RESTORE, PATH_TO_LOAD_MS
N = 3
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       MTF      ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;function MTF_Filt, toFilt, N, scale
;toFilt -> Immagine da filtrare
;N      -> Dimensione del filtro
;scale  -> Fattore di scala (3 nel caso EO-1)

sizes = SIZE(IM1CROPPAN) ;[N_DIM,DIM1,DIM2,DIM3,..,N_ELEM]
MTF_PANIMAGE = INTARR(sizes(1),sizes(2))
MTF_Nyq = 0.15;; DA CAMBIARE, PRESO DA SENSORE QB
fcut = 1/N;
NFILTER=N*10+1
sigma = SQRT( ((N*(fcut/2))^2) / (-2*alog(MTF_Nyq)) )
filter = GAUSSIAN_FUNCTION(sigma, WIDTH = NFILTER)
filter = CONVOL(filter/max(filter),hanning(N))
MTF_PANIMAGE = CONVOL(FLOAT(IM1CROPPAN),filter,/EDGE_TRUNCATE)
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Blurring PAN Image ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
DIM = size(MTF_PANIMAGE, /DIMENSIONS)
UPSAMPLED_PANIMAGE = intarr(DIM(0),DIM(1))
DOWNSAMPLED_PANIMAGE = MTF_PANIMAGE[0:*:N,0:*:N]
UPSAMPLED_PANIMAGE[0:*:N,0:*:N] = DOWNSAMPLED_PANIMAGE
TRASFORMED_PANIMAGE = fft(UPSAMPLED_PANIMAGE, -1)
dim1 = 128
dim2 = 512
H1 = (intarr(dim1,dim1)+1)*N;
H0_1 = intarr(dim2,dim1)
H0_2 = intarr(dim1,dim2)
H0_3 = intarr(dim2,dim2)
H = [[H1, H0_1, H1],[H0_2, H0_3, H0_2],[H1, H0_1, H1]] ; Filtro
TRASFORMED_PANIMAGE_RIC = TRASFORMED_PANIMAGE*H
PANIMAGERIC = REAL_PART(fft(TRASFORMED_PANIMAGE_RIC, 1)) ; anti trasformata

PANIMAGERIC_B1 = intarr(DIM(0),DIM(1))
PANIMAGERIC_B2 = intarr(DIM(0),DIM(1))
PANIMAGERIC_B3 = intarr(DIM(0),DIM(1))
PANIMAGERIC_B4 = intarr(DIM(0),DIM(1))

PANIMAGERIC_B1 = PANIMAGERIC 
PANIMAGERIC_B2 = PANIMAGERIC 
PANIMAGERIC_B3 = PANIMAGERIC 
PANIMAGERIC_B4 = PANIMAGERIC 
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Histogram Matching ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
PANIMAGERIC_B1_H = PANIMAGERIC_B1
PANIMAGERIC_B2_H = PANIMAGERIC_B2
PANIMAGERIC_B3_H = PANIMAGERIC_B3
PANIMAGERIC_B4_H = PANIMAGERIC_B4
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Compute Gains Gk ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
var_pl1 = variance(PANIMAGERIC_B1_H)
var_pl2 = variance(PANIMAGERIC_B2_H)
var_pl3 = variance(PANIMAGERIC_B3_H)
var_pl4 = variance(PANIMAGERIC_B4_H)

mean_pl1 = mean(PANIMAGERIC_B1_H)
mean_pl2 = mean(PANIMAGERIC_B2_H)
mean_pl3 = mean(PANIMAGERIC_B3_H)
mean_pl4 = mean(PANIMAGERIC_B4_H)

mean_ms1 = mean(MS(*,*,0))
mean_ms2 = mean(MS(*,*,1))
mean_ms3 = mean(MS(*,*,2))
mean_ms4 = mean(MS(*,*,3))

ms1pl_cov = mean((MS(*,*,0) - mean_ms1)*(PANIMAGERIC_B1_H - mean_pl1)) ;
ms2pl_cov = mean((MS(*,*,1) - mean_ms2)*(PANIMAGERIC_B2_H - mean_pl2)) ;
ms3pl_cov = mean((MS(*,*,2) - mean_ms3)*(PANIMAGERIC_B3_H - mean_pl3)) ;
ms4pl_cov = mean((MS(*,*,3) - mean_ms4)*(PANIMAGERIC_B4_H - mean_pl4)) ;

G1 = ms1pl_cov/var_pl1
G2 = ms2pl_cov/var_pl2
G3 = ms3pl_cov/var_pl3
G4 = ms4pl_cov/var_pl4
;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;       Fuse     ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
DELTA_PAN_B1 = IM1CROPPAN - PANIMAGERIC_B1_H
DELTA_PAN_B2 = IM1CROPPAN - PANIMAGERIC_B2_H
DELTA_PAN_B3 = IM1CROPPAN - PANIMAGERIC_B3_H
DELTA_PAN_B4 = IM1CROPPAN - PANIMAGERIC_B4_H

GAIN_PAN_B1 = G1*DELTA_PAN_B1
GAIN_PAN_B2 = G2*DELTA_PAN_B2
GAIN_PAN_B3 = G3*DELTA_PAN_B3
GAIN_PAN_B4 = G4*DELTA_PAN_B4

FUSED_MS = intarr(DIM(0),DIM(1),4)

FUSED_MS(*, *,0) = GAIN_PAN_B1 + MS(*,*,0)
FUSED_MS(*, *,1) = GAIN_PAN_B2 + MS(*,*,1)
FUSED_MS(*, *,2) = GAIN_PAN_B3 + MS(*,*,2)
FUSED_MS(*, *,3) = GAIN_PAN_B4 + MS(*,*,3)

RGB_Image = FUSED_MS[*,*,0:2]
;Visualizzo l'immagine RGB finale
im = image(RGB_Image)
end