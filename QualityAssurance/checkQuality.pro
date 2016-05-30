;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     INIZIALIZZAZIONE      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
@paths.pro
;RESTORE, PATH_TO_PANNED ;carica FUSED_MS  
RESTORE, PATH_TO_FILE ;Carica PAN e singole Bande
ratio = 3
NBands = 4
dim_ms_orig = size(IM2CROPMS1P,/dimension)  ;256*256
dim_pan = size(IM1CROPPAN,/dimension)  ;768*768
MS = DBLARR(dim_ms_orig(0),dim_ms_orig(1),NBands) ;256*256*4
PAN = DBLARR(dim_pan(0),dim_pan(1)) ;768*768
MTF_NyqMS =  [0.28,0.29, 0.29, 0.30]
MTF_NyqPAN =  0.15

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
Degrad_PAN = mtf(PAN,ratio,1,MTF_NyqPAN);
Degrad_MS = mtf(MS,ratio,NBands,MTF_NyqMS);

; Interpolazione MS degradata di un fattore pari al ratio
; per poter applicare poi la fusione (in questo modo effetto il vero e proprio blurring)
Degrad_MS(*,*,0) = sresize(Degrad_MS(*,*,0),ratio)
Degrad_MS(*,*,1) = sresize(Degrad_MS(*,*,1),ratio)
Degrad_MS(*,*,2) = sresize(Degrad_MS(*,*,2),ratio)
Degrad_MS(*,*,3) = sresize(Degrad_MS(*,*,3),ratio)

Degrad_MS(*,*,0) = fresize(Degrad_MS(*,*,0),ratio)
Degrad_MS(*,*,1) = fresize(Degrad_MS(*,*,1),ratio)
Degrad_MS(*,*,2) = fresize(Degrad_MS(*,*,2),ratio)
Degrad_MS(*,*,3) = fresize(Degrad_MS(*,*,3),ratio)

; Effettuo la valutazione attraverso gli Indici di Qualità prima di tutto prendendo in considerazione la MS
; Interpolata e la Ground Truth, dopodiché farò lo stesso tra l'immagine Fusa e la Ground Truth
q4 = q4n_extend(MS,Degrad_MS)
scc = scc_index(MS,Degrad_MS)
samidx = sam(ms,Degrad_MS)


print, q4
print, scc
print, samidx



; Blurring dell'immagine PAN (che non ha bisogno di un resize)
Degrad_PAN = Degrad_PAN(0:*:ratio,0:*:ratio)

; Applicazione pansharpening GS2_GLP a PAN ed MS degradate

Fused_Image = gs2_glp(Degrad_PAN,Degrad_MS,ratio)

; Verifico Qualità
q4 = q4n_extend(Fused_image,MS)
scc = scc_index(MS,Fused_image)
samidx = sam(ms,Fused_image)

print, q4
print, scc
print, samidx

; EFFETTUANDO L'INTERPOLAZIONE DI TIPO SPAZIALE:

; q4n exnd: 0.8520 / 0.88 (con ENVI)
; Scc: 0.843  / 0.89 (Con ENVI)
; sam: 1.7041 / 1.38 (Con ENVI)

; EFFETTUANDO L'INTERPOLAZIONE DI TIPO FREQUENZIALE:

; q4n exnd: 0.7759 / 0.88 (con ENVI)
; Scc: 0.7233  / 0.89 (Con ENVI)
; sam: 1.7210 / 1.38 (Con ENVI)

; EFFETTUANDO IL PROCESSO DI PANSHARPENING ATTRAVERSO ENVI:

; q4n exnd: 0.88
; Scc: 0.89
; sam: 1.38

end