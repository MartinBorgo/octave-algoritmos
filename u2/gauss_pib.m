function x = gauss_pib(A, b)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % x será el vector solución del sistema Ax = b

    % Obtener el número de filas
    n = size(A, 1);

    % Formar la matriz aumentada
    Ab = [A b];

    % Aplicar eliminación hacia adelante
    for i = 1:n-1
        % Para cada fila i, hacer ceros debajo del elemento diagonal A(i, i)
        for j = i+1:n
            factor = Ab(j, i) / Ab(i, i);
            Ab(j, i:n+1) = Ab(j, i:n+1) - factor * Ab(i, i:n+1);
        end
    end

    % Inicializar el vector solución
    x = zeros(n, 1);

    % Sustitución hacia atrás
    for i = n:-1:1
        x(i) = (Ab(i, end) - Ab(i, i+1:n) * x(i+1:n)) / Ab(i, i);
    end
end
