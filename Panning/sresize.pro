function sresize, image_in, N
  DIM = size(image_in, /DIMENSIONS)/N
  DOWNSAMPLED_IMAGE = image_in[0:*:N,0:*:N]
  L = DIM(0)
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;; Cubic Filter ;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  dim = round((1-1/N)*N)
  t = indgen(dim)/N + 1/N
  h1 = 1.5*t^3 - 2.5*t^2 + 1
  t = (indgen(dim+1)/N)+1
  h2 = -0.5*t^3+2.5*t^2-4*t+2
  h=[REVERSE(h2),REVERSE(h1),1,h1,h2];
  Lh=size(h, /N_ELEMENTS)
  hsq = h#TRANSPOSE(h)
  tcrp = 5;
  
  ;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;;; Interpolate  ;;;;;;;
  ;;;;;;;;;;;;;;;;;;;;;;;;; 
  RIMAGE = intarr((L-1)*N+Lh+1,(L-1)*N+Lh+1)
  for j=1,L DO BEGIN
    for i=1,L DO BEGIN; i2 = i
      RIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) = RIMAGE((j-1)*N+1:(j-1)*N+Lh , (i-1)*N+1:(i-1)*N+Lh) + DOWNSAMPLED_IMAGE[j-1,i-1]*hsq;
    endfor
  endfor
  IMAGERIC = RIMAGE(tcrp:N*L-1-tcrp,tcrp:N*L-1-tcrp)
  return, IMAGERIC
end