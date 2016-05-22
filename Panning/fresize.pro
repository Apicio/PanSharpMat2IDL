function fresize, image, N
  ; Otteniamo le dimensioni dell'immagine di input.
  DIM = size(image, /DIMENSIONS)
  ; Come da schema, riportato in relazione, vi è necessità di fare una decimazione.
  DOWNSAMPLED_IMAGE = image[0:*:N,0:*:N]
  UPSAMPLED_IMAGE = DBLARR(DIM(0),DIM(1))
  UPSAMPLED_IMAGE[0:*:N,0:*:N] = DOWNSAMPLED_IMAGE
  ; Il risultato dell'operazione precedente viene trasformato secondo Fourier
  TRASFORMED_IMAGE = fft(UPSAMPLED_IMAGE, -1)
  ; Definizione della dimensione del filtro. Esso dovrà avere la medesima dimensione dell'immagine originale.
  ; Assume valore diverso da zero negli angoli, laddove si trovano le basse frequenze. Il filtro è isotropoco, smussato nei lati.
  ; La procedura per la definizione di quest'ultimo è da considerarsi come un estensione del caso monodimensionale. 
  dim1 = DIM(0)/(N*2)
  dim2 = DIM(0)-2*dim1
  H1 = (dblarr(dim1,dim1)+1)*0;
  ; Costruzione del filtro isotropico usando l'espressione di una circonferenza.
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
  ; Applicazione del filtro
  TRASFORMED_IMAGE_RIC = TRASFORMED_IMAGE*H
  IMAGERIC = REAL_PART(fft(TRASFORMED_IMAGE_RIC, 1)) ; anti trasformata
  return, IMAGERIC
end