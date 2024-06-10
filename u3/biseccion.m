function root = biseccion(fx, a, b, tol=10e-6, max_iter=25)
    if fx(a) * fx(b) > 0
        error('La función debe tener signos opuestos en los puntos a y b.');
    end

    for i = 1:max_iter
        c = (a + b) / 2;
        fprintf('Valor de a: %.5f | Valor de b: %.5f | Valor de m %.5f | Valor de f(a): %.5f | Valor de f(b): %.5f | Valor de f(m): %.5f\n', a, b, c, fx(a), fx(b), fx(c));

        if fx(c) == 0 || abs(fx(c)) < tol
            root = c;
            return;
        end

        if fx(a) * fx(c) < 0
            b = c;
        else
            a = c;
        end
    end

    root = (a + b) / 2;
end
