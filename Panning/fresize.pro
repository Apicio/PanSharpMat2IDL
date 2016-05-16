function fresize, image, N
  DIM = size(image, /DIMENSIONS)
  UPSAMPLED_IMAGE = intarr(DIM(0),DIM(1))
  DOWNSAMPLED_IMAGE = image[0:*:N,0:*:N]
  UPSAMPLED_IMAGE[0:*:N,0:*:N] = DOWNSAMPLED_IMAGE
  TRASFORMED_IMAGE = fft(UPSAMPLED_IMAGE, -1)
  dim1 = DIM(0)/(N*2)
  dim2 = DIM(0)-2*dim1
  H1 = (dblarr(dim1,dim1)+1)*0;
  ; filtro isotropico
  for i=0,dim1-1 do begin
    for j = 0, dim1-1 do begin
      if (i^2+j^2) LT dim1^2-1  then begin
        H1(j,i) = N
      endif
    endfor
  endfor
  H0_1 = dblarr(dim2,dim1)
  H0_2 = dblarr(dim1,dim2)
  H0_3 = dblarr(dim2,dim2)
  H = N*[[H1, H0_1, ROTATE(H1,1)],[H0_2, H0_3, H0_2],[ROTATE(H1,-1), H0_1, ROTATE(H1,2)]] ; Filtro
  TRASFORMED_IMAGE_RIC = TRASFORMED_IMAGE*H
  IMAGERIC = REAL_PART(fft(TRASFORMED_IMAGE_RIC, 1)) ; anti trasformata
  return, IMAGERIC
end