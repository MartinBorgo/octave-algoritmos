function graficar(data, varargin)
    % Verifica que la matriz principal tenga dos columnas
    if size(data, 2) ~= 2
        error('La matriz de entrada debe tener exactamente dos columnas.');
    end

    % Extrae los valores de x e y de la matriz principal
    x = data(:, 1);
    y = data(:, 2);

    % Grafica los datos de la matriz principal
    plot(x, y, 'DisplayName', 'Dataset 1');
    hold on; % Mantiene el gráfico para agregar más datos

    % Si hay matrices adicionales, gráficarlas también
    if ~isempty(varargin)
        for i = 1:length(varargin)
            additionalData = varargin{i};
            if size(additionalData, 2) ~= 2
                error('Cada matriz adicional debe tener exactamente dos columnas.');
            end
            x_add = additionalData(:, 1);
            y_add = additionalData(:, 2);
            plot(x_add, y_add, 'DisplayName', sprintf('Dataset %d', i + 1));
        end
    end

    % Configura el gráfico
    xlabel('Valores de X');
    ylabel('Valores de Y');
    legend show;
    grid on;
    hold off;
end
