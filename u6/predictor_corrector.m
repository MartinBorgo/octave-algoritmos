function [t, y] = predictor_corrector(f, y0, t0, tf, h, order = 4)
    % f: función que define la EDO
    % y0: valor inicial
    % t0: tiempo inicial
    % tf: tiempo final
    % h: paso de tiempo
    % order: orden del método (2, 3 o 4)

    % Inicialización
    t = t0:h:tf; % vector de tiempo
    n = length(t);
    y = zeros(size(t)); % inicializa el vector de soluciones
    y(1) = y0; % establece el valor inicial

    % Usar el método de Euler para calcular los primeros valores
    for i = 1:(orden - 1)
        if i < n
            y(i + 1) = y(i) + h * f(t(i), y(i)); % Método de Euler
        end
    end

    % Método de Adams-Bashforth y Adams-Moulton
    for i = 2:(n - 1)
        if order == 2
            % Predictor (Adams-Bashforth de 2 pasos)
            y_pred = y(i) + (h / 2) * (f(t(i), y(i)) + f(t(i - 1), y(i - 1)));

            % Corrector (Adams-Moulton de 2 pasos)
            y(i + 1) = y(i) + (h / 2) * (f(t(i + 1), y_pred) + f(t(i), y(i)));
        elseif order == 3
            % Predictor (Adams-Bashforth de 3 pasos)
            y_pred = y(i) + (h / 12) * (23 * f(t(i), y(i)) - 16 * f(t(i - 1), y(i - 1)) + 5 * f(t(i - 2), y(i - 2)));

            % Corrector (Adams-Moulton de 3 pasos)
            y(i + 1) = y(i) + (h / 12) * (5 * f(t(i + 1), y_pred) + 8 * f(t(i), y(i)) - f(t(i - 1), y(i - 1)));
        elseif order == 4
            % Predictor (Adams-Bashforth de 4 pasos)
            y_pred = y(i) + (h / 24) * (55 * f(t(i), y(i)) - 59 * f(t(i - 1), y(i - 1)) + 37 * f(t(i - 2), y(i - 2)) - 9 * f(t(i - 3), y(i - 3)));

            % Corrector (Adams-Moulton de 4 pasos)
            y(i + 1) = y(i) + (h / 24) * (9 * f(t(i + 1), y_pred) + 19 * f(t(i), y(i)) - 5 * f(t(i - 1), y(i - 1)) + f(t(i - 2), y(i - 2)));
        else
            error('El orden debe ser 2, 3 o 4.');
        end
    end
end
