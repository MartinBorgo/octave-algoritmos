function cota_truncada(val, t)
  for i = 1:t
    a = 10^(-i + 1) * val;

    inferior = val - a;
    superior = val + a;

    fprintf('T = %d -> %.5f < p* < %.5f \n', i, inferior, superior);
  end
end
