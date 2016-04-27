;Importo il file .sav contenente le immagini relative ai 4 canali
@paths.pro
restore, PATH_TO_LOAD_RIC
;Acquisisco la dimensione di una delle immagini (matrici) per settare la struttura utile alla fusione delle immagini
s = size(redimageric)
;Definisco un array di matrici che conterrà tutti e 4 i canali
MS = indgen(s(1), s(2),4) ;The INDGEN function returns an array with the specified dimensions. 
                                    ;Each element of the array is set to the value of its one-dimensional subscript. 
MS(*, *,0) = redimageric
MS(*, *,1) = greenimageric
MS(*, *,2) = bluimageric
MS(*, *,3) = uvimageric

;Estraggo le prime 3 matrici per visualizzare l'immagine RGB risultante
RGB_Image = MS[*,*,0:2]
;Visualizzo l'immagine RGB finale
im = image(RGB_Image)
SAVE, FILENAME = PATH_TO_SAVE_MS+'data_ms.sav', im1CropPAN, MS
end