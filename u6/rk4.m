function [t, y] = rk4(f, y0, t0, tf, h)
    % f: función que define la EDO
    % y0: valor inicial
    % t0: tiempo inicial
    % tf: tiempo final
    % h: paso de tiempo

    t = t0:h:tf; % vector de tiempo
    y = zeros(size(t)); % inicializa el vector de soluciones
    y(1) = y0; % establece el valor inicial

    for i = 1:(length(t) - 1)
        k1 = f(t(i), y(i));
        k2 = f(t(i) + h / 2, y(i) + (h / 2) * k1);
        k3 = f(t(i) + h / 2, y(i) + (h / 2) * k2);
        k4 = f(t(i) + h, y(i) + h * k3);
        y(i + 1) = y(i) + (h / 6) * (k1 + 2 * k2 + 2 * k3 + k4);

        fprintf(' k1 -> f(%.6f, %.6f) = %.6f \n k2 -> f(%.6f, %.6f) = %.6f \n k3 -> f(%.6f, %.6f) = %.6f \n k4 -> f(%.6f, %.6f) = %.6f \n y%d -> %.6f + %.6f * (%.6f + 2 * %.6f + 2 * %.6f + %.6f) = %.6f \n',
                 t(i), y(i), k1,
                 t(i) + h / 2, y(i) + (h / 2) * k1, k2,
                 t(i) + h / 2, y(i) + (h / 2) * k2, k3,
                 t(i) + h, y(i) + h * k3, k4,
                 i, y(i), h / 6, k1, k2, k3, k4, y(i + 1));
    end
end
