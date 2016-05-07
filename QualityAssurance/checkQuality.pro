;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     INIZIALIZZAZIONE      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@paths.pro
RESTORE, PATH_TO_PANNED
RESTORE, PATH_TO_FILE

dim_ms_orig = size(IM2CROPMS1P,/dimension)  ;256*256
dim_ms = size(UVIMAGERIC,/dimension)  ;768*768
dim_pan = size(IM1CROPPAN,/dimension)  ;768*768

MS_orig = DBLARR(dim_ms_orig(0),dim_ms_orig(1),4) ;256*256*4
MS = DBLARR(dim_ms(0),dim_ms(1),4)  ;768*768*4
PAN = DBLARR(dim_pan(0),dim_pan(1)) ;768*768

;Serve MS NON interpolata (per il confronto finale).
MS_orig[*,*,0] = im5CropMS3 ;R
MS_orig[*,*,1] = im4CropMS2 ;G
MS_orig[*,*,2] = im3CropMS1 ;B
MS_orig[*,*,3] = im2CropMS1p ;UV

;MS interpolata
MS[*,*,0] = REDIMAGERIC ;R
MS[*,*,1] = GREENIMAGERIC ;G
MS[*,*,2] = BLUIMAGERIC ;B
MS[*,*,3] = UVIMAGERIC ;UV

;PAN
PAN = IM1CROPPAN
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
; DEGRADAZIONE IMMAGINI
Degrad_PAN = mtf_pan(PAN,3,4);
Degrad_MS = mtf_ms(MS,3,4);

Degrad_PAN = Degrad_PAN(0:*:3,0:*:3,*)
Degrad_MS = Degrad_MS(0:*:3,0:*:3,*)

; Applicazione pansharpening GS2_GLP a PAN ed MS degradate
Fused_Image = gs2_glp(Degrad_PAN[*,*,0],Degrad_MS,3)

; Verifico Qualità
ok = q4n_extend(Fused_image,ms_orig)
ok = scc_index(ms_orig,Fused_image)
ok = sam(ms_orig,Fused_image)

; q4n exnd: 0.128656343
; Scc: 0.82550938226554482
; sam: Program caused arithmetic error: Floating illegal operand

end