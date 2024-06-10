function root = regula_falsi(fx, a, b, tol=10e-6, max_iter=25)
    if fx(a) * fx(b) > 0
        error('La función debe tener signos opuestos en los puntos a y b.');
    end

    fa = fx(a);
    fb = fx(b);

    for i = 1:max_iter
        w = (a * fb - b * fa) / (fb - fa);
        fw = fx(w);

        fprintf('Valor de a: %.5f | Valor de b: %.5f | Valor de w %.5f | Valor de f(a): %.5f | Valor de f(b): %.5f | Valor de f(w): %.5f\n', a, b, w, fa, fb, fw)

        if abs(fw) < tol
            root = w;
            return;
        end

        if fa * fw < 0
            b = w;
            fb = fw;
        else
            a = w;
            fa = fw;
        end
    end

    root = (a * fb - b * fa) / (fb - fa);
    disp('Se alcanzó el número máximo de iteraciones sin converger a la tolerancia especificada.');
end

