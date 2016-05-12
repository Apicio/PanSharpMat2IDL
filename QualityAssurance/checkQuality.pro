;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     INIZIALIZZAZIONE      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@paths.pro
RESTORE, PATH_TO_PANNED ;carica FUSED_MS  
RESTORE, PATH_TO_FILE ;Carica PAN e singole Bande
ratio = 3
NBands = 4
dim_ms_orig = size(IM2CROPMS1P,/dimension)  ;256*256
dim_pan = size(IM1CROPPAN,/dimension)  ;768*768
MS = DBLARR(dim_ms_orig(0),dim_ms_orig(1),NBands) ;256*256*4
PAN = DBLARR(dim_pan(0),dim_pan(1)) ;768*768

;Serve MS NON interpolata (per il confronto finale).
MS[*,*,0] = im5CropMS3 ;R
MS[*,*,1] = im4CropMS2 ;G
MS[*,*,2] = im3CropMS1 ;B
MS[*,*,3] = im2CropMS1p ;UV

PAN = IM1CROPPAN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;
;     WALD PROTOCOL  ;
;;;;;;;;;;;;;;;;;;;;;;

; 1 - DEGRADAZIONE Pan ed MS
;     
; 2 -   Applicazione pansharpening con metodo GS2_GLP a PAN ed MS degradate
;       Confronto fra immagine pansharp ed MS ORIGINALE

; DEGRADAZIONE IMMAGINI
Degrad_PAN = mtf_pan(PAN,ratio,NBands);
Degrad_MS = mtf_ms(MS,ratio,NBands);

; Aumento le proporzioni dell'immagine MS degradata di un fattore pari al ratio
; per poter applicare poi la fusione (in questo modo effetto il vero e proprio blurring)
Degrad_MS(*,*,0) = sresize(Degrad_MS(*,*,0),ratio)
Degrad_MS(*,*,1) = sresize(Degrad_MS(*,*,1),ratio)
Degrad_MS(*,*,2) = sresize(Degrad_MS(*,*,2),ratio)
Degrad_MS(*,*,3) = sresize(Degrad_MS(*,*,3),ratio)

; Blurring dell'immagine PAN (che non ha bisogno di un resize)
Degrad_PAN = Degrad_PAN(0:*:ratio,0:*:ratio,*)

; Applicazione pansharpening GS2_GLP a PAN ed MS degradate

Fused_Image = gs2_glp(Degrad_PAN(*,*,0),Degrad_MS,ratio)

; Verifico Qualità
;ok = q4n_extend(Fused_image,ms_orig)
ok = scc_index(ms_orig,Fused_image)
ok = sam(ms_orig,Fused_image)

; q4n exnd: 0.128656343
; Scc: 0.82550938226554482
; sam: Program caused arithmetic error: Floating illegal operand

end