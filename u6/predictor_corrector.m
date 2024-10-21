function res = predictor_corrector(f, y0, t0, tf, h, order = 4, pred = 4)
    % f:     Función que define la EDO
    % y0:    Valor inicial
    % t0:    Tiempo inicial
    % tf:    Tiempo final
    % h:     Paso de tiempo
    % order: Orden del método (2, 3 o 4)
    % pred:  Indica el método utilizado para calcular las predicciones previas necesarias para aplicar
    %        el metodo de predictor-corrector. Valores válidos:
    %           0 -> Método de Euler.
    %           1 -> Método de Euler Modificado.
    %           2 -> Método de Runge-Kutta grado 2.
    %           3 -> Método de Runge-Kutta grado 3.
    %           4 -> Método de Runge-Kutta grado 4.

    % Inicialización
    t = t0:h:tf;        % Vector de tiempo
    n = length(t);      % Tamaño del intervalo
    y = zeros(size(t)); % Inicializa el vector de soluciones
    y(1) = y0;          % Establece el valor inicial

    % Usar el método de Euler para calcular los primeros valores
    for i = 1:(order - 1)
        if i < n
            if pred == 0
              % Metodo de Euler
              y(i + 1) = y(i) + h * f(t(i), y(i));

            elseif pred == 1
              % Metodo de Euler Modificado
              y_temp = y(i) + h * f(t(i), y(i));
              y(i + 1) = y(i) + (h / 2) * (f(t(i), y(i)) + f(t(i + 1), y_temp));

            elseif pred == 2
              % Método de Runge-Kutta orden 2
              k1 = f(t(i), y(i));
              k2 = f(t(i) + h, y(i) + h * k1);
              y(i + 1) = y(i) + (h / 2) * (k1 + k2);

            elseif pred = 3
              % Método de Runge-Kutta orden 3
              k1 = h * f(t(i), y(i));
              k2 = h * f(t(i) + h/2, y(i) + k1/2);
              k3 = h * f(t(i) + h, y(i) + 2*k2 - k1);
              y(i+1) = y(i) + (k1 + 4*k2 + k3) / 6;

            elseif pred == 4
              % Método de Runge-Kutta orden 4
              k1 = f(t(i), y(i));
              k2 = f(t(i) + h / 2, y(i) + (h / 2) * k1);
              k3 = f(t(i) + h / 2, y(i) + (h / 2) * k2);
              k4 = f(t(i) + h, y(i) + h * k3);
              y(i + 1) = y(i) + (h / 6) * (k1 + 2 * k2 + 2 * k3 + k4);
            end
        end
    end

    % Método de Adams-Bashforth y Adams-Moulton
    for i = order:(n - 1)
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
    res = [t', y']
end
