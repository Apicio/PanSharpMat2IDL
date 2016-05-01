function extend, x, left,right
  ;estende una matrice x copiando le righe e le colonne verso left e right

  s=size(x)
  up=left
  down=right
  c=x

  ;;;;;;;;;;;;;;COPIA SU COLONNE
  c=[indgen(left,s(2),s(3))*0,x,indgen(right,s(2),s(3))*0]
  ii=0
  for i = left-1,0,-1 do begin
    ii=ii+1;
    if(ii ge s(1)-1) then ii=0 ;reset dell'indice
    c(i,*,*)=x(ii,*,*)
  endfor

  ii=s(1)-1
  for i =left+s(1),right+left+s(1)-1 do begin
    ii=ii-1
    if(ii le -1) then ii=s(1)-1 ;reset dell'indice
    c(i,*,*)=x(ii,*,*)
  endfor

  ;;;;;;;;;;;;;;COPIA SU RIGHE
  sc=size(c)
  result=[[indgen(sc(1),up,s(3))*0],[c],[indgen(sc(1),down,s(3))*0]]
  ii=0
  for i = up-1,0,-1 do begin
    ii=ii+1;
    if(ii ge sc(2)-1) then ii=0 ;reset dell'indice
    result(*,i,*)=c(*,ii,*)
  endfor

  ii=s(2)-1
  for i=up+sc(2),down+up+sc(2)-1 do begin
    ii=ii-1;
    if(ii le -1) then ii=s(2)-1 ;reset dell'indice
    result(*,i,*)=c(*,ii,*)
  endfor

  return, result
end