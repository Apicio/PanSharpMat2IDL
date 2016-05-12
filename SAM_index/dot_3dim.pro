;Effettua il prodotto scalare fra due matrici a tre dimensioni. Viene estratta una "carota" da entrambe le matrici, e poi
;viene fatto il prodotto scalare fra queste due carote. Il risultato è una matrice delle stesse dimensioni in altezza e 
;larghezza dei cubi in ingresso. 

function dot_3DIM, I1,I2

sizes=size(I1)
res=DBLARR(sizes(1),sizes(2))
c1=DBLARR(sizes(3))
c2=DBLARR(sizes(3))


for i = 0,sizes(1)-1,1 do begin
  for j = 0,sizes(2)-1,1 do begin
   c1 = I1(i,j,*)
   c2 = I2(i,j,*)
   res(i,j) = total(transpose(c1)#c2)
  endfor
endfor


return, res
end