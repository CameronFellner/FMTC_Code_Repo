%% Evaluate Game Over Time
fprintf('\n--- Running Game---\n');

% Simulation parameters
steps = 1e6;
time_vals = linspace(0,1,steps);
sims = 100000;

% Time dependant parameters
a_func = @(t, a0, a1) 0.1;
b_func = @(t, b0, b1) 0.1;

% Fixed Parameters
beta = 0.05;
theta = 0;
phi = 0.1;
gamma = 0.03;

% Run simulations
[time, Q, Q_tilde, da, db, ta, tb, qmax, qmin, X, X_tilde, pnl, pnl_tilde, obj_follower, obj_leader] = MM_Matrix(a_func, b_func, beta, theta, phi, gamma, sims);

% Fix terminal deltas/tildes for plotting
da(:,end) = da(:,end-1); db(:,end) = db(:,end-1);
ta(:,end) = ta(:,end-1); tb(:,end) = tb(:,end-1);

% Calculate spreads
follower_spread = da + db;
leader_spread = ta + tb;

% Create summary table with spreads
metrics = {
    'Terminal Inventory Q', mean(Q(:,end)), std(Q(:,end)), mean(Q_tilde(:,end)), std(Q_tilde(:,end));
    'Terminal Wealth X', mean(X(:,end)), std(X(:,end)), mean(X_tilde(:,end)), std(X_tilde(:,end));
    'PnL', mean(pnl), std(pnl), mean(pnl_tilde), std(pnl_tilde);
    'Mean Spread', mean(follower_spread(:)), std(follower_spread(:)), mean(leader_spread(:)), std(leader_spread(:));
    'Final Spread', mean(follower_spread(:,end)), std(follower_spread(:,end)), mean(leader_spread(:,end)), std(leader_spread(:,end));
    'Objective Value', mean(obj_follower), std(obj_follower), mean(obj_leader), std(obj_leader)

};

% Display table
fprintf('\n--- Comparative Results ---\n');
disp(array2table(metrics, ...
    'VariableNames', {'Metric', 'Follower_Mean', 'Follower_Std', 'Leader_Mean', 'Leader_Std'}, ...
    'RowNames', {'Q', 'X', 'PnL', 'MeanSpread', 'FinalSpread', 'Objective'}));


% Plot results
plot_time_series_results(time, Q(end,:), Q_tilde(end,:), da(end,:), db(end,:), ta(end,:), tb(end,:), qmax(end,:), qmin(end,:));

%% Create histogram of PnL with vertical line at V (from simulation)
figure;
histogram(pnl, 50, 'FaceColor', [0.2 0.4 0.6], 'EdgeColor', 'none', 'Normalization', 'probability');
line([3.234 3.234], ylim, 'Color', 'r', 'LineWidth', 2, 'LineStyle', '--');
xlabel('PnL');
ylabel('Relative Frequency');hold on;
title('Distribution of PnL');
legend('PnL Distribution', 'V_0 = 3.243');
grid on;
hold off;
