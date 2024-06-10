function cota_truncada(val, t)
  for i = 1:t
    a = 10^(-i + 1) * val;

    inferior = val - a;
    superior = val + a;
    % Verifica si el valor es igual a uno de los límites o está fuera de los límites
    if (val == inferior || val == superior) || ~(val > inferior || val < superior)
      disp('YA NO PERTENECE A ESTA COTA');
      fprintf('T = %d -> %.5f < p* < %.5f \n', i, inferior, superior);
      break;
    endif
    fprintf('T = %d -> %.5f < p* < %.5f \n', i, inferior, superior);
  end
end

