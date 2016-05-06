function q4n_extend, x, y, block=block

  if KEYWORD_SET(block) then begin
    block=block
  endif else begin
    block=32
  endelse
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  old_percentuale=0;

  x=extend(x,floor(block/2),ceil(block)/2);
  y=extend(y,floor(block/2),ceil(block)/2);
  s=size(x)
  L1f=floor(s(1)-Block);
  L2f=floor(s(2)-Block);
  q=findgen(L1f,L2f)

  for i = 0,L2f-1 do begin
    for j = 0,L1f-1 do begin

      x_ref=transpose(reform(x[j:j+Block-1,i:i+Block-1,*],Block^2,4)) ; x_ref sarà una matrice bidimensionale N x N.bande
      y_ref=transpose(reform(y[j:j+Block-1,i:i+Block-1,*],Block^2,4)) ;

      x_mean=mean(x_ref,DIMENSION=2) ;equivale a x_mean=[mean(x[*,*,0]),mean(x[*,*,1]),mean(x[*,*,2])] ;vettore 1x N.bande
      y_mean=mean(y_ref,DIMENSION=2)

      mz1=norm(x_mean); ;scalare
      mz2=norm(x_mean);

      ;(indgen(1,(Finish-Start+1)^2)*0+1)=vettore di tutti 1; vettore N*1, a cui viene fatto un prodotto matriciale con la media di x(vettore 1*nBande)
      ;la seconda istruzione crea una matrice N*nBande in cui c'è la media(iesima) per ogni colonna;
      ;al fine poter sottrarre alla matrice originale la media per ogni banda
      e1=x_ref-(indgen(1,s(1)*s(2))*0+1)##x_mean
      e2=y_ref-(indgen(1,s(1)*s(2))*0+1)##y_mean

      sz1=mean(hyp4_scalar(e1)) ;varianzaX=media del vettore[(x- Mu)*(x-Mu)]
      sz2=mean(hyp4_scalar(e2));
      sz1z2=norm(mean(hyp4_scalar(e1,e2),DIMENSION=2));

      q(j,i)=4*sz1z2/(sz1+sz2)*mz1*mz2/(mz1^2+mz2^2)
    endfor

    percentuale=(FLOAT(i)/FLOAT((s(2)-Block-1)))*100;
    if  percentuale ge old_percentuale +5 then begin
      old_percentuale=percentuale
      print , 'Percentuale Q4N: ', percentuale, '%'
    endif
  endfor
  print , 'Percentuale Q4N: 100%
  return, mean(q)
end