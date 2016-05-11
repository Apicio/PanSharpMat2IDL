function q4n_extend, x, y, block=block
  ;+
  ; NAME:
  ;    q4n_extend
  ;
  ; PURPOSE:
  ;    Calcolare l'indice di qualità Q4N tra due immagini con 4 Bande
  ;
  ;
  ; INPUTS:
  ;    x       Rappresenta la prima immagine
  ;    y       Rappresenta la seconda immagine
  ;
  ; OPTIONAL INPUTS:
  ;    block   Parametro opzionale che rappresenta il blocco su cui verrà applicato localmente il Q4N
  ;
  ; OUTPUTS:
  ;    Il valore di ritorno è l'indice di qualità Q4N associato alle due immagini x e y
  ;
  ; SIDE EFFECTS:
  ;    La dimensione del blocco deve essere imposta in modo coerente:
  ;    aumentando il blocco si ottiene una velocità computazionale a scapito della finezza del risultato del Q4N
  ;
  ;
  ;-
  ;
  ;;Controllo il parametro opzionale
  if KEYWORD_SET(block) then begin
    block=block
  endif else begin
    block=32
  endelse

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  old_percentuale=0; Percentuale di completamento

  ;viene estesa l'immagine aggiungendo allaragandola di block/2 a destra a sinistra in alto e in basso
  ;Extend ci serve per poter mediare la finestra di blocco, in modo da pesare i campioni adiacenti a (0,0), 
  ;dal momento che la finestra la possiamo vedre come una sorta di convoluzione e quindi che si sposta nello spazio
  x=extend(x,floor(block/2),ceil(block)/2); //floor arrotonda per difetto; ceil per eccesso
  y=extend(y,floor(block/2),ceil(block)/2);
  s=size(x) ;sarà di dimensione +block per riga e colonne
  L1f=floor(s(1)-Block); n colonne originali di x
  L2f=floor(s(2)-Block); n righe originali di x
  q=findgen(L1f,L2f) ; matrice indice di qualità

  print , 'Percentuale Q4N: 0%
  for i = 0,L2f-1 do begin
    for j = 0,L1f-1 do begin

      x_ref=transpose(reform(x[j:j+Block-1,i:i+Block-1,*],Block^2,4)) ; x_ref sarà una matrice bidimensionale N(=block*block) x N.bande
      y_ref=transpose(reform(y[j:j+Block-1,i:i+Block-1,*],Block^2,4)) ;
      x_ref_size=size(x_ref)
      x_mean=mean(x_ref,DIMENSION=2) ;equivale a x_mean=[mean(x[*,*,0]),mean(x[*,*,1]),mean(x[*,*,2])] ;vettore 1x N.bande
      y_mean=mean(y_ref,DIMENSION=2)
      
      mz1=norm(x_mean); ;scalare
      mz2=norm(x_mean);

      ;(indgen(1,(Finish-Start+1)^2)*0+1)=vettore di tutti 1; vettore N*1, a cui viene fatto un prodotto matriciale con la media di x(vettore 1*nBande)
      ;la seconda istruzione crea una matrice N*nBande in cui c'è la media(iesima) per ogni colonna;
      ;al fine poter sottrarre alla matrice originale la media per ogni banda
      e1=x_ref-(indgen(1,x_ref_size(2))*0+1)##x_mean ;;fixed
      e2=y_ref-(indgen(1,x_ref_size(2))*0+1)##y_mean

      sz1=mean(hyp4_scalar(e1)) ;varianzaX=media del vettore[(x- Mu)*(x-Mu)]
      sz2=mean(hyp4_scalar(e2));
      sz1z2=norm(mean(hyp4_scalar(e1,e2),DIMENSION=2));
     

      q(j,i)=4*sz1z2/(sz1+sz2)*mz1*mz2/(mz1^2+mz2^2) ;formula q4n
    endfor

    ;;;CODICE PER CALCOLARE LA PERCENTUALE;;;;
    percentuale=(FLOAT(i)/FLOAT((s(2)-Block-1)))*100;
    if  percentuale ge old_percentuale +5 then begin
      old_percentuale=percentuale
      print , 'Percentuale Q4N: ', percentuale, '%'
    endif
  endfor
  print , 'Percentuale Q4N: 100%
  return, mean(q)
end