function x = gauss_pib_parcial(A, b)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % x será el vector solución del sistema Ax = b

    % Obtener el número de filas
    n = size(A, 1);

    % Formar la matriz aumentada
    Ab = [A b];

    % Aplicar eliminación hacia adelante con pivoteo parcial
    for i = 1:n-1
        % Encontrar el índice del mayor elemento en valor absoluto en la columna i
        [~, maxIndex] = max(abs(Ab(i:n, i)));
        maxIndex = maxIndex + i - 1;

        % Intercambiar filas si es necesario
        if maxIndex ~= i
            Ab([i maxIndex], :) = Ab([maxIndex i], :);
        end

        % Hacer ceros debajo del elemento diagonal A(i, i)
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

