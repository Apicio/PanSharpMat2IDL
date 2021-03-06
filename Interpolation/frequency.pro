@paths.pro
RESTORE, PATH_TO_FILE
L = 256 
N = 3
; magnifiedIm = CONGRID(IM2CROPMS1P, 768, 768, /INTERP)
; im2 = IMAGE(magnifiedIm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Espansione nel tempo UPSAMPLING ;; ; xEsp = upsample(xT,N);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ; XESP = fft(xEsp,N*L);
UVIMAGE = DBLARR(N*L,N*L)
BLUIMAGE = DBLARR(N*L,N*L)
GREENIMAGE = DBLARR(N*L,N*L)
REDIMAGE = DBLARR(N*L,N*L)
UVIMAGE[0:*:N,0:*:N] = IM2CROPMS1P ; si prendono tutte le righe (risp colonne) da 0 fino alla fine (*) con passo N
                                   ; gli si assegna la matrice originale per l'espazione
;im = IMAGE(UVIMAGE)               ; visualizziamo il risultato
BLUIMAGE[0:*:N,0:*:N] = IM3CROPMS1 
;im = IMAGE(BLUIMAGE) 
GREENIMAGE[0:*:N,0:*:N] = IM4CROPMS2
;im = IMAGE(GREENIMAGE)
REDIMAGE[0:*:N,0:*:N] = IM5CROPMS3
;im = IMAGE(REDIMAGE)

transformed_UVIMAGE = fft(UVIMAGE, -1) ;e^-1 -> trasformata diretta, con segno positivo trasformata inversa
transformed_BLUIMAGE = fft(BLUIMAGE, -1)
transformed_GREENIMAGE = fft(GREENIMAGE, -1)
transformed_REDIMAGE = fft(REDIMAGE, -1)
;;;;;;;;;;;;;;;;;;; ;H = [N*ones(1,L/N),zeros(1,2*L/N),N*ones(1,L/N)];
;; Ricostruzione ;; ;XRIC = XESP.*H;
;;;;;;;;;;;;;;;;;;; ;xRic = ifft(XRIC);
dim1 = 128
dim2 = 512
H1 = (dblarr(dim1,dim1)+1)*0;
; filtro isotropico
for i=0,dim1-1 do begin
  for j = 0, dim1-1 do begin
    if (i^2+j^2) LT dim1^2-1  then begin
      H1(j,i) = N
    endif
  endfor
endfor
H0_1 = dblarr(dim2,dim1)
H0_2 = dblarr(dim1,dim2)
H0_3 = dblarr(dim2,dim2)
H = N*[[H1, H0_1, ROTATE(H1,1)],[H0_2, H0_3, H0_2],[ROTATE(H1,-1), H0_1, ROTATE(H1,2)]] ; Filtro
 
transformed_UVIMAGE_RIC = transformed_UVIMAGE*H ;prodotto elemento per elemento
transformed_BLUIMAGE_RIC = transformed_BLUIMAGE*H
transformed_GREENIMAGE_RIC = transformed_GREENIMAGE*H
transformed_REDIMAGE_RIC = transformed_REDIMAGE*H

UVIMAGERIC = REAL_PART(fft(transformed_UVIMAGE_RIC, 1)) ; anti trasformata
im = IMAGE(UVIMAGERIC) 
BLUIMAGERIC = REAL_PART(fft(transformed_BLUIMAGE_RIC, 1))
im = IMAGE(BLUIMAGERIC)
GREENIMAGERIC = REAL_PART(fft(transformed_GREENIMAGE_RIC, 1))
im = IMAGE(GREENIMAGERIC)
REDIMAGERIC = REAL_PART(fft(transformed_REDIMAGE_RIC, 1)) 
im = IMAGE(REDIMAGERIC)

print, mean(UVIMAGERIC)
print, mean(BLUIMAGERIC)
print, mean(GREENIMAGERIC)
print, mean(REDIMAGERIC)

SAVE, FILENAME = PATH_TO_SAVE_RIC+'data_interpolated_frequency.sav', im1CropPAN, UVIMAGERIC, BLUIMAGERIC, GREENIMAGERIC, REDIMAGERIC
end