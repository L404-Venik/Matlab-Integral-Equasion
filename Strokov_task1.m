clc
clear
close all

tic

% ПЕРЕМЕННЫЕ
a = 0;
b = 1;
Nx = 11;
X_span = linspace(a,b,Nx);


%% РЕШЕНИЕ СИСТЕМЫ ОДУ, ПОЛУЧЕННОЙ ИЗ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ

function dYdx = ode_second_order(x, Y)
    
    dydx = Y(1);
    y = Y(2);
    
    dYdx = [7 * dydx - 10 * y - 20;
            dydx];
end

% Начальные условия
Y0 = [8; -4];  % y'(0) = 8, y(0) = -4

[x, Y] = ode45(@ode_second_order, X_span, Y0);

Y_analytical = 4 * exp(5.*X_span) - 6 * exp(2.*X_span) - 2;
Y_diff = Y(:,2);

%% РЕШЕНИЕ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ ИТЕРАЦИОННЫМ МЕТОДОМ

h = (b - a) / (Nx-1); % Шаг сетки
x = linspace(a, b, Nx); % Сетка по x
Y_interp = zeros(size(x)); % Начальное приближение для y
Y_interp(1) = 20 * a -4; % Начальное условие при x=0, исходя из того, что y(0) = -4 (если предполагаемое начальное значение)

Ky = 0;

for i = 2:Nx
    Y_interp(i) = ((20*x(i) - 4) + h * Ky) / (1 - h * K(x(i),x(i)));
    
    if( i < Nx)
        Ky = Ky + K(x(i+1),x(i))*Y_interp(i);
    end
end

% Интерполяция значений найденных итерационно
Y_interp = polyval(polyfit(x, Y_interp, 3), x);

% Поиск максимума
abs_K = abs(K(X_span,X_span));
[max_value, max_index] = max(abs_K(:));


%% РЕШЕНИЕ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ С ПОГРЕШНОСТЬЮ ИТЕРАЦИОННЫМ МЕТОДОМ

Y_err = zeros(size(x)); % Начальное приближение для y
Y_err(1) = 20 * a -4; % Начальное условие при x=0, исходя из того, что y(0) = -4 (если предполагаемое начальное значение)

Ky_tilda = 0;

for i = 2:Nx
    Y_err(i) = (20*x(i) - 4 + h * Ky_tilda) / (1 - h * K_tilda(x(i),x(i)));

    if( i < Nx)
        Ky_tilda = Ky_tilda + K_tilda(x(i+1),x(i))*Y_err(i);
    end
end

Y_err = polyval(polyfit(x, Y_err, 3), x);

%% Построение графиков K

resolution = get(0, 'screensize');
indexes = [1, 5, 10];

f1 = figure(1);
f1.Position = [200 200 resolution(3)/2 resolution(4)/2];
for i = 1:length(indexes)
    
    K_vals = K(x, x(indexes(i)));
    
    K_tilda_vals = K_tilda(x, x(indexes(i)));
    
    % Построение графиков
    subplot(3, 1, i);
    hold on;
    plot(x, K_vals, 'b-', 'LineWidth', 2); 
    plot(x, K_tilda_vals, 'r--', 'LineWidth', 2);
    
    % Настройки графика
    title('Сравнение K и ~K', ...% 'Interpreter', 'latex', ...
        'FontName', 'Times New Roman', 'FontSize', 20);
    xlabel('x', 'FontName', 'Times New Roman', 'FontSize', 16);
    ylabel('K(x,t)', 'FontName', 'Times New Roman', 'FontSize', 16);
    legend('K(x, t)', '$\tilde{K}(x, t)$', 'Interpreter', 'latex', 'FontSize', 10);
    grid on;
end

%% Построение графика решений

figure(2)%,"Name",'Решения', 'Position', [200 200 resolution(3)/2 resolution(4)/2]);
hold on;
legend('Location','northwest');

plot(x, Y_diff, '-b', 'DisplayName', 'Y_{diff}(x)','LineWidth',2);
plot(x, Y_analytical, '-r', 'DisplayName', 'Y_{analytical}(x)','LineWidth',2, 'LineStyle','--');
plot(x, Y_interp, '-g', 'DisplayName', 'Y_{interp}(x)','LineWidth',2);
plot(x, Y_err, '-c', 'DisplayName', 'Y_{err}(x)','LineWidth',2,'LineStyle','--');

xlabel('x', 'FontName', 'Times New Roman', 'FontSize', 16);
ylabel('y(x)', 'FontName', 'Times New Roman', 'FontSize', 16);
title('Решения интегрального уравнения','FontName', 'Times New Roman', 'FontSize', 20);
grid on;

discr_1 = sum(abs(Y_diff - Y_interp)) ;
discr_2 = sum(abs(Y_diff - Y_err)) ;

toc