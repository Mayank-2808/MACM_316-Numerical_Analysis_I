% Part (a)

matrix_size = 4000;
iteration_count = 25;
time_array = [];

% Loop over different matrix sizes
for size_n = 1000:100:matrix_size
    total_time = 0;
    
    % Time for each matrix size
    for k = 1:iteration_count
        
        % Tridiagonal matrix A_n
        e = ones(size_n, 1);
        A_n = spdiags([e -2*e e], -1:1, size_n, size_n);
        
        % Computing time for matrix inversion
        tic;
        A_n_inv = inv(A_n);
        
        total_time = total_time + toc;
    end
    
    % Average time for the current matrix size
    avg_time = total_time / iteration_count;
    time_array = [time_array; avg_time];
end

% Matrix sizes for plotting
sizes = 1000:100:matrix_size;

% Plotting the first graph (log-log scale)
figure;
plot(log(sizes), log(time_array), 'o-', 'LineWidth', 2);
grid on;
xlabel('Log(Matrix Size)');
ylabel('Log(Average Computing Time)');
title('Log-Log Plot: Computing Time vs Matrix Size');

% Plotting the second graph (linear scale)
figure;
plot(sizes, time_array, 'o-', 'LineWidth', 2);
grid on;
xlabel('Matrix Size');
ylabel('Average Computing Time');
title('Linear Plot: Computing Time vs Matrix Size');

% Slope for the log-log graph
slope = polyfit(log(sizes), log(time_array), 1);
disp(['Slope for the log-log graph (a): ', num2str(slope(1))]);