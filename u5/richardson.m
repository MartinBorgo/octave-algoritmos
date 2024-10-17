function x = richardson(ph, ph2)
  % ph: Predicción con paso h
  % ph2: Predicción con paso h/2

  x = (4 * ph2 - ph) / 3
end
