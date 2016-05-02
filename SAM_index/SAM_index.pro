function sam, Mi, M
; Mi = Ground Truth
; M = Fused Image


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  SAM - Spectral Angle Mapper ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; SAM is a physically-based spectral classification that uses an n-dimensional angle to match
; pixels to reference spectra. Smaller angle represent closer matches to the reference spectrum.

prod_scal = LONG(dot_3dim(Mi,M)) ; calcolo il prodotto scalare utilizzando la funzione dot_3dim
norm_orig = LONG(dot_3dim(Mi,M)) ; calcolo la norma dell'immagine originale
norm_fusa = LONG(dot_3dim(Mi,M)) ; calcolo la norma dell'immagine fusa

prod_norm = sqrt(norm_orig*norm_fusa)
; calcolo mappatura, formula presa dalle slides
SAM_map = mean(abs(acos(prod_scal/prod_norm)))

; metto le due matrici, rispettivamente quella del prodotto scalare e quella della norma, in due vettori
tmp = transpose(prod_scal)
prod_scal2 = transpose(LONG(tmp(*)))

tmp2 = transpose(prod_norm)
prod_norm2 = transpose(LONG(tmp2(*)))

;z = where(prod_norm2 eq 0)
;prod_scal2[z] = prod_scal2
;prod_norm2[z] = prod_norm2

S = size(prod_norm2) ;calcolo la dimensione del vettore prod_norm2
size_prod_norm2 = S[2] ; la dimensione corrisponde all'elemento di indice 2 nel vettore S 

; calcolo l'angolo
angle = TOTAL(TOTAL(acos(FLOAT(prod_scal2)/FLOAT(prod_norm2))))/size_prod_norm2
; calcolo l'indice SAM
SAM_index = angle*180/3.1416

return, SAM_index
end 
