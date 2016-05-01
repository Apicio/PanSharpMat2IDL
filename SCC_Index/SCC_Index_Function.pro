function Scc, Mi, M
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  SCC Spatial Cross-Correlation  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Mi = Ground Truth
;; M =  Immagine Fusa
M = MS
Mi = MS
;Prendo il numero di bande delle immagini
s = size(M)
Nb = s(3)

; Calcolo prima la sommatoria che va da 1 al numero di bande 
; (((Contrary to popular misconception, you can use a for loop 
; in a command file, but you have to put the special characters &$ 
; at the end of each line to tell IDL that the statements are in a group....bah -.- )))
sommatoria = 0
for i = 0, Nb-1,1 do begin &$
  ; Prelevo l'i-esima matrice dalle immagini
  M_i = M(*,*,i) &$
  Mi_i = Mi(*,*,i) &$
  
  ; Calcolo co-varianza
  M_i_mean = mean(M_i) &$
  Mi_i_mean = mean(Mi_i) &$
  M_Mi_i_cov = mean((M_i-mean(M_i))*(Mi_i-mean(Mi_i))) &$

  ; Calcolo varianza
  M_i_var = variance(M_i) &$
  Mi_i_var = variance(Mi_i) &$
  
  ; Calcolo il rapporto (senza la costante moltiplicativa davanti)
  sommatoria = sommatoria + (M_Mi_i_cov/(M_i_var*Mi_i_var)) &$   
endfor

; Calcolo il risultato finale (con la costante 1 / Nb davanti)
Scc = (1/Nb)*sommatoria

return, Scc
end