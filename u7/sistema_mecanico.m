function sistema_mecanico(Aval, Bval)
    % Fuerza de resistencia de los materiales
    A=Aval % Fuerza del material del resorte
    B=Bval % Fuerza del material del amortiguador

    % Datos necesarios para la simulación
    P = 1000;  % Peso del cuerpo
    M = P/9.8; % Masa del cuerpo
    h = 0.1;   % Paso de la simulacion
    d = 500;   % Duracion de la simulacion en segundos

    % Estadisticas de la simulación
    dpos=0;  %Desplazamiento maximo
    tdpos=0; %Tiempo desplazamiento maximo
    dneg=0;  %Desplazamiento minimo
    tdneg=0; %Momento desplazamineto minimo
    vpos=0;  %Velocidad maxima
    tvpos=0; %Tiempo velocidad maxima
    vneg=0;  %Velocidad negativa
    tvneg=0; %Momento velocidad minima

    f = @(t, x1, x2) x2;
    g = @(t, x1, x2, c1) c1 - ((B * 9.8 / P) * x2) - ((A * 9.8 / P) * x1);

    y1 = 0;  % Desplazamiento inicial
    y2 = 0;  % Velocidad inicial

    t = 0:h:d;
    iter = length(t);
    Y1(1) = y1;
    Y2(1) = y2;

    for  i = 1:(iter - 1)
       if i < 10
           co1 = 5 * 9.8 / P;
       else
           co1 = 0;
       end

       % Comienza a aplicar Runge-Kutta
       k11 = h * f(t(i), Y1(i), Y2(i));     % Para el desplazamiento
       k21 = h * g(t(i), Y1(i), Y2(i),co1); % Para la velocidad

       k12 = h * f(t(i) + h * 0.5, Y1(i) + k11 * 0.5, Y2(i) + k21 * 0.5);
       k22 = h * g(t(i) + h * 0.5, Y1(i) + k11 * 0.5, Y2(i) + k21 * 0.5, co1);

       k13 = h * f(t(i) + h * 0.5, Y1(i) + k12 * 0.5, Y2(i) + k22 * 0.5);
       k23 = h * g(t(i) + h * 0.5, Y1(i) + k12 * 0.5, Y2(i) + k22 * 0.5, co1);

       k14 = h * f(t(i) + h, Y1(i) + k13, Y2(i) + k23);
       k24 = h * g(t(i) + h, Y1(i) + k13, Y2(i) + k23, co1);

       Y1(i + 1) = Y1(i) + (k11 + 2 * k12 + 2 * k13 + k14) / 6;
       Y2(i + 1) = Y2(i) + (k21 + 2 * k22 + 2 * k23 + k24) / 6;

        % Desplazamiento Positivo
        if Y1(i + 1) > dpos
           dpos = Y1(i + 1);
           tdpos = i/10;
        end
        % Desplazamiento Negativo
        if Y1(i + 1) < dneg
           dneg = Y1(i + 1);
           tdneg = i/10;
        end
        % Velocidad Positiva
        if Y2(i + 1) > vpos
           vpos = Y2(i + 1);
           tvpos = i/10;
        end
        % Velocidad Negativa
        if Y2(i + 1) < vneg
           vneg = Y2(i + 1);
           tvneg = i/10;
        end
    end

    %Presentacion de los resultados
    fprintf('Desplazamiento maximo: %3.4f mts, producido a los: %3.1f seg \n', dpos, tdpos);
    fprintf('Desplazamiento minimo: %3.4f mts, producido a los: %3.1f seg \n', dneg, tdneg);
    fprintf('Velocidad maxima: %3.4f m/s, producida a los: %3.1f seg \n', vpos, tvpos);
    fprintf('Velocidad minima: %3.4f m/s, producida a los: %3.1f seg \n', vneg, tvneg);

    %Graficacion de resultados
    plot(t,Y1,'-',t,Y2,':');
    xlabel('Tiempo en segundos');
    ylabel('Desplazamiento y Velocidad')
    axis('auto');
end

