;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     INIZIALIZZAZIONE      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@paths.pro
RESTORE, PATH_TO_PANNED
RESTORE, PATH_TO_FILE
block = 32
dim_ms = size(IM2CROPMS1P,/dimension)
dim_fused = size(FUSED_MS,/dimension)
MS = DBLARR(dim_ms(0),dim_ms(1),dim_fused(2))
;Serve MS NON interpolata.
MS[*,*,0] = im5CropMS3 ;R
MS[*,*,1] = im4CropMS2 ;G
MS[*,*,2] = im3CropMS1 ;B
MS[*,*,3] = im2CropMS1p ;UV
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
;     WALD PROTOCOL  ;
;;;;;;;;;;;;;;;;;;;;;;

; 1 - Due scelte (da capire qale funzione, Wald dice di seguire scelta a , ma dovrebbero essere uguali):
;     a: DEGRADAZIONE Pan ed MS
;     b:degradazione immagine Pansharp
;  
; 2 - Se scelgo a:
;       Applicazione pansharpening GS2_GLP a PAN ed MS degradate
;       Confronto fra immagine pansharp ed MS ORIGINALE
;     Se scelgo b:
;       Confronto fra immagine pansharp degradata ed MS ORIGINALE
; 
end