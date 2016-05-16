function Scc_Index, GroundTruth, Fused
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  SCC Spatial Cross-Correlation  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mi = Ground Truth
;; M =  Immagine Fusa
;Prendo il numero di bande delle immagini
s = size(Fused,/dimension)
M = DBLARR(s(0),s(1),s(2))
Mi = DBLARR(s(0),s(1),s(2))
Nb = s(2)

; Prima di procedere al calcolo dell'indice, effettuo il filtraggio con Sobel di entrambe le immagini

M(*,*,0) = sobel(Fused(*,*,0))
M(*,*,1) = sobel(Fused(*,*,1))
M(*,*,2) = sobel(Fused(*,*,2))
M(*,*,3) = sobel(Fused(*,*,3))

Mi(*,*,0) = sobel(GroundTruth(*,*,0))
Mi(*,*,1) = sobel(GroundTruth(*,*,1))
Mi(*,*,2) = sobel(GroundTruth(*,*,2))
Mi(*,*,3) = sobel(GroundTruth(*,*,3))

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