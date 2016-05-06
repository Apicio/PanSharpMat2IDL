function fresize, image, N
  DIM = size(image, /DIMENSIONS)
  UPSAMPLED_IMAGE = intarr(DIM(0),DIM(1))
  DOWNSAMPLED_IMAGE = image[0:*:N,0:*:N]
  UPSAMPLED_IMAGE[0:*:N,0:*:N] = DOWNSAMPLED_IMAGE
  TRASFORMED_IMAGE = fft(UPSAMPLED_IMAGE, -1)
  dim1 = DIM(0)/(N*2)
  dim2 = DIM(0)-2*dim1
  H1 = intarr(dim1,dim1)+1
  H0_1 = intarr(dim2,dim1)
  H0_2 = intarr(dim1,dim2)
  H0_3 = intarr(dim2,dim2)
  H = N*[[H1, H0_1, H1],[H0_2, H0_3, H0_2],[H1, H0_1, H1]] ; Filtro
  TRASFORMED_IMAGE_RIC = TRASFORMED_IMAGE*H
  IMAGERIC = REAL_PART(fft(TRASFORMED_IMAGE_RIC, 1)) ; anti trasformata
  return, IMAGERIC
end