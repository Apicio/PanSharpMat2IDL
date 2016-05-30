function hyp4_scalar, v1, v2
  ;HYP4_SCALAR Computes the scalar product between two quaternions
  ;v1 and v2 are matrices of 4-elements hypercomplex vectors (quaternions)
  ;su ogni riga di v abbiamo: a*r + b*i + c*j+ d*k
  
  w0=LONG(v1(0,*) )
  w1=LONG(v1(1,*) )
  w2=LONG(v1(2,*)) 
  w3=LONG(v1(3,*))

  case N_PARAMS() of
    1:BEGIN ;ritorna una vettore
      sc=w0*w0+w1*w1+w2*w2+w3*w3;
      end
  else:BEGIN ;ritorna una matrice
      sizeElem=size(v1)
      sc=lindgen(sizeElem(1),sizeElem(2))*0
      z0=LONG(v2(0,*))
      z1=LONG(v2(1,*))
      z2=LONG(v2(2,*))
      z3=LONG(v2(3,*))
  sc(0,*)=w0*z0+w1*z1+w2*z2+w3*z3  ;vettore colonna r-->r*r=r  i*i=r   j*j=r  k*k=r
  sc(1,*)=w1*z0-w0*z1+w3*z2-w2*z3  ;vettore colonna i-->i*r=i  r*i=-i  k*j=i  j*k=-i
  sc(2,*)=w2*z0-w0*z2+w1*z3-w3*z1  ;vettore colonna j-->j*r=i  r*j=-1  k*j=i  j*k=-i
  sc(3,*)=w3*z0-w0*z3+w2*z1-w1*z2  ;vettore colonna k-->k*r=k  r*k=-k  j*i=k  i*j=-k
  end
endcase

  return, sc
end