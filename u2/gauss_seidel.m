function x = gauss_seidel(A, b, tol=10e-6, max_iter=25)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % tol es la tolerancia del error para el criterio de parada
    % max_iter es el número máximo de iteraciones

    n = length(b);
    x = ones(n, 1); % Inicializa el vector solución como vector columna
    x_old = x;

    for iter = 1:max_iter
        x_old = x;

        for i = 1:n
            % Sumatoria de A(i, j) * x(j) para j < i y A(i, j) * x_old(j) para j > i
            sum1 = A(i, 1:i-1) * x(1:i-1);   % Uso de los valores actualizados de x
            sum2 = A(i, i+1:n) * x_old(i+1:n); % Uso de los valores antiguos para el resto

            % Actualización de x(i) según la fórmula de Gauss-Seidel
            x(i) = (b(i) - sum1 - sum2) / A(i, i);
        end
        dif_norm = norm(x, inf) - norm(x_old, inf);
        fprintf('Número de iteración %d | x1 =%.5f, x2 = %.5f, x3 = %.5f | Diferencia de Normas %.5f \n', iter, x(1),x(2),x(3), dif_norm);
        % Criterio de parada basado en la norma del error
        if dif_norm < tol
            fprintf('Convergencia alcanzada en %d iteraciones.\n', iter);
            return;
        end
    end
end

