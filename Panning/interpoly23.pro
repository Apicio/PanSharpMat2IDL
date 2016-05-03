function interPoly23, i_in, ratio
sizes = size(i_in)
NBands = sizes(3)
cols = sizes(1)
rows = sizes(2)
CDF23_tmp = 2*[0.5, 0.305334091185, 0, -0.072698593239, 0, 0.021809577942, 0, -0.005192756653, 0, 0.000807762146, 0, -0.000060081482];
CDF23 = [REVERSE(CDF23_TMP(1:*)), CDF23_TMP]
first = 1;
for z = 1,ratio/2 do begin
  I1LRU = intarr( (2^z)*rows , (2^z)*cols , NBands )*0
  
  if first eq 1 then begin
  I1LRU(1:*:2 , 1:*:2 , *) = i_in ;espansione
  first = 0
  endif else begin
    I1LRU(0:*:2 , 0:*:2 , *) = i_in
  endelse
  
  for k =0,NBands-1 do begin
    t = I1LRU(*,*,k)
    t = TRANSPOSE(t)*CDF23
    I1LRU(*,*,k) =TRANSPOSE(t)*CDF23
  endfor
  
endfor
return, I1LRU
end