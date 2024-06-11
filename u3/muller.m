function root = muller(f, x0, x1, x2, tol=10e-6, max_iter=25)
    % f: función para la cual encontrar la raíz
    % x0, x1, x2: tres estimaciones iniciales
    % tol: tolerancia para el criterio de parada
    % max_iter: número máximo de iteraciones

    for i = 1:max_iter
        f0 = f(x0);
        f1 = f(x1);
        f2 = f(x2);

        % Construir la matriz y el vector del lado derecho del sistema
        M = [
            x0^2, x0, 1;
            x1^2, x1, 1;
            x2^2, x2, 1
            ];

        b = [f0; f1; f2];

        disp('Matriz de muller =');
        disp(M);

        disp('Vector b =');
        disp(b);
        % Resolver el sistema para encontrar los coeficientes a, b, c
        coef = M \ b;
        a = coef(1);
        b = coef(2);
        c = coef(3);

        % Discriminante del polinomio cuadrático
        D = sqrt(b^2 - 4 * a * c);

        rt1 = (-b + D) / (2 * a);
        rt2 = (-b - D) / (2 * a);
        % Elegir la raíz correcta del polinomio cuadrático
        if abs(f(rt1)) < abs(f(rt2))
            x3 = rt1;
        else
            x3 = rt2;
        end

        fprintf('x0: %.5f | x1: %.5f | x2: %.5f | Valor de las raices -> r1: %.5f r2: %.5f | Valor de f en las raices -> f(r1): %.5f f(r2) %.5f \n', x0, x1, x2, rt1, rt2, f(rt1), f(rt2));

        % Comprueba la condición de parada
        if abs(f(x3)) < tol
            root = x3;
            return;
        end

        % Actualiza los puntos para la próxima iteración
        x0 = x1;
        x1 = x2;
        x2 = x3;
    end
end

