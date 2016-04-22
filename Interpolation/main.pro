@paths.pro
RESTORE, PATH_TO_FILE
L = 256
N = 3
; magnifiedIm = CONGRID(IM2CROPMS1P, 768, 768, /INTERP)
; im2 = IMAGE(magnifiedIm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Espansione nel tempo UPSAMPLING ;; ; xEsp = upsample(xT,N);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ; XESP = fft(xEsp,N*L);
UVIMAGE = intarr(N*L,N*L)
BLUIMAGE = intarr(N*L,N*L)
GREENIMAGE = intarr(N*L,N*L)
REDIMAGE = intarr(N*L,N*L)
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
H1 = (intarr(dim1,dim1)+1)*N;
H0_1 = intarr(dim2,dim1)
H0_2 = intarr(dim1,dim2)
H0_3 = intarr(dim2,dim2)
H = [[H1, H0_1, H1],[H0_2, H0_3, H0_2],[H1, H0_1, H1]] ; Filtro
 
transformed_UVIMAGE_RIC = transformed_UVIMAGE*H ;prodotto elemento per elemento
transformed_BLUIMAGE_RIC = transformed_BLUIMAGE*H
transformed_GREENIMAGE_RIC = transformed_GREENIMAGE*H
transformed_REDIMAGE_RIC = transformed_REDIMAGE*H

UVIMAGERIC = fft(transformed_UVIMAGE_RIC, 1) ; anti trasformata
im = IMAGE(UVIMAGERIC) 
BLUIMAGERIC = fft(transformed_BLUIMAGE_RIC, 1)
im = IMAGE(BLUIMAGERIC)
GREENIMAGERIC = fft(transformed_GREENIMAGE_RIC, 1)
im = IMAGE(GREENIMAGERIC)
REDIMAGERIC = fft(transformed_REDIMAGE_RIC, 1) 
im = IMAGE(REDIMAGERIC)

SAVE, FILENAME = PATH_TO_SAVE_RIC+'data_interpolated.sav', im1CropPAN, UVIMAGERIC, BLUIMAGERIC, GREENIMAGERIC, REDIMAGERIC
end