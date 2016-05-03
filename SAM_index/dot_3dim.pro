function dot_3DIM, I1,I2


sizes=size(I1)
res=indgen(sizes(1),sizes(2))
c1=indgen(sizes(3))
c2=indgen(sizes(3))


for i = 0,sizes(1)-1,1 do begin
  for j = 0,sizes(2)-1,1 do begin
   c1(*)=I1(i,j,*)
   c2(*)=I2(i,j,*)
res(i,j)=c1##transpose(c2)

endfor
endfor


return, res
end