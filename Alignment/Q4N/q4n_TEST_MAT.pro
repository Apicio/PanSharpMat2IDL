@paths.pro
RESTORE, PATH_TO_LOAD_RIC

Start = 0 ;cordinate to start to CUT x,y (MUST: Start-Rangex>0)
Finish = 4; cordinate to finish to C
;;;;;;TEST RGBB;;;;;;;;;;;;
x=indgen(Finish-Start+1,Finish-Start+1,4)
x[*,*,0]=REDIMAGERIC[Start:Finish,Start:Finish]
x[*,*,1]=GREENIMAGERIC[Start:Finish,Start:Finish]
x[*,*,2]=BLUIMAGERIC[Start:Finish,Start:Finish]
x[*,*,3]=BLUIMAGERIC[Start:Finish,Start:Finish]


y=indgen(Finish-Start+1,Finish-Start+1,4)
y[*,*,0]=REDIMAGERIC[Start:Finish,Start:Finish]
y[*,*,1]=GREENIMAGERIC[Start:Finish,Start:Finish]
y[*,*,2]=BLUIMAGERIC[Start:Finish,Start:Finish]
y[*,*,3]=BLUIMAGERIC[Start:Finish,Start:Finish]

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;CODICE COME MATLAB;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;facciamo un cambio di forma in modo da avere una matrice bidimensionale, in cui le N=4 colonne mi rappresentano la BANDA
x_ref=transpose(reform(x,(Finish-Start+1)^2,4)) ; x_ref sarà una matrice bidimensionale N x N.bande
y_ref=transpose(reform(y,(Finish-Start+1)^2,4)) ; 

x_mean=mean(x_ref,DIMENSION=2) ;equivale a x_mean=[mean(x[*,*,0]),mean(x[*,*,1]),mean(x[*,*,2])] ;vettore 1x N.bande
y_mean=mean(y_ref,DIMENSION=2)

mz1=norm(x_mean); ;scalare
mz2=norm(x_mean);

;(indgen(1,(Finish-Start+1)^2)*0+1)=vettore di tutti 1; vettore N*1, a cui viene fatto un prodotto matriciale con la media di x(vettore 1*nBande)
;la seconda istruzione crea una matrice N*nBande in cui c'è la media(iesima) per ogni colonna;
;al fine poter sottrarre alla matrice originale la media per ogni banda
e1=x_ref-(indgen(1,(Finish-Start+1)^2)*0+1)##x_mean
e2=y_ref-(indgen(1,(Finish-Start+1)^2)*0+1)##y_mean

sz1=mean(hyp4_scalar(e1)) ;scalare=media di un vettore
sz2=mean(hyp4_scalar(e2));
sz1z2=norm(mean(hyp4_scalar(e1,e2),DIMENSION=2));



Q4_map=4*sz1z2/(sz1+sz2)*mz1*mz2/(mz1^2+mz2^2)
print, Q4_map

end
