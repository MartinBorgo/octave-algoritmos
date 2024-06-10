function x = jacobi(A, b, tol=10e-6, max_iter=25)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % tol es la tolerancia del error para el criterio de parada
    % max_iter es el número máximo de iteraciones

    n = length(b);
    x = ones(n, 1); % Inicializa el vector solución
    x_old = x;

    for iter = 1:max_iter
        for i = 1:n
            % Sumatoria de A(i, j) * x_old(j) para j ≠ i
            sum = A(i, :) * x_old - A(i, i) * x_old(i);

            % Actualización de x(i) según la fórmula de Jacobi
            x(i) = (b(i) - sum) / A(i, i);
        end
        % Criterio de parada basado en la norma del error
        dif_norma = norm(x, inf) - norm(x_old, inf);
        fprintf('Número de iteración %d | x1 =%.5f, x2 = %.5f, x3 = %.5f | Norma: %.5f \n', iter, x(1),x(2),x(3), dif_norma);

        if dif_norma < tol
            fprintf('Convergencia alcanzada en %d iteraciones.\n', iter);
            return;
        end

        % Actualizar x_old para la siguiente iteración
        x_old = x;
    end
end

