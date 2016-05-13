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
;tmp[WHERE(tmp GT 1 )]=1
SAM_map = acos(prod_scal/prod_norm)
; metto le due matrici, rispettivamente quella del prodotto scalare e quella della norma, in due vettori
v1_scal =prod_scal(*)
v2_norm =prod_norm(*)


z = where(v2_norm eq 0)
if z NE -1 then begin
  dimz = size(z,/dimension)
  dimv = size(v1_scal,/dimension)
  for i=dimz(1),0,-1  do begin
    v2_norm[z(i):*] =v2_norm[z(i)+1:*]
    v1_scal[z(i):*] =v1_scal[z(i)+1:*]
  endfor
  tmp = DBLARR(dimv-dimz)
  tmp = v2_norm(0:(dimv-dimz))
  v2_norm = tmp
  tmp = v1_scal(0:(dimv-dimz))
  v1_scal = tmp 
endif

S = size(v2_norm) ;calcolo la dimensione del vettore prod_norm2
size_v2_norm = S[1] ; la dimensione corrisponde all'elemento di indice 2 nel vettore S 

; calcolo l'angolo
angle = TOTAL(TOTAL(acos(v1_scal/v2_norm)))/size_v2_norm
; calcolo l'indice SAM
SAM_index = angle*180/3.1416

return, SAM_index
end 
