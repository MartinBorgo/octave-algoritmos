function root = newton_raphson(f, df, x0, tol=10e-6, max_iter=25)
    % f: función para la cual encontrar la raíz
    % df: derivada de la función f
    % x0: estimación inicial de la raíz
    % tol: tolerancia para el criterio de parada
    % max_iter: número máximo de iteraciones

    for i = 1:max_iter
        fx = f(x0);
        dfx = df(x0);

        if dfx == 0
            error('Derivada igual a cero. No se puede continuar.');
        end

        x1 = x0 - fx / dfx;

        fprintf('Nuevo valor de x: %.5f | Función evaluada en ese valor de x: %.5f\n', x1, f(x1))

        if abs(f(x1)) < tol
            root = x1;
            return;
        end

        x0 = x1;
    end
end

