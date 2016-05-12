function sam, Mi, M
; Mi = Ground Truth
; M = Fused Image


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  SAM - Spectral Angle Mapper ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; SAM is a physically-based spectral classification that uses an n-dimensional angle to match
; pixels to reference spectra. Smaller angle represent closer matches to the reference spectrum.

prod_scal = (dot_3dim(Mi,M)) ; calcolo il prodotto scalare utilizzando la funzione dot_3dim
norm_orig = (dot_3dim(Mi,Mi)) ; calcolo la norma dell'immagine originale
norm_fusa = (dot_3dim(M,M)) ; calcolo la norma dell'immagine fusa

prod_norm = sqrt((norm_orig*norm_fusa))
;prod_norm può contenere degli 0. Li sostituiamo col numero più piccolo rappresentabile in IDL.
;m = machar()
;prod_norm[WHERE(prod_norm EQ 0)] = m.EPS
; calcolo mappatura, formula presa dalle slides
tmp = prod_scal/prod_norm
tmp[WHERE(tmp GT 1 )]=1
SAM_map = acos(TMP)
;!!!!!!!PROBLEMA: prod_scal/prod_norm esce >1!!!!!!!!!


; metto le due matrici, rispettivamente quella del prodotto scalare e quella della norma, in due vettori
tmp = transpose(prod_scal)
prod_scal2 = transpose((tmp(*)))

tmp2 = transpose(prod_norm)
prod_norm2 = transpose((tmp2(*)))

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
