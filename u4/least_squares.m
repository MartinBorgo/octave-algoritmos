function coef = least_squares(x, y, n)
    % x son los valores independientes
    % y son los valores dependientes
    % n es el grado del polinomio que se desea ajustar
    % coef son los coeficientes del polinomio ajustado

    % Convertir x e y en vectores columna si aún no lo son
    x = x(:);
    y = y(:);

    % Número de observaciones
    N = length(x);

    % Construir la matriz de diseño
    % La primera columna es x^0, la segunda x^1, hasta x^n
    X = ones(N, 1);  % Comenzar con la columna para el término constante
    for j = 1:n
        X = [X, x.^j];  % Añadir columnas para x^1 hasta x^n
    end

    % Calcular la matriz normal (X'X) y el vector (X'y)
    XtX = X' * X;
    Xty = X' * y;

    IA = inv(XtX);

    disp(IA);
    % Resolver el sistema normal para obtener los coeficientes
    % coef = (X'X)^-1 * (X'y)
    coef = IA * Xty;  % Utiliza el operador de división de matrices para resolver

    % Los coeficientes están en orden de término constante a coeficiente de x^n
end

