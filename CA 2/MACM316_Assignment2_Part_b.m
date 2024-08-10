% PART (b)

matrix_size = 40000;
iteration_count = 30;
lu_timings = [];

% Loop over different matrix sizes
for size_n = 1000:100:matrix_size
    total_time = 0;
    
    % Computing time for each matrix size
    for k = 1:iteration_count
        % Tridiagonal matrix A_n
        e = ones(size_n, 1);
        A_n = spdiags([e -2*e e], -1:1, size_n, size_n);
        
        % Computing time for LU factorization
        tic;
        [L, U, P] = lu(A_n);
        
        total_time = total_time + toc;
    end
    
    % Average time for the current matrix size
    avg_time = total_time / iteration_count;
    lu_timings = [lu_timings; avg_time];
end

% Matrix sizes for plotting
sizes = 1000:100:matrix_size;

% Plotting the first graph (log-log scale)
figure;
plot(log(sizes), log(lu_timings), 'o-');
grid on;
xlabel('Log(Matrix Size)');
ylabel('Log(Average Computing Time)');
title('Log-Log Plot: Computing Time vs Matrix Size (LU Factorization)');

% Plotting the second graph (linear scale)
figure;
plot(sizes, lu_timings, 'o-');
grid on;
xlabel('Matrix Size');
ylabel('Average Computing Time');
title('Linear Plot: Computing Time vs Matrix Size (LU Factorization)');

% Slope for the log-log graph
slope = polyfit(log(sizes), log(lu_timings), 1);
disp(['Slope for the log-log graph (b): ', num2str(slope(1))]);