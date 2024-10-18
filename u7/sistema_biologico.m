function sistema_biologico(preys, hunters, h, d)
  disp(' <| SIMULACION EN PROCESO ... |> ');
  % Estadísticas de la simulación
  maco = 0;     %Maximo Conejo
  mico = 20000; %Minimo Conejo
  mazo = 0;     %Maximo Zorro
  mizo = 8000;  %Minimo Zorro

  % Constantes utilizadas en las fórmulas
  r = 0.001;
  s = 0.01;
  a = 0.000002;
  b = 0.000001;

  % Funciones implicadas en la ecuación diferencial
  f = @(t, x, y) r * x - a * x * y;
  g = @(t, x, y) -s * y + b * x * y;

  % Datos útiles para graficar los resultados y realizar las iteraciones
  T = 0:h:d;
  iter = length(T);
  % Predicciones de las poblaciones de presas y depredadores
  X(1) = preys;
  Y(1) = hunters;

  for i = 1:(iter - 1)
    % Aplicando Runge-Kutta de cuarto grado
    k11 = h * f(T(i), X(i), Y(i));
    k21 = h * g(T(i), X(i), Y(i));

    k12 = h * f(T(i) + h * 0.5, X(i) + k11 / 2, Y(i) + k21*0.5);
    k22 = h * g(T(i) + h * 0.5, X(i) + k11 / 2, Y(i) + k21*0.5);

    k13 = h * f(T(i) + h * 0.5, X(i) + k12 / 2, Y(i) + k22 * 0.5);
    k23 = h * g(T(i) + h * 0.5, X(i) + k12 / 2, Y(i) + k22 * 0.5);

    k14 = h * f(T(i) + h, X(i) + k13, Y(i) + k23);
    k24 = h * g(T(i) + h, X(i) + k13, Y(i) + k23);

    X(i + 1) = X(i) + (k11 + 2 * k12 + 2 * k13 + k14) / 6;
    Y(i + 1) = Y(i) + (k21 + 2 * k22 + 2 * k23 + k24) / 6;

    % Banderas modificables para mostrar la cantidad de conejos y zorros en un momento en particular
    if i == 8000
      fprintf('Cantidad de Conejos %6.1f --- Cantidad de Zorros %6.1f |> En %d Unidades de Tiempo \n', X(i + 1), Y(i + 1), i/10);
    end
    if i == 15000
      fprintf('Cantidad de Conejos %6.1f --- Cantidad de Zorros %6.1f |> En %d Unidades de Tiempo \n', X(i + 1), Y(i + 1), i/10);
    end

    % Maximo conejo
    if X(i + 1) > maco
       maco = X(i + 1);
       tmaco = i/10;
    end
    % Minimo conejo
    if X(i + 1) < mico
       mico = X(i + 1);
       tmico = i/10;
    end
    % Maximo zorros
    if Y(i + 1) > mazo
       mazo = Y(i + 1);
       tmazo = i/10;
    end
    % Minimo zorros
    if Y(i + 1) < mizo
       mizo = Y(i + 1);
       tmizo = i/10;
    end
  end
  %Presentacion de los resultados
  disp(' <| SIMULACION TERMINADA - DATOS RESULTANTES |> ');
  fprintf('Poblacion maxima de presas: %3.2f Conejos | Alacanzado a los %d Unidades de Tiempo \n', maco, tmaco);
  fprintf('Poblacion minima de presas: %3.2f Conejos | Alacanzado a los %d Unidades de Tiempo \n', mico, tmico);
  fprintf('Poblacion maxima de depredadores: %3.2f Zorros | Alacanzado a los %d Unidades de Tiempo \n', mazo, tmazo);
  fprintf('Población minima de depredadores: %3.2f Zorros | Alacanzado a los %d Unidades de Tiempo \n', mizo, tmizo);

  %Graficacion de resultados
  plot(T,X,'-',T,Y,':');
  xlabel('Unidades de Tiempo');
  ylabel('Zorros')
  axis('auto');
end


