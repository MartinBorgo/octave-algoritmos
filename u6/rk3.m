function res = rk4(f, y0, t0, tf, h)
    % f:  Función que define la EDO
    % y0: Valor inicial
    % t0: Tiempo inicial
    % tf: Tiempo final
    % h:  Paso de tiempo

    t = t0:h:tf;        % Vector de tiempo
    y = zeros(size(t)); % Inicializa el vector de soluciones
    y(1) = y0;          % Establece el valor inicial

   for i = 1:(length(t) - 1)
      k1 = h * f(t(i), y(i));
      k2 = h * f(t(i) + h / 2, y(i) + k1 / 2);
      k3 = h * f(t(i) + h, y(i) + 2 * k2 - k1);
      y(i + 1) = y(i) + (k1 + 4 * k2 + k3) / 6;

      fprintf(' k1 -> f(%.6f, %.6f) = %.6f \n k2 -> f(%.6f, %.6f) = %.6f \n k3 -> f(%.6f, %.6f) = %.6f \n y%d -> %.6f + (%.6f + 4 * %.6f + %.6f) / 6 = %.6f\n',
              t(i), y(i), k1,
              t(i) + h / 2, y(i) + k1 / 2, k2,
              t(i) + h, y(i) + 2 * k2, k3,
              i, y(i), k1, k2, k3, y(i + 1));
      disp('<|----------------------------------------|>');
   end
   res = [t', y']
end
