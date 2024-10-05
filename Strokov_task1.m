clc
clear
close all

% ПЕРЕМЕННЫЕ
a = 0;
b = 1;
Nx = 100;
X_span = linspace(a,b,Nx);


% РЕШЕНИЕ СИСТЕМЫ ОДУ, ПОЛУЧЕННОЙ ИЗ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ

function dYdx = ode_system(x, Y)
    % Y(1) = y(x), Y(2) = z1(x), Y(3) = z2(x)
    
    y = Y(1);
    z1 = Y(2);
    z2 = Y(3);
    
    % Правые части системы
    dy_dx = 2*z1 + z2 + 20*x - 4;  % y'(x)
    dz1_dx = y + z1;               % z1'(x)
    dz2_dx = y + 3*z2;             % z2'(x)
    
    % Вектор производных
    dYdx = [dy_dx; dz1_dx; dz2_dx];
end

% Начальные условия
Y0 = [-4; 0; 0];  % y(0) = -4, z1(0) = 0, z2(0) = 0

[x, Y] = ode45(@ode_system, X_span, Y0);

Y_diff = 2*Y(:,2) + Y(:,3) + 20*x - 4;

figure;
plot(x, Y_diff, '-r', 'DisplayName', 'y(x)');
hold on;
plot(x, Y(:,2), '-b', 'DisplayName', 'z1(x)');
plot(x, Y(:,3), '-g', 'DisplayName', 'z2(x)');
xlabel('x');
ylabel('Значения функций');
title('Решение системы ОДУ');
legend show;
grid on;


% РЕШЕНИЕ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ ИТЕРАЦИОННЫМ МЕТОДОМ

h = (b - a) / Nx; % Шаг сетки
x = linspace(a, b, Nx+1); % Сетка по x
Y_interp = zeros(size(x)); % Начальное приближение для y
Y_interp(1) = -4; % Начальное условие при x=0, исходя из того, что y(0) = -4 (если предполагаемое начальное значение)

% Итерационный метод решения
tol = 1e-6; % Точность
maxIter = 100; % Максимальное число итераций

for iter = 1:maxIter
    y_old = Y_interp;
    for i = 2:Nx+1
        sum_integral = 0;
        for j = 1:i-1
            sum_integral = sum_integral + K(x(i),x(j)) * Y_interp(j);
        end
        integral_value = h * sum_integral;
        Y_interp(i) = integral_value + 20*x(i) - 4;
    end
    % Условие выхода
    if norm(Y_interp - y_old, inf) < tol
        iter;
        break;
    end
end

% Построение графика
plot(x, Y_interp, 'LineWidth', 2);
xlabel('x');
ylabel('y(x)');
title('Решение интегрального уравнения Вольтерра');
grid on;

% Y_err = ;
% discr_1 = sum(abs(Y_diff - Y_interp)) ;
% discr_2 = sum(abs(Y_diff - Y_err)) ;