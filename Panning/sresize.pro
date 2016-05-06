function sresize, image_in, N
  DIM = size(image_in, /DIMENSIONS)
  UPSAMPLED_IMAGE = DBLARR(DIM(0),DIM(1))
  start = 0;floor(N/2)+1
  DOWNSAMPLED_IMAGE = image_in[start:*:N,start:*:N]
  UPSAMPLED_IMAGE[start:*:N,start:*:N] = DOWNSAMPLED_IMAGE
  Nterms = 22
  Coeff = DIGITAL_FILTER(0, 1./N, 50, Nterms)
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;; Cubic Filter ;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  h = Coeff/max(Coeff)
  hsq = h#TRANSPOSE(h)
  IMAGERIC = CONVOL_FFT(UPSAMPLED_IMAGE, hsq, /CORRELATE)
  return, IMAGERIC
end