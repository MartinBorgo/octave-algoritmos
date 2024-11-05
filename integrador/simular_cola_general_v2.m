function simular_cola_general_v1(duration, n_queue, n_server, mintl, maxtl, mints, maxts, max_wait_time = 3, queue_capacity = 100)
    % Simula un sistema de múltiples colas y servidores
    % Parámetros:
    %     duration: Duración total de la simulación.
    %     n_queue: Número de colas en el sistema
    %     n_server: Número de servidores disponibles
    %     mintl: Tiempo mínimo entre llegadas
    %     maxtl: Tiempo máximo entre llegadas
    %     mints: Tiempo mínimo de servicio
    %     maxts: Tiempo máximo de servicio
    %     queue_capacity: Capacidad máxima de cada cola, valor por defecto 100

    % Variables de tiempo
    current_time = 0;                               % Tiempo actual de la simulación
    next_arrive_time = 0;                           % Tiempo de la próxima llegada
    last_event_time = 0;                            % Tiempo del último evento procesado

    % Variables de las colas
    queue_length = zeros(1, n_queue);               % Longitud actual de cada cola
    wait_queue = zeros(queue_capacity, n_queue);    % Matriz de tiempos de llegada de cada fila
    total_wait_queue = zeros(1, n_queue);           % Tiempo total de espera de cada cola
    acumulate_length = zeros(1, n_queue);           % Longitud acumulada de cada cola
    abandoned_entities = zeros(1, n_queue);         % Cantidad de entidades que abandonaron cada cola

    % Variables de los servidores
    server_state = zeros(1, n_server);              % Estados de los servidores 0=libre, 1=ocupado
    end_service_time = inf(1, n_server);            % Tiempo de finalización de cada servidor
    server_usage = zeros(1, n_server);              % Tiempo de uso de cada servidor

    % Contadores y eventos
    arrived_entities = 0;                           % Total de entidades que llegaron
    attended_entities = 0;                          % Total de entidades que fueron atendidas

    % COMIENZO DE LA SIMULACIÓN
    while current_time < duration
        % Determina el próximo evento que se va a ejecutar
        [current_time, event_type, server_id] = get_next_event(next_arrive_time, end_service_time);
        % Actualiza las estadísticas sobre la cantidad acumulada entidades
        % en las colas y los tiempos de uso del servidor
        delta = current_time - last_event_time;
        for i = 1:n_queue
            acumulate_length(i) = acumulate_length(i) + queue_length(i) * delta;
        end
        for i = 1:n_server
            server_usage(i) = server_usage(i) + server_state(i) * delta;
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
            % se comprueva que el valor sea un número, ya que ~isempty(1) = true
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
                end
            end

        elseif event_type == 2
            % Incrementa el contador de entidades atendidas
            attended_entities = attended_entities + 1;
            % Libera el servidor que esa entidad estaba utilizando y cambia
            % su tiempo de fin de servicio a infinito
            server_state(server_id) = 0;
            end_service_time(server_id) = inf;
            % Busca la próxima entidad a atender en la cola más larga
            [q_length , queue_id] = max(queue_length);

            if q_lenght > 0
              % Calcula el tiempo de espera de la entidad
              wait_time = current_time - wait_queue(1, queue_id);
              total_wait_queue(queue_id) = total_wait_queue(queue_id) + wait_time;

              % Chequea si la entidad va a dejar la cola por llegar al timepo
              % máximo de espera
              if wait_time >= max_wait_time
                % Saca dicho elemento de la cola y la correo además de actualizar
                % la cantidad de entidades que avandonaron dicha cola
                wait_queue(1:end-1, queue_id) = wait_queue(2:end, queue_id);
                wait_queue(end, queue_id) = 0;
                queue_length(queue_id) = queue_length(queue_id) - 1;
                abandoned_entities(queue_id) = abandoned_entities(queue_id) + 1;
              end

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
        avarage_queue_lenght(i) = acumulate_length(i) / current_time;

        if attended_entities > 0
            avarage_waiting_queue_time(i) = total_wait_queue(i) / attended_entities;
        else
            avarage_waiting_queue_time(i) = 0;
        end
    end

    % Estadísticas por servidor
    for i = 1:n_server
        server_usage(i) = (server_usage(i) / current_time) * 100;
    end

    % IMPRECIÓN DE LOS DATOS RESULTANTES DE LA SUMULACIÓN
    disp('ESTADISTICAS GLOBALES DE LA SIMULACIÓN');
    fprintf('Cantidad de entidades que llegaron: %d \n', arrived_entities);
    fprintf('Cantidad de entidades atendidas: %d \n', attended_entities);
    fprintf('Tiempo total de simulacion: %d \n', current_time);
    fprintf('Total de entidades que abandonaron las colas: %d \n', sum(abandoned_entities));

    disp('ESTADISTICAS PARA LAS COLAS');
    for i = 1:n_queue
      fprintf('Estadísticas para la cola N°%d \n', i);
      fprintf('Tamaño promedio de la cola: %.2f \n', avarage_queue_lenght(i));
      fprintf('Tiempo de espera total en la cola: %.2f \n', total_wait_queue(i));
      fprintf('Tiempo de espera promedio: %.2f \n', avarage_waiting_queue_time(i));
      fprintf('Cantida de entidades que abandonaron la cola: %d \n', abandoned_entities(i));
      disp('<|--------------------------------------------------|>');
    end

    disp('ESTADISTICAS PARA LOS SERVIDORES');
    for i = 1:n_server
      fprintf('Estadísticas para el servidor N°%d \n', i);
      fprintf('Uso del servidor durante la simulación: %.2f%% \n', server_usage(i));
      disp('<|--------------------------------------------------|>');
    end
end

% FUNCIONES AUXILIARES
function [time, e_type, server_id] = get_next_event(arrived_time, servers_end_service_time)
    % Determina cuál es el próximo evento que va a ocurrir

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

function time = (min_time, max_time)
    % Genera un tiempo aleatorio entre el tiempo mínimo y máximo
    time = min_time + (max_time - min_time) * rand(1);
    time = floor(time * 100) / 100;  % Redondear el resultado a 2 dígitos decimales
end

#{
% Configuración base de la Simulación 1
duration = 25;         % Duración de la simulación
mintl = 1;            % Tiempo mínimo entre llegadas
maxtl = 4;            % Tiempo máximo entre llegadas
mints = 1;            % Tiempo mínimo de servicio
maxts = 5;            % Tiempo máximo de servicio
queue_capacity = 100;  % Capacidad de la cola

% Simulación 1: Sistema básico (1 cola, 1 servidor)
disp('SIMULACIÓN 1: Sistema básico (1 cola, 1 servidor)');
disp('====================================================');
simular_cola_general(duration, 1, 1, mintl, maxtl, mints, maxts, queue_capacity);

% Simulación 2: Sistema con múltiples servidores (1 cola, 2 servidores)
disp('SIMULACIÓN 2: Sistema con múltiples servidores (1 cola, 2 servidores)');
disp('====================================================');
simular_cola_general(duration, 1, 2, mintl, maxtl, mints, maxts, queue_capacity);

% Simulación 3: Sistema con múltiples colas (2 colas, 1 servidor)
disp('SIMULACIÓN 3: Sistema con múltiples colas (2 colas, 1 servidor)');
disp('====================================================');
simular_cola_general(duration, 2, 1, mintl, maxtl, mints, maxts, queue_capacity);

% Simulación 4: Sistema con múltiples colas y servidores (2 colas, 2 servidores)
disp('SIMULACIÓN 4: Sistema con múltiples colas y servidores (2 colas, 2 servidores)');
disp('====================================================');
simular_cola_general(duration, 2, 2, mintl, maxtl, mints, maxts, queue_capacity);

% Simulación 5: Sistema grande (3 colas, 3 servidores)
disp('SIMULACIÓN 5: Sistema grande (3 colas, 3 servidores)');
disp('====================================================');
simular_cola_general(duration, 3, 3, mintl, maxtl, mints, maxts, queue_capacity);
#}
