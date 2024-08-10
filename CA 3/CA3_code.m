initial_approximation = 2;
allowed_error_tolerance = 1e-6; 
max_iterations = 75; 
actual_value = 11^(1/6);

% Arrays to store convergence, iterations, and approximations
convergence_results = zeros(3, 1);
iteration_counts = zeros(3, 1);
approximation_values = zeros(3, 1);

% Define different methods for computation
method1 = @(val) val - ((val^6 - 11) / (6 * val^5));
method2 = @(val) val - ((val^6 - 11) / 20);
method3 = @(val) val - ((val^6 - 11) / 24);

% Method 1, 2, 3 computation
[approximation_values(1), iteration_counts(1), convergence_results(1), errors1] = computeConvergence(method1, initial_approximation, actual_value, allowed_error_tolerance, max_iterations);
[approximation_values(2), iteration_counts(2), convergence_results(2), errors2] = computeConvergence(method2, initial_approximation, actual_value, allowed_error_tolerance, max_iterations);
[approximation_values(3), iteration_counts(3), convergence_results(3), errors3] = computeConvergence(method3, initial_approximation, actual_value, allowed_error_tolerance, max_iterations);

% Plotting absolute errors against the number of iterations
figure;
hold on;
plot(1:iteration_counts(1), errors1, 'y.-', 'LineWidth', 2);
plot(1:iteration_counts(2), errors2, 'Color', [1, 0.75, 0.8], 'LineWidth', 2);
plot(1:iteration_counts(3), errors3, 'Color', [0.6, 0.4, 0.2], 'LineWidth', 2);
xlim([1,35]);
ylim([0,1]);
title('Absolute Error vs. Iterations','FontSize', 18);
xlabel('Iterations', 'FontSize', 15);
ylabel('Absolute Error', 'FontSize', 15);
grid on;

legend('Method 1', 'Method 2', 'Method 3');

fprintf('Method 1: Approximation = %.8f, Iterations = %d, Converged = %d\n', approximation_values(1), iteration_counts(1), convergence_results(1));
fprintf('Method 2: Approximation = %.8f, Iterations = %d, Converged = %d\n', approximation_values(2), iteration_counts(2), convergence_results(2));
fprintf('Method 3: Approximation = %.8f, Iterations = %d, Converged = %d\n', approximation_values(3), iteration_counts(3), convergence_results(3));

% Error plot for method1
error_values_n = errors1(1:end-1); % |p_n - p|
error_values_n_1 = errors1(2:end); % |p_n+1 - p|

% Plotting error plot for method1
figure;
plot(log(error_values_n), log(error_values_n_1), 'y.-', 'LineWidth',2);
title('Method1: log|p_{n+1} - p| vs. log|p_n - p|', 'FontSize', 18);
xlabel('log|p_n - p|', 'FontSize', 15);
ylabel('log|p_{n+1} - p|', 'FontSize', 15);
grid on;

polyfit_values = polyfit(log(error_values_n), log(error_values_n_1), 1);
fprintf('⍺: %d\n', polyfit_values(1));
fprintf('ƛ: %d\n', polyfit_values(2));

% Error plot for method3
error_values_n = errors3(1:end-1); % |p_n - p|
error_values_n_1 = errors3(2:end); % |p_n+1 - p|

% Plotting error plot for method3
figure;
plot(log(error_values_n), log(error_values_n_1), 'Color', [1, 0.75, 0.8], 'LineWidth',2);
title('Method3: log|p_{n+1} - p| vs. log|p_n - p|', 'FontSize', 18);
xlabel('log|p_n - p|', 'FontSize', 15);
ylabel('log|p_{n+1} - p|', 'FontSize', 15);
grid on;

polyfit_values = polyfit(log(error_values_n), log(error_values_n_1), 1);
fprintf('⍺: %d\n', polyfit_values(1));
fprintf('ƛ: %d\n', polyfit_values(2));

function [approximation, iterations, converged, errors] = computeConvergence(method, initial_val, actual_val, tolerance, max_iterations)
    current_val = initial_val;
    iterations = 0;
    errors = zeros(1, max_iterations);

    while iterations < max_iterations
        next_val = method(current_val);
        iterations = iterations + 1;
        
        % Compute absolute error |p_n - p|
        errors(iterations) = abs(next_val - actual_val);

        if abs(next_val - actual_val) < tolerance
            approximation = next_val;
            converged = 1;
            errors = errors(1:iterations); % Trim the errors array to the actual number of iterations
            return;
        end

        current_val = next_val;
    end

    % If the method doesn't converge after a certain max_iterations
    approximation = next_val;
    converged = 0;
end