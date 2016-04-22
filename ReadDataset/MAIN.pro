PATH = 'C:\Users\Leonardo\Dropbox\Magistrale\Telerilevamento\ProgettoPanSharp\dataset.hdf';
HDFID = hdf_sd_start(PATH)
hdf_sd_fileinfo, HDFID, nvars, ngatts
varnames=NomiVariabiliHDF(hdfid)
cutDim = [256*3, 256*3]
startCoords = [1701,5502]

;;;;;;;;; PAN ;;;;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'PAN_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
CroppedIm1 = dati(1701:1701+cutDim[0], 5502-cutDim[1]:5502 )
im1Crop = IMAGE(CroppedIm1)
hdf_sd_endaccess, varid

;;;;;;;;;;  UV   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'UV_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im2 = IMAGE(dati)
CroppedIm2 = dati(startCoords[0]/3:startCoords[0]/3+cutDim[0]/3, startCoords[1]/3-cutDim[1]/3:startCoords[1]/3 )
im2Crop = IMAGE(CroppedIm2)
hdf_sd_endaccess, varid

;;;;;;;;;;  blue  ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'BLUE_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im3 = IMAGE(dati)
CroppedIm3 = dati(startCoords[0]/3:startCoords[0]/3+cutDim[0]/3, startCoords[1]/3-cutDim[1]/3:startCoords[1]/3 )
im3Crop = IMAGE(CroppedIm3)
hdf_sd_endaccess, varid
;
;;;;;;;;;;;  green   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'GREEN_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im4 = IMAGE(dati)
CroppedIm4 = dati(startCoords[0]/3:startCoords[0]/3+cutDim[0]/3, startCoords[1]/3-cutDim[1]/3:startCoords[1]/3 )
im4Crop = IMAGE(CroppedIm4)
hdf_sd_endaccess, varid

;;;;;;;;;;;  red   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'RED_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im5 = IMAGE(dati)
CroppedIm5 = dati(startCoords[0]/3:startCoords[0]/3+cutDim[0]/3, startCoords[1]/3-cutDim[1]/3:startCoords[1]/3 )
im5Crop = IMAGE(CroppedIm5)
hdf_sd_endaccess, varid

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hdf_sd_end, hdfid

end