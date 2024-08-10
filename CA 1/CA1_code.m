% Part (a)

figure;
f = @(h) (h - sin(h)) ./ h.^3;
h = 1:-0.0001:0.0001;
plot(h, f(h));
title('Plot of f(h) vs h');
xlabel('h');
ylabel('f(h)');
grid on;

limit_estimate = f(0.0001);
disp(['Limit of F(h) as h approaches zero: ', num2str(limit_estimate)]);

% Part (b)

L = 1/6;

abs_diff = abs(f(h) - L);

figure;
plot(log(h), log(abs_diff));
xlim([-7,0]);
title('Plot of log( |f(h) - L| ) vs log(h)');
xlabel('log(h)');
ylabel('log( |f(h) - L| )');
grid on;

p = polyfit(log(h), log(abs_diff), 1);
disp(['The value of p = ', num2str(p(1))]);