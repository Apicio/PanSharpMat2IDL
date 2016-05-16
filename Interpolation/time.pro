@paths.pro
RESTORE, PATH_TO_FILE
N = 3
L = size(IM2CROPMS1P, /DIMENSIONS)
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Cubic Filter ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
Nterms = 22
Coeff = DIGITAL_FILTER(0, 1./N, 50, Nterms)
h = Coeff/max(Coeff)
hsq = h#TRANSPOSE(h)
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Interpolate  ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
UVIMAGE = intarr(N*L(0),N*L(1))
BLUIMAGE = intarr(N*L(0),N*L(1))
GREENIMAGE = intarr(N*L(0),N*L(1))
REDIMAGE = intarr(N*L(0),N*L(1))

; UVIMAGE = IM2CROPMS1P
UVIMAGE[0:*:N,0:*:N] = IM2CROPMS1P
UVIMAGERIC = CONVOL_FFT(UVIMAGE, hsq, /CORRELATE)
s = image(UVIMAGERIC)
print, mean(UVIMAGERIC)

;BLUIMAGE = IM3CROPMS1
BLUIMAGE[0:*:N,0:*:N] = IM3CROPMS1
BLUIMAGERIC = CONVOL_FFT(BLUIMAGE, hsq, /CORRELATE)
s = image(BLUIMAGERIC)
print, mean(BLUIMAGERIC)

;GREENIMAGE = IM4CROPMS2
GREENIMAGE[0:*:N,0:*:N] = IM4CROPMS2
GREENIMAGERIC = CONVOL_FFT(GREENIMAGE, hsq, /CORRELATE)
s = image(GREENIMAGERIC)
print, mean(GREENIMAGERIC)

;REDIMAGE = IM5CROPMS3
REDIMAGE[0:*:N,0:*:N] = IM5CROPMS3
REDIMAGERIC = CONVOL_FFT(REDIMAGE, hsq, /CORRELATE)
s = image(REDIMAGERIC)
print, mean(REDIMAGERIC)

SAVE, FILENAME = PATH_TO_SAVE_RIC+'data_interpolated_time.sav', im1CropPAN, UVIMAGERIC, BLUIMAGERIC, GREENIMAGERIC, REDIMAGERIC
end