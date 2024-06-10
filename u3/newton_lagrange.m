function root = newton_lagrange(f, x0, x1, tol=10e-6, max_iter=25)
    % f: función para la cual encontrar la raíz
    % x0, x1: primeras dos estimaciones iniciales de la raíz
    % tol: tolerancia para el criterio de parada
    % max_iter: número máximo de iteraciones

    for i = 1:max_iter
        f0 = f(x0);
        f1 = f(x1);


        if (f1 - f0) == 0
            error('División por cero en la diferencia de f(x)');
        end

        x2 = ((f1 * x0) - (f0 * x1)) / (f1 - f0);

        fprintf('Nuevo valor de x: %.5f | Función evaluada en ese valor de x: %.5f\n', x2, f(x2))

        if abs(f(x2)) < tol
            root = x2;
            return;
        end

        x0 = x1;
        x1 = x2;
    end
end

