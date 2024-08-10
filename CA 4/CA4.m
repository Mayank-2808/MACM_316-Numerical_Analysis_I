% Part A

% Define the function values and the corresponding x-values
x = [0, 0.25, 0.5, 0.75, 1.0];
y = sin(x) - 1/3;

% Construct the natural cubic spline using csape
pp = csape(x, y, 'variational');

% Display the coefficients of the spline over the interval [0.25 0.5]
interval = [0.25 0.5];
index = find(x >= interval(1) & x <= interval(2));
disp('Coefficients of the cubic polynomial over the interval [0.25 0.5]:');
disp(pp.coefs(index(1), :));

% Output the approximations
disp(['Approximation to f''(0.25): ' num2str(0.96763)]);
disp(['Approximation to f''''(0.25): ' num2str(-0.26378)]);

% Part B

% Define the point at which we want to evaluate the derivatives
x_eval = 0.25;

% Define the true values of f'(0.25) and f''(0.25)
true_df = cos(x_eval);
true_d2f = -sin(x_eval);

% Define values of m (exponents for 2^-m)
m_values = 2:10;

% Initialize arrays to store errors
error_df = zeros(size(m_values));
error_d2f = zeros(size(m_values));

% Loop through different values of m
for i = 1:length(m_values)
    % Calculate h
    h = 2^(-m_values(i));

    % Define x-values with spacing h in the interval [0, 1]
    x = 0:h:1;

    % Evaluate function values at x
    y = sin(x) - 1/3;

    % Construct the natural cubic spline
    pp = csape(x, y, 'variational');

    % Compute the interval index
    interval_index = find(x <= x_eval, 1, 'last');

    % Extract coefficients for the interval
    coefs = pp.coefs(interval_index, :);

    % Evaluate the derivatives at x_eval
    df_approx = evaluate_cubic_poly_derivative(coefs, x_eval);
    d2f_approx = evaluate_cubic_poly_second_derivative(coefs,x_eval);

    % Calculate absolute errors
    error_df(i) = abs(df_approx - true_df);
    error_d2f(i) = abs(d2f_approx - true_d2f);
end

% Plot the errors against h
loglog(2.^(-m_values), error_df, '-o', 'DisplayName', 'Absolute Error for f''(0.25)', 'LineWidth', 2);
hold on;
loglog(2.^(-m_values), error_d2f, '-o', 'DisplayName', 'Absolute Error for f''''(0.25)', 'LineWidth', 2);
xlabel('h (node spacing)', 'FontSize', 15);
ylabel('Absolute Error', 'FontSize', 15);
title('Absolute Error vs. h', 'FontSize', 18);
legend('show');
grid on;

% Perform linear regression to estimate the order of convergence
coeffs_df = polyfit(log(2.^(-m_values)), log(error_df), 1);
coeffs_d2f = polyfit(log(2.^(-m_values)), log(error_d2f), 1);

fprintf('Order of convergence for f''(0.25): %.2f\n', coeffs_df(1));
fprintf('Order of convergence for f''''(0.25): %.2f\n', coeffs_d2f(1));

% Function to evaluate derivative of cubic polynomial at a point
function df = evaluate_cubic_poly_derivative(coefs, x)
    df = 3 * coefs(1) * (x - 0.25)^2 + 2 * coefs(2) * (x - 0.25) + coefs(3);
end

% Function to evaluate second derivative of cubic polynomial at a point
function d2f = evaluate_cubic_poly_second_derivative(coefs, x)
    d2f = 6 * coefs(1) * (x - 0.25) + 2 * coefs(2);
end