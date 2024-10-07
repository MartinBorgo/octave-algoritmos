function [t, y] = euler_mejorado(f, y0, t0, tf, h)
    % f: función que define la EDO
    % y0: valor inicial
    % t0: tiempo inicial
    % tf: tiempo final
    % h: paso de tiempo

    t = t0:h:tf; % vector de tiempo
    y = zeros(size(t)); % inicializa el vector de soluciones
    y(1) = y0; % establece el valor inicial

    for i = 1:(length(t) - 1)
        y_pred = y(i) + h * f(t(i), y(i)); % predicción intermedia
        y(i + 1) = y(i) + (h / 2) * (f(t(i), y(i)) + f(t(i + 1), y_pred)); % corrección
    end
end
