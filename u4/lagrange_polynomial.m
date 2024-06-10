function P = lagrange_polynomial(vx, vy)
    % x son los puntos en los cuales se conocen los valores del polinomio
    % y son los valores del polinomio en esos puntos x
    % P será el polinomio interpolador de Lagrange en forma simbólica

    % Verificar que x y y sean del mismo tamaño
    if length(vx) ~= length(vy)
        error('Los vectores x y y deben tener el mismo tamaño.');
    end

    % Inicializar el polinomio P
    P = 0;
    n = length(vx);

    % Usar el paquete de simbolos de MATLAB/Octave
    pkg load symbolic;
    syms x;

    % Construir el polinomio de Lagrange
    for i = 1:n
        % Iniciar L con 1 para la multiplicación posterior
        L = 1;

        for j = 1:n
            if j ~= i
                % Construir los polinomios base L_i
                L = L * (x - vx(j)) / (vx(i) - vx(j));
            end
        end

        % Sumar el término actual al polinomio total
        P = P + L * vy(i);
    end

    % Expandir el polinomio para simplificarlo
    P = expand(P);
end

