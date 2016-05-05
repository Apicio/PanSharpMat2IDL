function Scc_Index, Mi, M
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  SCC Spatial Cross-Correlation  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mi = Ground Truth
;; M =  Immagine Fusa
;Prendo il numero di bande delle immagini
s = size(M)
Nb = s(3)

; Prima di procedere al calcolo dell'indice, effettuo il filtraggio con Sobel di entrmbe le immagini

M(*,*,0) = sobel(M(*,*,0))
M(*,*,1) = sobel(M(*,*,1))
M(*,*,2) = sobel(M(*,*,2))
M(*,*,3) = sobel(M(*,*,3))

Mi(*,*,0) = sobel(Mi(*,*,0))
Mi(*,*,1) = sobel(Mi(*,*,1))
Mi(*,*,2) = sobel(Mi(*,*,2))
Mi(*,*,3) = sobel(Mi(*,*,3))

; Calcolo prima la sommatoria che va da 1 al numero di bande 
sommatoria = 0
for i = 0, Nb-1,1 do begin 
  ; Prelevo l'i-esima matrice dalle immagini
  M_i = M(*,*,i) 
  Mi_i = Mi(*,*,i) 
  
  ; Calcolo co-varianza 
  M_Mi_i_cov = mean((M_i-mean(M_i))*(Mi_i-mean(Mi_i))) 

  ; Calcolo varianza
  M_i_var = variance(M_i) 
  Mi_i_var = variance(Mi_i) 
  
  ; Calcolo il rapporto (senza la costante moltiplicativa davanti)
  sommatoria = sommatoria + (M_Mi_i_cov/SQRT((M_i_var*Mi_i_var)))  
endfor

; Calcolo il risultato finale (con la costante 1 / Nb davanti che per convertirla in Float necessita del "." davanti al numeratore)
Scc_res = (1./Nb)*sommatoria

return, Scc_res
end