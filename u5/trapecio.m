function integral = trapecio(f, a, b, n)
  % f: Función a integrar
  % a: Límite inferior
  % b: Límite superior
  % n: Número de subintervalos

  h = (b - a) / n;  % Ancho de cada subintervalo
  x = a:h:b;        % Puntos de evaluación

  fprintf('Ancho del intervalo (h): %f \n', h);
  fprintf('Puntos de evaluación (x): %s \n', mat2str(x));
  fprintf('Puntos evaluados en f(x): %s \n', mat2str(f(x)));
  % Cálculo de la integral
  integral = (h / 2) * (f(a) + f(b) + 2 * sum(f(x(2:end-1))));
end

