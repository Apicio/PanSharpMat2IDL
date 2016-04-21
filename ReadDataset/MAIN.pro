;cd, 'Dropbox\Magistrale\Telerilevamento\ws_idl';
;image = read_tiff('dataset/EO1A1610762004302110PZ_B01_L1T.TIF',GEOTIFF=geotags);
HDFID = hdf_sd_start('C:\Users\Leonardo\Dropbox\Magistrale\Telerilevamento\ProgettoPanSharp\dataset.hdf')
hdf_sd_fileinfo, HDFID, nvars, ngatts
varnames=NomiVariabiliHDF(hdfid)
;;;;;;;;; PAN ;;;;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'PAN_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
hdf_sd_endaccess, varid
;;;;;;;;;;  UV   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'UV_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
hdf_sd_endaccess, varid
;;;;;;;;;;  blue  ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'BLUE_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
hdf_sd_endaccess, varid
;;;;;;;;;;  green   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'GREEN_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
hdf_sd_endaccess, varid
;;;;;;;;;;  red   ;;;;;;;;;
index=hdf_sd_nametoindex(hdfid,'RED_raw_data')
varid = hdf_sd_select(hdfid,index)
hdf_sd_getdata, varid, dati
im1 = IMAGE(dati)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
hdf_sd_endaccess, varid
hdf_sd_end, hdfid

end