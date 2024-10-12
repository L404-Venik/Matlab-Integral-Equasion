clc
clear
close all

tic

% ПЕРЕМЕННЫЕ
a = 0;
b = 1;
Nx = 11;
X_span = linspace(a,b,Nx);


% РЕШЕНИЕ СИСТЕМЫ ОДУ, ПОЛУЧЕННОЙ ИЗ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ

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

figure;
hold on;
legend('Location','northwest');
plot(x, Y_diff, '-b', 'DisplayName', 'Y_{diff}(x)','LineWidth',2);
plot(x, Y_analytical, '-r', 'DisplayName', 'Y_{analytical}(x)','LineWidth',2, 'LineStyle','--');
%plot(x, Y(:,2), '-b', 'DisplayName', 'z1(x)');
%plot(x, Y(:,3), '-g', 'DisplayName', 'z2(x)');
%title('Решение системы ОДУ');


% РЕШЕНИЕ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ ИТЕРАЦИОННЫМ МЕТОДОМ

h = (b - a) / Nx; % Шаг сетки
x = linspace(a, b, Nx); % Сетка по x
Y_interp = zeros(size(x)); % Начальное приближение для y
Y_interp(1) = 20 * a -4; % Начальное условие при x=0, исходя из того, что y(0) = -4 (если предполагаемое начальное значение)

Ky = 0;

for i = 2:Nx
    Y_interp(i) = (20*x(i) - 4 + h * Ky) / (1 - h * K(x(i),x(i)));

    if( i < Nx)
        Ky = Ky + K(x(i+1),x(i))*Y_interp(i);
    end
end

% Построение графика
plot(x, Y_interp, '-g', 'DisplayName', 'Y_{interp}(x)','LineWidth',2);
xlabel('x');
ylabel('y(x)');
%title('Решение интегрального уравнения Вольтерра');
grid on;


% Поиск максимума
abs_K = abs(K(X_span,X_span));
[max_value, max_index] = max(abs_K(:));


% РЕШЕНИЕ ИНТЕГРАЛЬНОГО УРАВНЕНИЯ С ПОГРЕШНОСТЬЮ ИТЕРАЦИОННЫМ МЕТОДОМ

Y_err = zeros(size(x)); % Начальное приближение для y
Y_err(1) = 20 * a -4; % Начальное условие при x=0, исходя из того, что y(0) = -4 (если предполагаемое начальное значение)

Ky_tilda = 0;

for i = 2:Nx
    Y_err(i) = (20*x(i) - 4 + h * Ky_tilda) / (1 - h * K_tilda(x(i),x(i)));

    if( i < Nx)
        Ky_tilda = Ky_tilda + K_tilda(x(i+1),x(i))*Y_err(i);
    end
end

plot(x, Y_err, '-c', 'DisplayName', 'Y_{err}(x)','LineWidth',2);
% discr_1 = sum(abs(Y_diff - Y_interp)) ;
% discr_2 = sum(abs(Y_diff - Y_err)) ;

toc