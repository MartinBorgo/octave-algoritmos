function cota_redondeo_simetrico(val, t)
  for i = 1:t
    a = 5 * 10^(-i) * val

    inferior = val - a
    superior = val + a

    fprintf('T = %d -> %.5f < p* < %.5f \n', i, inferior, superior);
  end
end
