@paths.pro
cutDim = [256*3, 256*3]
startCoords = [1401,5202]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; ESTRAZIONE DATI RAW ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PAN   = read_tiff([PATH_TO_TIFF+'toLoad (1).TIF'],sub_rect=[startCoords[0],startCoords[1],cutDim[0],cutDim[1]])
MS_UV = read_tiff([PATH_TO_TIFF+'toLoad (2).TIF'],sub_rect=[startCoords[0]/3,startCoords[1]/3,cutDim[0]/3,cutDim[0]/3])
MS_B  = read_tiff([PATH_TO_TIFF+'toLoad (3).TIF'],sub_rect=[startCoords[0]/3,startCoords[1]/3,cutDim[0]/3,cutDim[1]/3])
MS_G  = read_tiff([PATH_TO_TIFF+'toLoad (4).TIF'],sub_rect=[startCoords[0]/3,startCoords[1]/3,cutDim[0]/3,cutDim[1]/3])
MS_R  = read_tiff([PATH_TO_TIFF+'toLoad (5).TIF'],sub_rect=[startCoords[0]/3,startCoords[1]/3,cutDim[0]/3,cutDim[1]/3])

MS = DBLARR(cutDim[0]/3,cutDim[0]/3,4)
MS(*,*,0) = MS_UV
MS(*,*,1) = MS_B
MS(*,*,2) = MS_G
MS(*,*,3) = MS_R
NBands = 4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; LETTURA DATI GEOLOCALIZZAZIONE ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

flag_correct=query_tiff([PATH_TO_TIFF+'toLoad (1).TIF'],PAN_query,GEOTIFF=PAN_GEO)
flag_correct=query_tiff([PATH_TO_TIFF+'toLoad (2).TIF'],MS_UV_query,GEOTIFF=MS_UV_GEO)
flag_correct=query_tiff([PATH_TO_TIFF+'toLoad (3).TIF'],MS_B_query,GEOTIFF=MS_B_GEO)
flag_correct=query_tiff([PATH_TO_TIFF+'toLoad (4).TIF'],MS_G_query,GEOTIFF=MS_G_GEO)
flag_correct=query_tiff([PATH_TO_TIFF+'toLoad (5).TIF'],MS_R_query,GEOTIFF=MS_R_GEO)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; INIZIO CREAZIONE HDF ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hdfid = hdf_sd_start(PATH_TO_SAVE+'IDL_hdf.hdf', /create)
;AGGIUNTA ATTRIBUTI GLOBALI
ratio = 3
MTF_NyqMS = [0.28,0.29, 0.29, 0.30]
MTF_NyqPAN = 0.15
HDF_SD_ATTRSET, hdfid, 'ratio', ratio
HDF_SD_ATTRSET, hdfid, 'MTF_NyqMS', MTF_NyqMS
HDF_SD_ATTRSET, hdfid, 'MTF_NyqPAN', MTF_NyqPAN

; Si crea una nuova entry con le dimensioni dell'immagine PAN. Queste sono contenute in un array di 2 elementi.
varid = hdf_sd_create(hdfid, 'PAN_raw_data', [cutDim[0],cutDim[1]], /INT)
;Prende l'ID dell'elemento 0 (ovvero l'id di cutDim[0]). Questo è associato alla DIMENSIONE 0 (asse delle x)
dimid = hdf_sd_dimgetid(varid, 0) 
;Crea l'entry associata alla dimensione 0 (asse delle x), che contiene le informazioni relative alla lunghezza
;lungo l'asse delle x
hdf_sd_dimset, dimid, name='xdim'
dimid = hdf_sd_dimgetid(varid, 1)
hdf_sd_dimset, dimid, name='ydim'
hdf_sd_adddata, varid, PAN
hdf_sd_endaccess, varid


varid = hdf_sd_create(hdfid, 'MS_raw_data', [cutDim[0]/3,cutDim[1]/3,NBands], /INT)
dimid = hdf_sd_dimgetid(varid, 0)
hdf_sd_dimset, dimid, name='xdim '
dimid = hdf_sd_dimgetid(varid, 1)
hdf_sd_dimset, dimid, name='ydim '
hdf_sd_adddata, varid, MS
hdf_sd_endaccess, varid

;Aggiunta dati di Geografici

toWritePAN_GEO = [PAN_GEO.MODELPIXELSCALETAG , PAN_GEO.MODELTIEPOINTTAG]
dims = size(toWritePan_GEO,/DIMENSIONS)
varid = hdf_sd_create(hdfid, 'PAN_Geo_Info', [dims[0]], /DOUBLE)
hdf_sd_adddata, varid, toWritePan_GEO
hdf_sd_endaccess, varid

toWriteMS_GEO = [MS_UV_GEO.MODELPIXELSCALETAG , MS_UV_GEO.MODELTIEPOINTTAG]
dims = size(toWriteMS_GEO,/DIMENSIONS)
varid = hdf_sd_create(hdfid, 'MS_Geo_Info', [dims[0]], /DOUBLE)
hdf_sd_adddata, varid, toWriteMS_GEO
hdf_sd_endaccess, varid

hdf_sd_end, hdfid

end