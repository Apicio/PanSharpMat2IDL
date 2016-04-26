@paths.pro
RESTORE, PATH_TO_FILE
L = 256
N = 3.
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Cubic Filter ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;
dim = round((1-1/N)*N)
t = indgen(dim)/N + 1/N
h1 = 1.5*t^3 - 2.5*t^2 + 1
t = (indgen(dim+1)/N)+1
h2 = -0.5*t^3+2.5*t^2-4*t+2
h=[REVERSE(h2),REVERSE(h1),1,h1,h2];
Lh=size(h, /N_ELEMENTS)
hsq = h#TRANSPOSE(h)
tcrp = 5;
;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Interpolate  ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;

; UVIMAGE = IM2CROPMS1P
UVIMAGE = intarr((L-1)*N+Lh+1,(L-1)*N+Lh+1)
for j=1,L DO BEGIN
  for i=1,L DO BEGIN; i2 = i
     UVIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) = UVIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) + IM2CROPMS1P(j-1,i-1)*hsq;
  endfor
endfor
UVIMAGE = UVIMAGE(tcrp:N*L-1-tcrp,tcrp:N*L-1-tcrp)
im = IMAGE(UVIMAGE)

;BLUIMAGE = IM3CROPMS1 
BLUIMAGE = intarr((L-1)*N+Lh+1,(L-1)*N+Lh+1)
for j=1,L DO BEGIN
  for i=1,L DO BEGIN; i2 = i
    BLUIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) = BLUIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) + IM3CROPMS1(j-1,i-1)*hsq;
  endfor
endfor
BLUIMAGE = BLUIMAGE(tcrp:N*L-1-tcrp,tcrp:N*L-1-tcrp)
im = IMAGE(BLUIMAGE)

;GREENIMAGE = IM4CROPMS2
GREENIMAGE = intarr((L-1)*N+Lh+1,(L-1)*N+Lh+1)
for j=1,L DO BEGIN
  for i=1,L DO BEGIN; i2 = i
    GREENIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) = GREENIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) + IM4CROPMS2(j-1,i-1)*hsq;
  endfor
endfor
GREENIMAGE = GREENIMAGE(tcrp:N*L-1-tcrp,tcrp:N*L-1-tcrp)
im = IMAGE(GREENIMAGE)

;REDIMAGE = IM5CROPMS3
REDIMAGE = intarr((L-1)*N+Lh+1,(L-1)*N+Lh+1)
for j=1,L DO BEGIN
  for i=1,L DO BEGIN; i2 = i
    REDIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) = REDIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) + IM5CROPMS3(j-1,i-1)*hsq;
  endfor
endfor
REDIMAGE = REDIMAGE(tcrp:N*L-1-tcrp,tcrp:N*L-1-tcrp)
im = IMAGE(REDIMAGE)

end