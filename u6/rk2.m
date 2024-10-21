function res = rk2(f, y0, t0, tf, h)
    % f:  Función que define la EDO
    % y0: Valor inicial
    % t0: Tiempo inicial
    % tf: Tiempo final
    % h:  Paso de tiempo

    t = t0:h:tf;        % Vector de tiempo
    y = zeros(size(t)); % Inicializa el vector de soluciones
    y(1) = y0;          % Establece el valor inicial

    for i = 1:(length(t) - 1)
        k1 = f(t(i), y(i));
        k2 = f(t(i) + h, y(i) + h * k1);
        y(i + 1) = y(i) + (h / 2) * (k1 + k2);

        fprintf(' k1 -> f(%.3f, %.6f) = %.6f \n k2 -> f(%.3f, %.6f) = %.6f \n y%d -> %.6f + %.6f * (%.6f + %.6f) = %.6f \n',
                t(i), y(i), k1,
                t(i) + h, y(i) + h * k1, k2,
                i, y(i), h / 2, k1, k2, y(i + 1));
        disp('<|----------------------------------------|>');
    end
    res = [t', y']
end
