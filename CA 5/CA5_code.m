%% Part A: Composite Simpson%s Rule

f = @(x) sin(x) - 1/3;
a = 0;
b = 1;
x = [0, 1/4, 1/2, 3/4, 1];
h = (b - a) / (length(x) - 1);

% Compute exact solution
exact_solution = integral(f, a, b);

fprintf('The exact solution is %f\n', exact_solution);

% Composite Simpson’s Rule
approximation = (h/3) * (f(x(1)) + 4*f(x(2)) + 2*f(x(3)) + 4*f(x(4)) + f(x(5)));

fprintf('The approximation is %f\n', approximation);

% Absolute error
absolute_error = abs(exact_solution - approximation);

fprintf('The absolute error is %f\n', absolute_error);

%% Part B: Composite Simpson%s Rule with varying node spacings

m_values = 2:5;
h_values = 2.^(-m_values);
errors = zeros(size(h_values));

for i = 1:length(h_values)
    h = h_values(i);
    x = linspace(a, b, 1/h + 1);
    approximation = composite_simpson_rule(f, x);
    errors(i) = abs(exact_solution - approximation);
end

% Plot error vs 
figure;
loglog(h_values, errors, '-o', 'LineWidth', 2);
grid on;
xlabel('h');
ylabel('Absolute Error');
title('Absolute Error vs h');

% Fit a line to the log-log plot using polyfit
p_coefficients = polyfit(log(h_values), log(errors), 1);
slope = p_coefficients(1);
p = slope;

% Print slope (p)
fprintf('The slope of the log-log plot(b) is approximately: %.4f\n', slope);
fprintf('Therefore, The error in the approximation(b) is O(h^%.2f)\n', p);

%% Part C: Natural cubic spline approximation

% Initialize vector to store absolute errors
absolute_errors = [];
h_values = [];

% Iterate over different values of m
for m = 2:5
    % Calculate the number of intervals (n)
    n = 2^m; % Number of intervals
    
    % Calculate the step size (h)
    h = (b - a) / n;
    h_values = [h_values, h];
    
    % Construct natural cubic spline
    x_interval = linspace(a, b, n+1);
    y = f(x_interval);

    % Construct the natural cubic spline
    pp = csape(x_interval, y, 'variational');

    % computing integral value
    integral_approximation = 0;
    for i = 1:n
        % defining the cubic function
        f_cubic = @(x) pp.coefs(i, 1)*(x-x_interval(i)).^3 + pp.coefs(i,2)*(x-x_interval(i)).^2 + pp.coefs(i, 3)*(x-x_interval(i)) + pp.coefs(i,4);
        
        % integral approximation
        approximation = integral(f_cubic, x_interval(i), x_interval(i+1));
        integral_approximation = integral_approximation + approximation;
    end
    
    % Exact solution
    exact_solution = integral(f, a, b);
    
    % Calculate absolute error
    absolute_error = abs(exact_solution - integral_approximation);
    
    % Store the absolute error
    absolute_errors = [absolute_errors, absolute_error];
end

% Plot absolute error vs h
figure;
loglog(h_values, absolute_errors, '-o', 'LineWidth', 2);
grid on;
xlabel('h');
ylabel('Absolute Error');
title('Absolute Error vs h');

% Fit a linear curve to the log-log plot
p_coefficients = polyfit(log(h_values), log(absolute_errors), 1);
p = p_coefficients(1);
fprintf('The slope of the log-log plot(c) is approximately: %.4f\n', p)
fprintf('The error in the approximation(c) is O(h^%.2f)\n', p);

%% Defining composite_simpson_rule function
function approximation = composite_simpson_rule(f, x)
    n = length(x) - 1;
    h = (x(end) - x(1)) / n;
    approximation = f(x(1)) + f(x(end));
    for i = 1:n-1
        if mod(i, 2) == 0
            approximation = approximation + 2 * f(x(i+1));
        else
            approximation = approximation + 4 * f(x(i+1));
        end
    end
    approximation = (h / 3) * approximation;
end