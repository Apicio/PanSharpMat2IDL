function NomiVariabiliHDF, hdf_id

if (n_params() ne 1) then message,'Sintax: varnames=NomiVariabiliHDF(hdfid)'
if (n_elements(hdf_id) eq 0) then message,'HDF file identifier is undefined'

hdf_sd_fileinfo, hdf_id, nvars, ngatts  

if nvars ge 1 then begin
  varnames=strarr(nvars)
  for index=0L,nvars-1L do begin
    varid = hdf_sd_select(hdf_id, index)
    hdf_sd_getinfo,varid,name=name_temp
    varnames[index]=name_temp
    hdf_sd_endaccess,varid
  endfor
endif

return, varnames

end