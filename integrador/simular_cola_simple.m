function simular_cola_simple(arrival_times = [1, 2, 3, 4, 5, 6], service_times = [2, 2.5], duration = 20)
    % Variables de tiempo
    current_time = 0;         % Tiempo actual de la simulación
    next_arrive_time = 0;     % Tiempo de la próxima llegada
    last_event_time = 0;      % Tiempo del último evento procesado

    % Variables de la cola
    queue_length = 0;         % Longitud actual de la cola
    wait_queue = [];          % Lista de tiempos de llegada de los clientes en cola
    total_wait_time = 0;      % Tiempo total de espera de los clientes

    % Variables del servidor
    server_state = 0;         % Estado del servidor (0=libre, 1=ocupado)
    server_usage = 0;
    end_service_time = inf;   % Tiempo de finalización del servicio actual

    % Contadores y eventos
    arrived_entities = 0;     % Total de clientes que llegaron
    attended_entities = 0;    % Total de clientes que fueron atendidos

    % Gráfica de la evolución de la longitud de la cola
    plot_queue_length = zeros(1, duration);

    % COMIENZO DE LA SIMULACIÓN
    while current_time < duration
        % Determina el próximo evento que se va a ejecutar
        if next_arrive_time < end_service_time
            current_time = next_arrive_time;
            event_type = 1;
        else
            current_time = end_service_time;
            event_type = 2;
        end

        % Actualiza las estadísticas de tiempo de uso del servidor
        delta = current_time - last_event_time;
        server_usage = server_usage + (server_state * delta);

        % Procesa los eventos, valores de la variable event_type:
        %   1 -> Llegada de un cliente
        %   2 -> Partida de un cliente
        if event_type == 1
            % Incrementa el contador de llegadas
            arrived_entities = arrived_entities + 1;

            % Programa el tiempo de llegada del próximo cliente
            next_arrive_time = current_time + arrival_times(randi(length(arrival_times)));

            % Si el servidor está libre, asigna el cliente al servidor
            if server_state == 0
                server_state = 1;
                service_time = service_times(randi(length(service_times)));
                end_service_time = current_time + service_time;
            else
                % Si el servidor está ocupado, agrega el cliente a la cola
                queue_length = queue_length + 1;
                wait_queue(queue_length) = current_time;
            end

        elseif event_type == 2
            % Incrementa el contador de clientes atendidos
            attended_entities = attended_entities + 1;

            % Libera el servidor
            server_state = 0;
            end_service_time = inf;

            % Chequea que exista alguna entidad para atender en la cola
            if ~isempty(wait_queue)
                % Calcula el tiempo de espera del cliente
                wait_time = current_time - wait_queue(1);
                total_wait_time = total_wait_time + wait_time;

                % Saca al primer cliente de la cola para ser atendido
                wait_queue = wait_queue(2:end);
                queue_length = queue_length - 1;

                % Asigna el cliente al servidor
                server_state = 1;
                service_time = service_times(randi(length(service_times)));
                end_service_time = current_time + service_time;
            end
        end

        % Registra la longitud de la cola en cada minuto
        plot_queue_length(ceil(current_time) + 1) = queue_length;

        last_event_time = current_time;
    end

    % CÁLCULO DE ESTADÍSTICAS
    average_wait_time = total_wait_time / attended_entities;
    server_usage_percentage = (server_usage / duration) * 100;

    % IMPRESIÓN DE LOS RESULTADOS
    disp('RESULTADOS DE LA SIMULACIÓN');
    fprintf('Cantidad de clientes que llegaron: %d\n', arrived_entities);
    fprintf('Cantidad de clientes atendidos: %d\n', attended_entities);
    fprintf('Tiempo promedio de espera de los clientes: %.2f minutos\n', average_wait_time);
    fprintf('Uso del servidor: %.2f%%\n', server_usage_percentage);

    % GRÁFICA DE LA EVOLUCIÓN DE LA LONGITUD DE LA COLA
    figure;
    plot(0:duration-1, plot_queue_length(1:20));
    title('Evolución de la Longitud de la Cola');
    xlabel('Tiempo (minutos)');
    ylabel('Longitud de la Cola');
end

function [time, e_type] = get_next_event(arrived_time, server_end_time)
    % Determina cuál es el próximo evento que va a ocurrir

end

