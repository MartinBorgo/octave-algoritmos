function integral = trapecio(f, a, b, n)
    % f: función a integrar
    % a: límite inferior
    % b: límite superior
    % n: número de subintervalos

    h = (b - a) / n; % ancho de cada subintervalo
    x = a:h:b; % puntos de evaluación
    integral = (h / 2) * (f(a) + f(b) + 2 * sum(f(x(2:end-1)))); % cálculo de la integral
end

