function x = solve_lu(A, b)
    % A es la matriz de coeficientes
    % b es el vector de términos constantes
    % x será el vector solución del sistema Ax = b

    % Obtener la descomposición LU
    [L, U] = lu_decomposition(A);

    disp('L =')
    disp(L)

    disp('U =')
    disp(U)

    % Resolver Ly = b mediante sustitución hacia adelante
    y = forward_substitution(L, b);

    % Resolver Ux = y mediante sustitución hacia atrás
    x = backward_substitution(U, y);
end

function [L, U] = lu_decomposition(A)
    n = size(A, 1);
    L = eye(n);
    U = zeros(n);

    for k = 1:n
        % Calcular U(k, k:n)
        U(k, k:n) = A(k, k:n) - L(k, 1:k-1) * U(1:k-1, k:n);

        % Calcular L(k+1:n, k)
        if k < n
            L(k+1:n, k) = (A(k+1:n, k) - L(k+1:n, 1:k-1) * U(1:k-1, k)) / U(k, k);
        end
    end

    return;
end

function y = forward_substitution(L, b)
    n = length(b);
    y = zeros(n, 1);
    y(1) = b(1);
    for i = 2:n
        y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    end
end

function x = backward_substitution(U, y)
    n = length(y);
    x = zeros(n, 1);
    x(n) = y(n) / U(n, n);
    for i = n-1:-1:1
        x(i) = (y(i) - U(i, i+1:n) * x(i+1:n)) / U(i, i);
    end
end

