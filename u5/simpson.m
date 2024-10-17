function integral = simpson(f, a, b, n)
  % f: función a integrar
  % a: límite inferior
  % b: límite superior
  % n: número de subintervalos (debe ser par)

  if mod(n, 2) ~= 0
      error('El número de subintervalos n debe ser par.');
  end

  h = (b - a) / n; % ancho de cada subintervalo
  x = a:h:b; % puntos de evaluación
  integral = (h / 3) * (f(a) + f(b) + 4 * sum(f(x(2:2:end-1))) + 2 * sum(f(x(3:2:end-2))));
end
