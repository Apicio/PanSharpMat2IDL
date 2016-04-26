function q2n, x, y
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Q2N Universal Image Quality Index;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   x_mean=mean(x)
   y_mean=mean(y)
   x_var=variance(x)
   y_var=variance(y)
   xy_cov=mean((x-x_mean)*(y-y_mean)) ;

  q=(4*abs(xy_cov)*abs(x_mean)*abs(y_mean))/((x_var+y_var)*(abs(x_mean)^2+abs(y_mean)^2)) ;;formula presa dall'articolo
  return, q
end