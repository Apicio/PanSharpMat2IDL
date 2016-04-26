;Importo il file .sav contenente le immagini relative ai 4 canali
restore, 'data_interpolated.sav'
;Acquisisco la dimensione di una delle immagini (matrici) per settare la struttura utile alla fusione delle immagini
s = size(redimageric)
;Definisco un array di matrici che conterrà tutti e 4 i canali
Matrix_Array = indgen(s(1), s(2),4) ;The INDGEN function returns an array with the specified dimensions. 
                               ;Each element of the array is set to the value of its one-dimensional subscript. 
Matrix_Array(*, *,0) = redimageric
Matrix_Array(*, *,1) = greenimageric
Matrix_Array(*, *,2) = bluimageric
Matrix_Array(*, *,3) = uvimageric

;Estraggo le prime 3 matrici per visualizzare l'immagine RGB risultante
RGB_Image = Matrix_Array[*,*,0:2]
;Visualizzo l'immagine RGB finale
image(RGB_Image)
