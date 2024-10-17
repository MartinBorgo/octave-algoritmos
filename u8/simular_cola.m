function simular_cola(arrival_intervals, service_times)
  % Simula un sistema de colas dado los tiempos de arribo y servicio.
  %
  % Parámetros:
  %   arrival_intervals: Vector de tiempos entre arribos.
  %   service_times: Vector de tiempos de servicio.

  % Número de entidades
  num_entities = length(arrival_intervals);

  % Inicialización de variables
  arrival_times = cumsum(arrival_intervals); % Tiempos de llegada acumulados
  departure_times = zeros(1, num_entities); % Tiempos de salida
  queue_times = zeros(1, num_entities); % Tiempos en cola

  % Simulación del sistema de colas
  for i = 1:num_entities
      if i == 1
          % El primer cliente no espera
          departure_times(i) = arrival_times(i) + service_times(i);
      else
          % El cliente i llega después de que el cliente i-1 ha salido
          if arrival_times(i) > departure_times(i-1)
              departure_times(i) = arrival_times(i) + service_times(i);
          else
              % El cliente i tiene que esperar
              queue_times(i) = departure_times(i-1) - arrival_times(i);
              departure_times(i) = departure_times(i-1) + service_times(i);
          end
      end
  end

  % Resultados
  nne = num_entities; % Número de entidades que entran
  nes = num_entities; % Número de entidades que salen (todas salen en este caso)
  tqt = sum(queue_times); % Tiempo total en cola
  tt = departure_times(end); % Tiempo total hasta que la última entidad sale

  fprintf('Número de entidades que entran (nne): %d\n', nne);
  fprintf('Número de entidades que salen (nes): %d\n', nes);
  fprintf('Tiempo total de cola: %.6f \n', tqt);
  fprintf('Tiempo total del sistema: %.6f\n', tt);
end




