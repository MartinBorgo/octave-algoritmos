function resultados = simular_cola_general(duration, n_queue, n_server, mintl, maxtl, mints, maxts, queue_capacity)
    % SIMULAR_COLAS: Simula un sistema de múltiples colas y servidores
    %
    % Parámetros:
    %     duration: Duración total de la simulación.
    %     n_queue: Número de colas en el sistema
    %     n_server: Número de servidores disponibles
    %     mintl: Tiempo mínimo entre llegadas
    %     maxtl: Tiempo máximo entre llegadas
    %     mints: Tiempo mínimo de servicio
    %     maxts: Tiempo máximo de servicio
    %     queue_capacity: Capacidad máxima de cada cola

    %% 1. INICIALIZACIÓN DE VARIABLES

    % Variables de tiempo
    current_time = 0;          % Tiempo actual de la simulación
    last_event_time = 0;   % Tiempo del último evento procesado

    % Variables de las colas
    queue_length = zeros(1, n_queue);               % Longitud actual de cada cola
    wait_time = zeros(queue_capacity, n_queue);     % Matriz de tiempos de espera
    total_wait_queue = zeros(1, n_queue);           % Tiempo total de espera por cola
    acumulate_length = zeros(1, n_queue);           % Longitud acumulada por cola

    % Variables de los servidores
    server_state = zeros(1, num_servidores);         % 0=libre, 1=ocupado
    end_service_time = inf(1, num_servidores);       % Tiempo de finalización de cada Servidor
    server_usage = zeros(1, num_servidores);         % Tiempo de uso

    % Contadores y eventos
    next_arrive_time = 0;           % Tiempo de la próxima llegada
    entidades_llegadas = 0;         % Total de entidades que llegaron
    entidades_atendidas = 0;        % Total de entidades que fueron atendidas

    %% 2. BUCLE PRINCIPAL DE SIMULACIÓN
    while current_time < duration
        % 2.1 Determinar próximo evento
        [current_time, tipo_evento, servidor_id] = get_next_event(next_arrive_time, end_service_time);

        % 2.2 Actualizar estadísticas
        delta_tiempo = current_time - last_event_time;
        for i = 1:n_queue
            acumulate_length(i) = acumulate_length(i) + queue_length(i) * delta_tiempo;
        end
        for i = 1:num_servidores
            server_usage(i) = server_usage(i) + server_state(i) * delta_tiempo;
        end

        % 2.3 Procesar evento correspondiente
        if tipo_evento == 1  % Llegada
            % Incrementar contador de llegadas
            entidades_llegadas = entidades_llegadas + 1;

            % Programar próxima llegada
            next_arrive_time = current_time + generate_rand_time(mintl, maxtl);

            % Buscar el primer servidor libre que encuentra y devuelve su ID (posición en el array)
            servidor_libre = find(server_state == 0, 1);

            % Como la función find devuelve un array vacio si no tiene exito
            % se comprueva que el valor sea un número, ya que ~isempty(1) = true
            if ~isempty(servidor_libre)
                % Asignar directamente a servidor libre
                server_state(servidor_libre) = 1;
                tiempo_servicio = generate_rand_time(mints, maxts);
                end_service_time(servidor_libre) = current_time + tiempo_servicio;
            else
                % Buscar cola con menor ocupación
                [~, cola_menor] = min(queue_length);
                if queue_length(cola_menor) < queue_capacity
                    queue_length(cola_menor) = queue_length(cola_menor) + 1;
                    wait_time(queue_length(cola_menor), cola_menor) = current_time;
                end
            end

        else  % Partida (tipo_evento == 2)
            % Incrementar contador de entidades atendidas
            entidades_atendidas = entidades_atendidas + 1;

            % Liberar servidor
            server_state(servidor_id) = 0;
            end_service_time(servidor_id) = inf;

            % Buscar próxima entidad para atender
            for i = 1:n_queue
                if queue_length(i) > 0
                    % Calcular tiempo de espera
                    tiempo_espera = current_time - wait_time(1, i);
                    total_wait_queue(i) = total_wait_queue(i) + tiempo_espera;

                    % Mover la cola
                    wait_time(1:end-1, i) = wait_time(2:end, i);
                    wait_time(end, i) = 0;
                    queue_length(i) = queue_length(i) - 1;

                    % Asignar al servidor
                    server_state(servidor_id) = 1;
                    tiempo_servicio = generate_rand_time(mints, maxts);
                    end_service_time(servidor_id) = current_time + tiempo_servicio;
                    break;
                end
            end
        end

        last_event_time = current_time;
    end

    %% 3. GENERAR RESULTADOS
    resultados = struct();
    resultados.entidades_llegadas = entidades_llegadas;
    resultados.entidades_atendidas = entidades_atendidas;
    resultados.tiempo_simulacion = current_time;

    % Estadísticas por cola
    for i = 1:n_queue
        resultados.longitud_promedio_cola(i) = acumulate_length(i) / current_time;
        if entidades_atendidas > 0
            resultados.tiempo_espera_promedio(i) = total_wait_queue(i) / entidades_atendidas;
        else
            resultados.tiempo_espera_promedio(i) = 0;
        end
    end

    % Estadísticas por servidor
    for i = 1:num_servidores
        resultados.server_usage(i) = (server_usage(i) / current_time) * 100;
    end
end

%% FUNCIONES AUXILIARES

function [tiempo, tipo, servidor_id] = get_next_event(tiempo_llegada, tiempos_fin)
    % Determina cuál es el próximo evento
    % tipo: 1=llegada, 2=partida
    [min_fin, servidor_id] = min(tiempos_fin);

    if tiempo_llegada < min_fin
        tiempo = tiempo_llegada;
        tipo = 1;
        servidor_id = 0;
    else
        tiempo = min_fin;
        tipo = 2;
    end
end

function tiempo = generate_rand_time(min_tiempo, max_tiempo)
    % Genera un tiempo aleatorio entre min_tiempo y max_tiempo
    tiempo = min_tiempo + (max_tiempo - min_tiempo) * rand(1);
    tiempo = floor(tiempo * 100) / 100;  % Redondear a 2 decimales
end
