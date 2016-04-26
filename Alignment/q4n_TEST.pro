@paths.pro
RESTORE, PATH_TO_LOAD_RIC

Start = 0 ;cordinate to start to CUT x,y (MUST: Start-Rangex>0)
Finish = 4; cordinate to finish to C
;;;;;;TEST RGB;;;;;;;;;;;;
x=indgen(Finish-Start+1,Finish-Start+1,3)
x[*,*,0]=REDIMAGERIC[Start:Finish,Start:Finish]
x[*,*,1]=GREENIMAGERIC[Start:Finish,Start:Finish]
x[*,*,2]=BLUIMAGERIC[Start:Finish,Start:Finish]

y=indgen(Finish-Start+1,Finish-Start+1,3)
y[*,*,0]=REDIMAGERIC[Start:Finish,Start:Finish]
y[*,*,1]=GREENIMAGERIC[Start:Finish,Start:Finish]
y[*,*,2]=BLUIMAGERIC[Start:Finish,Start:Finish]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;media per ogni canale->vettore di 3 elementi
x_mean=[mean(x[*,*,0]),mean(x[*,*,1]),mean(x[*,*,2])] 
y_mean=[mean(y[*,*,0]),mean(y[*,*,1]),mean(y[*,*,2])]

;varianza per ogni canale->vettore di 3 elementi
x_var=[variance(x[*,*,0]),variance(x[*,*,1]),variance(x[*,*,2])]
y_var=[variance(y[*,*,0]),variance(y[*,*,1]),variance(y[*,*,2])]

xy_cov=findgen(3)
xy_cov[0]=mean((x[*,*,0]-x_mean[0])*(y[*,*,0]-y_mean[0]))
xy_cov[1]=mean((x[*,*,1]-x_mean[1])*(y[*,*,1]-y_mean[1])) 
xy_cov[2]=mean((x[*,*,2]-x_mean[2])*(y[*,*,2]-y_mean[2])) 

q=(4*norm(xy_cov)*norm(x_mean)*norm(y_mean))/((x_var+y_var)*(norm(x_mean)^2+norm(y_mean)^2)) ;;formula presa dall'articolo
;;;;MI RESTITUISCE UN FOTTUTO VETTORE, POICHé x_var+y_var è un vettore e sulla formula non porta la norma....
;se utilizzo la funzione q2n su un'immagine RGB funziona correttamente, poichè fa la media su tutte  e 3 i canali

