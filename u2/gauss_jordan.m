function x = gauss_jordan(A, b)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % x será el vector solución del sistema Ax = b

    % Obtener el número de filas y columnas
    [n, m] = size(A);

    % Formar la matriz aumentada
    Ab = [A, b];

    % Aplicar eliminación de Gauss-Jordan
    for i = 1:n
        % Pivoteo parcial: seleccionar el máximo en valor absoluto en la columna i
        [~, maxIndex] = max(abs(Ab(i:n, i)));
        maxIndex = maxIndex + i - 1;

        % Intercambiar filas si es necesario
        if maxIndex ~= i
            Ab([i, maxIndex], :) = Ab([maxIndex, i], :);
        end

        % Hacer el elemento diagonal igual a 1
        Ab(i, :) = Ab(i, :) / Ab(i, i);

        % Hacer ceros en toda la columna i, excepto en la diagonal
        for j = 1:n
            if j ~= i
                factor = Ab(j, i);
                Ab(j, :) = Ab(j, :) - factor * Ab(i, :);
            end
        end
    end

    % Extraer el vector solución
    x = Ab(:, end);
end

