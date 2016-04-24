@paths.pro
RESTORE, PATH_TO_LOAD_RIC

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Q2N Universal Image Quality Index;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

S=300
N=500;

SHIFT=0
img=im1CropPAN[S:N:1,S:N:1]
img2=REDIMAGERIC[S+SHIFT:N+SHIFT:1,S+SHIFT:N+SHIFT:1]
im = IMAGE(img)
im = IMAGE(img2)
x=img
y=img2 ;con img1 si ottiene 0.9999 che è il massimo valore
;;;;;;;Q2N;;;;;;;;;;;;;;;
x_mean=mean(x)
y_mean=mean(y)
x_var=variance(x)
y_var=variance(y)
xy_cov=mean((x-x_mean)*(y-y_mean)) ;

q=(4*xy_cov*x_mean*y_mean)/((x_var+y_var)*(x_mean^2+y_mean^2)) ;;formula presa dall'articolo
print, REAL_PART(q)

end