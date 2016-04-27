function hyp4_scalar, v1, v2
  ;HYP4_SCALAR Computes the scalar product between two quaternions
  ;v1 and v2 are matrices of 4-elements hypercomplex vectors (quaternions)
  w0=v1(0,*) 
  w1=v1(1,*) 
  w2=v1(2,*) 
  w3=v1(3,*)

  case N_PARAMS() of
    1:BEGIN ;ritorna una vettore
      sc=w0*w0+w1*w1+w2*w2+w3*w3;
      end
  else:BEGIN ;ritorna una matrice
      sizeElem=size(v1)
      sc=indgen(sizeElem(1),sizeElem(2))*0
      z0=v2(0,*)
      z1=v2(1,*)
      z2=v2(2,*)
      z3=v2(3,*)
  sc(0,*)=w0*z0+w1*z1+w2*z2+w3*z3;
  sc(1,*)=w1*z0-w0*z1+w3*z2-w2*z3;
  sc(2,*)=w2*z0-w0*z2+w1*z3-w3*z1;
  sc(3,*)=w3*z0-w0*z3+w2*z1-w1*z2;
  end
endcase

  return, sc
end