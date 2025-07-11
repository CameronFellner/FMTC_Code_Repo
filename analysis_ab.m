%% Evaluate MM_Euler over a Grid of (a, beta)
% This script evaluates MM_Euler or MM_Matrix over a grid of a(t) & b(t) pairs
% and plots the mean objective values as surface plots.

% For reproducability
rng(0);

% Simulations
sims = 10000;

% Fixed Variables
beta = 0.05;
theta = 0.02;

% Parameter Ranges
a_values = linspace(0, 0.2, 10);
b_values = linspace(0, 0.2, 10);

% Initialize result matrices
num_a = length(a_values);
num_b = length(b_values);
leader_results = zeros(num_a, num_b);
follower_results = zeros(num_a, num_b);

% Loop through each a(t) & b(t) pair
fprintf('\n--- Running 3D Parameter Sweep ---\n');
for i = 1:num_a
    for j = 1:num_b

        % Time dependant parameters
        a_func = @(t, a0, a1) 0.3;
        b_func = @(t, b0, b1) 0.3;

        % Run simulation
        [~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~, obj_follower, obj_leader] = MM_Matrix(a_func, b_func, beta, theta, a_values(i), b_values(j), sims);

        % Store mean objective values
        leader_results(i, j) = mean(obj_leader);
        follower_results(i, j) = mean(obj_follower);

        % Progress Bar
        progress = (i-1)*num_b + j-1;
        total = num_a * num_b;
        if j == 1 || progress == total
            fprintf('Progress: [%-20s] %d/%d (%.1f%%)\n', repmat('=',1,round(20*progress/total)), progress, total, 100*progress/total);
        end
    end
end

% Meshgrid for surface plotting
[AA, BB] = meshgrid(a_values, b_values);

% Plot: Leader Objective Surface
figure;
surf(AA, BB, leader_results');
xlabel('a', 'FontWeight', 'bold');
ylabel('b', 'FontWeight', 'bold');
zlabel('Objective Value', 'FontWeight', 'bold');
title('Leader Objective Surface', 'FontWeight', 'bold');
colorbar;
grid on;
view(135, 30);
shading interp;

% Plot: Follower Objective Surface
figure;
surf(AA, BB, follower_results');
xlabel('a', 'FontWeight', 'bold');
ylabel('b', 'FontWeight', 'bold');
zlabel('Objective Value', 'FontWeight', 'bold');
title('Follower Objective Surface', 'FontWeight', 'bold');
colorbar;
grid on;
view(135, 30);
shading interp;

% Combined Plot: Leader vs Follower
figure;
hold on;
surf1 = surf(AA, BB, leader_results');
set(surf1, 'FaceColor', 'r', 'FaceAlpha', 0.6, 'EdgeAlpha', 0.3);
surf2 = surf(AA, BB, follower_results');
set(surf2, 'FaceColor', 'b', 'FaceAlpha', 0.6, 'EdgeAlpha', 0.3);
xlabel('a', 'FontWeight', 'bold');
ylabel('b', 'FontWeight', 'bold');
zlabel('Objective Value', 'FontWeight', 'bold');
title('Leader (Red) vs Follower (Blue) Objectives', 'FontWeight', 'bold');
grid on;
view(135, 30);
legend({'Leader', 'Follower'}, 'Location', 'best');
hold off;

% Create contour plot for leader objective function
figure;
contourf(AA, BB, leader_results', 20, 'LineColor', 'none'); % 20 contour levels, no lines
colormap(jet); % Use jet colormap (or try 'parula', 'hot', etc.)
colorbar; % Show color scale
xlabel('a', 'FontWeight', 'bold');
ylabel('b', 'FontWeight', 'bold');
title('Leader Objective Function (Contour Plot)', 'FontWeight', 'bold');
grid on;
hold on;
[C,h] = contour(AA, BB, leader_results', 10, 'k-'); % 10 black contour lines
clabel(C,h,'FontSize',8,'Color','k','LabelSpacing',500);
hold off;

% Create contour plot for leader objective function
figure;
contourf(AA, BB, follower_results', 20, 'LineColor', 'none'); % 20 contour levels, no lines
colormap(jet); % Use jet colormap (or try 'parula', 'hot', etc.)
colorbar; % Show color scale
xlabel('a', 'FontWeight', 'bold');
ylabel('b', 'FontWeight', 'bold');
title('Follower Objective Function (Contour Plot)', 'FontWeight', 'bold');
grid on;
hold on;
[C,h] = contour(AA, BB, follower_results', 10, 'k-'); % 10 black contour lines
clabel(C,h,'FontSize',8,'Color','k','LabelSpacing',500);
hold off;