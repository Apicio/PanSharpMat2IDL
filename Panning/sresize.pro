function sresize, image_in, N
  ; Otteniamo le dimensioni dell'immagine di input.
  DIM = size(image_in, /DIMENSIONS)
  ; Come da schema, riportato in relazione, vi è necessità di fare una decimazione.
  UPSAMPLED_IMAGE = DBLARR(DIM(0),DIM(1))
  start = 0;floor(N/2)+1
  DOWNSAMPLED_IMAGE = image_in[start:*:N,start:*:N]
  UPSAMPLED_IMAGE[start:*:N,start:*:N] = DOWNSAMPLED_IMAGE
  ; Si definisce criterio di interpolazione spaziale. L'obiettivo è quello di approssimare la formula interpolante di Shannon
  ; tramite la definizione di una approssimazione della sinc usando polinomi di ordine 3.
  Nterms = 22
  ; Coeff = DIGITAL_FILTER(Flow, Fhigh, A, Nterms) dove:
  ; Fhigh-Flow definisce la banda passante del filtro,
  ; A Potenza del filtro: 50 db
  ; Nterms*2 numero di elementi del filtro.
  Coeff = DIGITAL_FILTER(0, 1./N, 50, Nterms)
  ; Dividiamo per il max in modo da avere un filtro a media unitaria, e quindi non alterare la componente continua dell'immagine.
  h = Coeff/max(Coeff)
  hsq = h#TRANSPOSE(h)
  ; Convoluzione del filtro, operazione effettuata in frequenza per evitare di estendere e poi croppare l'immagine originale.
  IMAGERIC = CONVOL_FFT(UPSAMPLED_IMAGE, hsq, /CORRELATE)
  return, IMAGERIC
end