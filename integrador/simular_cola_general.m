function simular_cola_general(simulation_duration, mintl, maxtl, mints, maxts, n_queue = 1, n_server = 1, max_wait_time = 3, queue_capacity = 10)
    % Simula un sistema de múltiples colas y servidores
    % Parámetros:
    %     simulation_duration:   Duración total de la simulación.
    %     n_queue:               Número de colas utilizadas en la simulación, por defecto
    %                            este valor esta seteado en 1.
    %     n_server:              Número de servidores utilizados en la simulación, por defecto
    %                            este valor esta seteado en 1.
    %     mintl:                 Tiempo mínimo entre llegadas.
    %     maxtl:                 Tiempo máximo entre llegadas.
    %     mints:                 Tiempo mínimo de servicio.
    %     maxts:                 Tiempo máximo de servicio.
    %     max_wait_time:         Tiempo máximo de espera permitido antes de que una entidad
    %                            abandone la cola, por defecto este valor esta seteado en 3.
    %     queue_capacity:        Capacidad máxima de cada cola, por defecto este valor esta
    %                            seteado en 10.

    % Variables de tiempo
    current_time = 0;                               % Tiempo actual de la simulación.
    next_arrive_time = 0;                           % Tiempo de la próxima llegada.
    last_event_time = 0;                            % Tiempo del último evento procesado.

    % Variables de las colas
    queue_length = zeros(1, n_queue);               % Longitud actual de cada cola.
    wait_queue = zeros(queue_capacity, n_queue);    % Matriz de tiempos de llegada de cada fila.
    total_wait_queue = zeros(1, n_queue);           % Tiempo total de espera de cada cola.
    acumulate_length = zeros(1, n_queue);           % Longitud acumulada de cada cola.
    attended_entities = zeros(1, n_queue);          % Cantidad de entidades que fueron atendidas en cada cola.
    abandoned_entities = zeros(1, n_queue);         % Cantidad de entidades que dejaron la cola por superar el
                                                    % tiempo de espera máximo.

    % Variables de los servidores
    server_state = zeros(1, n_server);              % Estados de los servidores 0=libre, 1=ocupado.
    end_service_time = inf(1, n_server);            % Tiempo de finalización de cada servidor.
    server_usage = zeros(1, n_server);              % Tiempo de uso de cada servidor.
    server_stats = zeros(1, n_server);              % Cantidad de entidades atendidas por cada servidor.

    % Contadores y eventos
    arrived_entities = 0;                           % Total de entidades que llegaron.
    rejected_entities = 0;                          % Entidades que salen del sistema porque todas las colas
                                                    % estan en us máxima capacidad.

    % COMIENZO DE LA SIMULACIÓN
    while current_time < simulation_duration
        % Determina el próximo evento que se va a ejecutar
        [current_time, event_type, server_id] = get_next_event(next_arrive_time, end_service_time);
        % Actualiza las estadísticas sobre la cantidad acumulada de
        % entidades en las colas y los tiempos de uso del servidor
        delta = current_time - last_event_time;
        for i = 1:n_queue
            acumulate_length(i) = acumulate_length(i) + (queue_length(i) * delta);
        end
        for i = 1:n_server
            server_usage(i) = server_usage(i) + (server_state(i) * delta);
        end

        % Procesa los eventos, valores de la variable event_type:
        %   1 -> Llegada de una entidad
        %   2 -> Partida de una entidad
        if event_type == 1
            % Incrementa el contador de llegadas
            arrived_entities = arrived_entities + 1;

            % Programa el tiempo de llegada de la siguiente entidad
            next_arrive_time = current_time + generate_rand_time(mintl, maxtl);

            % Buscar el primer servidor libre que encuentra
            % y devuelve su ID (posición en el array)
            free_server_id = find(server_state == 0, 1);

            % Como la función find devuelve un array vacio si no tiene exito
            % se comprueba que el valor sea un número, ya que ~isempty(1) = true
            if ~isempty(free_server_id)
                % Asigna la entidad directamente al primer servidor libre encontrado
                server_state(free_server_id) = 1;
                service_time = generate_rand_time(mints, maxts);
                end_service_time(free_server_id) = current_time + service_time;
            else
                % Busca la cola con menor ocupación
                [~, shortest_queue] = min(queue_length);
                if queue_length(shortest_queue) < queue_capacity
                    queue_length(shortest_queue) = queue_length(shortest_queue) + 1;
                    wait_queue(queue_length(shortest_queue), shortest_queue) = current_time;
                else
                    rejected_entities = rejected_entities + 1;
                end
            end

        elseif event_type == 2
            % Actualiza la cantidad de entidades atendidas por el servidor en cuestion

            if server_state(server_id) == 1
              server_stats(server_id) = server_stats(server_id) + 1;
            end
            % Libera el servidor que esa entidad estaba utilizando y cambia
            % su tiempo de fin de servicio a infinito
            server_state(server_id) = 0;
            end_service_time(server_id) = inf;

            % Saca de las filas a todas las entidades que superaron el tiempo
            % máximo de espera permitido en la cola
            for current_queue = 1:n_queue
              i = 1;
              while i <= queue_length(current_queue)
                wait_time = current_time - wait_queue(i, current_queue);
                if wait_time >= max_wait_time
                  % Sacamos la entidad que superó el tiempo máximo
                  wait_queue(i:end-1, current_queue) = wait_queue(i+1:end, current_queue);
                  wait_queue(end, current_queue) = 0;
                  queue_length(current_queue) = queue_length(current_queue) - 1;
                  abandoned_entities(current_queue) = abandoned_entities(current_queue) + 1;
                  % No incrementamos i porque ahora hay un nuevo elemento en esta posición
                else
                  i = i + 1;
                end
              end
            end

            % Busca la próxima entidad a atender en la cola más larga
            [~, queue_id] = max(queue_length);

            if queue_length(queue_id) > 0
              % Se aumenta la cantidad de entidades atendidas para esa cola
              attended_entities(queue_id) = attended_entities(queue_id) + 1;
              % Calcula el tiempo de espera de la entidad
              wait_time = current_time - wait_queue(1, queue_id);
              total_wait_queue(queue_id) = total_wait_queue(queue_id) + wait_time;

              % Mueve la cola para sacar a la primer entidad de la cola (porque ya esta siendo atendida)
              wait_queue(1:end-1, queue_id) = wait_queue(2:end, queue_id);
              wait_queue(end, queue_id) = 0;
              queue_length(queue_id) = queue_length(queue_id) - 1;

              % Se le asigna la entidad al servidor liberado
              server_state(server_id) = 1;
              service_time = generate_rand_time(mints, maxts);
              end_service_time(server_id) = current_time + service_time;
            end
        end
        last_event_time = current_time;
    end
    % CALCULO DE ESTADISTICAS ADICIONALES
    % Estadísticas por cola
    for i = 1:n_queue
      average_queue_lenght(i) = acumulate_length(i) / current_time;

      if attended_entities(i) > 0
         average_waiting_queue_time(i) = total_wait_queue(i) / attended_entities(i);
      else
         average_waiting_queue_time(i) = 0;
      end
    end

    % Estadísticas por servidor
    for i = 1:n_server
      server_usage(i) = (server_usage(i) / current_time) * 100;
    end

    % Estadísticas globales del sistema
    if arrived_entities > 0
      abandonment_rate = (sum(abandoned_entities) / arrived_entities) * 100;
      rejection_rate = (rejected_entities / arrived_entities) * 100;
    else
      abandonment_rate = 0;
      rejection_rate = 0;
    end

    % IMPRECIÓN DE LOS DATOS RESULTANTES DE LA SUMULACIÓN
    disp('ESTADISTICAS GLOBALES DE LA SIMULACIÓN');
    fprintf('Cantidad de entidades que llegaron: %d \n', arrived_entities);
    fprintf('Cantidad de entidades en espera atendidas: %d \n', sum(attended_entities));
    fprintf('Tiempo total de simulacion: %d \n', current_time);
    fprintf('Total de entidades que abandonaron las colas por exceder el tiempo maximo de espera: %d \n', sum(abandoned_entities));
    fprintf('Cantidad de entidades que salieron del sistema porque todas las colas estában a su maxima capacidad: %d \n', rejected_entities);
    fprintf('Tasa global de abandono: %.2f%% \n', abandonment_rate);
    fprintf('Tasa global de rechazo: %.2f%% \n', rejection_rate);
    disp('<|--------------------------------------------------|>');

    disp('ESTADISTICAS PARA LAS COLAS');
    for i = 1:n_queue
      fprintf('Estadísticas para la cola N°%d \n', i);
      fprintf('Tamaño promedio de la cola: %.2f \n', average_queue_lenght(i));
      fprintf('Tiempo de espera total en la cola: %.2f \n', total_wait_queue(i));
      fprintf('Tiempo de espera promedio: %.2f \n', average_waiting_queue_time(i));
      fprintf('Cantidad de entidades en espera atendidas: %d \n', attended_entities(i));
      fprintf('Cantidad de entidades que dejaron la fila por exceder el tiempo maximo de espera %d \n', abandoned_entities(i));
      disp('<|--------------------------------------------------|>');
    end

    disp('ESTADISTICAS PARA LOS SERVIDORES');
    for i = 1:n_server
      fprintf('Estadísticas para el servidor N°%d \n', i);
      fprintf('Uso del servidor: %.2f%% \n', server_usage(i));
      fprintf('Cantidad de entidades atendidas por el servidor: %d \n', server_stats(i));
      disp('<|--------------------------------------------------|>');
    end
end

% FUNCIONES AUXILIARES
function [time, e_type, server_id] = get_next_event(arrived_time, servers_end_service_time)
    % Determina cuál es el próximo evento que va a ocurrir
    % Parámetros:
    %     arrived_time:                Tiempo de arribo de la próxima entidad.
    %     servers_end_service_time:    Lista con los tiempos de finalización de servicio
    %                                  de todos los servidores.

    % Obtiene el tiempo y el servidor que se desocupara a continuación
    [min_service_time, server_id] = min(servers_end_service_time);

    if arrived_time < min_service_time
      time = arrived_time;
      e_type = 1;
      server_id = 0;
    else
      time = min_service_time;
      e_type = 2;
    end
end

function time = generate_rand_time(min_time, max_time)
    % Genera un tiempo aleatorio entre el tiempo mínimo y máximo
    time = min_time + (max_time - min_time) * rand(1);
    time = floor(time * 100) / 100;  % Redondear el resultado a 2 dígitos decimales
end
