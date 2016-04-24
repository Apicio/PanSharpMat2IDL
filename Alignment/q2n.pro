function q2n, x, y
  ;;;;;;;Q2N;;;;;;;;;;;;;;;
   x_mean=mean(x)
   y_mean=mean(y)
   x_var=variance(x)
   y_var=variance(y)
   xy_cov=mean((x-x_mean)*(y-y_mean)) ;
   q=(4*xy_cov*x_mean*y_mean)/((x_var+y_var)*(x_mean^2+y_mean^2)) ;;formula presa dall'articolo
   return, q
end