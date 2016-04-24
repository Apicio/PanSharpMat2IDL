@paths.pro
RESTORE, PATH_TO_LOAD_RIC
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Start = 50 ;cordinate to start to CUT x,y (MUST: Start-Rangex>0)
Finish = 500; cordinate to finish to CUT x,y
; range di oscillazione della finestra nelle due direzioni x y
Rangex = 3  ;range Rows of search alignment ;must be dispar
Rangey = 5  ;range Coloumn of search alignment
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; per verificare il corretto funzionamento dell'algoritmo modificare i seguenti parametri, 
; vanno a selezionare uno shift in modo da simulare lo sfasamento
debug_shift_y  = 1 ;in colonne
debug_shift_x = 2  ;in righe
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
imgPan_cut = im1CropPAN[Start+debug_shift_y:Finish+debug_shift_y,Start+debug_shift_x:Finish+debug_shift_x] ;cut ImagePan
Q_indexs = dblarr(Rangey*2+1,Rangex*2+1) ;colonne, righe

for i = -Rangex,Rangex do begin ;i*2+1
  for j = -Rangey,Rangey do begin
    imgMS_cut = REDIMAGERIC[Start+j:Finish+j,Start+i:Finish+i] ;cut and shift ImageRED
    Q_indexs(j+Rangey,i+Rangex) = q2n(imgPan_cut,imgMS_cut)    ;colonne-righe
  endfor
endfor

;print, Q_indexs
;Calcolo indici;
max_Q = max(Q_indexs) ; prendiamo il valore per il quale l'indice risulta massimo
print,'Quality of image: ', max_Q
index = where(Q_indexs eq max_Q) ; gestisce le matrici come un unico array ottenuto concatenando le righe, l'indice è restituito nell'intervallo [0, (2*Rangey+1)*(2*Rangex+1)-1]
j = index MOD (Rangey*2+1)   ; operatore modulo con n°Colonne
i = (index-j)/(Rangey*2+1)   ; index = i*n°Colonne + j
print, Q_indexs(j,i)

;Calcolo Errore
print, 'Errore: NColonna:   ',j-Rangey ;in perfetto allineamento il massimo si trova in 5,3
print, 'Errore: NRiga:      ',i-Rangex

;;;;;;;;;;;;;; immagine fusa;;;;
out=indgen(Finish-Start+1,Finish-Start+1,3)
out[*,*,0]=REDIMAGERIC[Start:Finish,Start:Finish]
out[*,*,1]=GREENIMAGERIC[Start:Finish,Start:Finish]
out[*,*,2]=im1CropPAN[Start:Finish,Start:Finish]
im = image(out)
end