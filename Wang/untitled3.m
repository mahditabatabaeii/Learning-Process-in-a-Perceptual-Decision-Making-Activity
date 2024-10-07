% Load phase1 data
phase1 = readtable('phase3.csv');
phase1_RT = phase1.RT;
phase1_status = phase1.status;

mean_RT_phase1 = mean(phase1_RT);
mean_accuracy_phase1 = mean(phase1_status);

% Histogram data for RT from phase1
[N_phase1, edges_phase1] = histcounts(phase1_RT, 'Normalization', 'pdf');

% Initial parameter guesses
initial_params = [0.5, 30];  % Note: Format as [thr, u0]

% Lower and upper bounds for u_0 and thr
lb = [0.3, 15];  % Lower bounds for thr and u_0
ub = [0.7, 45];  % Upper bounds for thr and u_0

% Run optimization using fmincon
options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
[opt_params, fval] = fmincon(@(params) objectiveFunction(params, mean_accuracy_phase1, N_phase1, edges_phase1), initial_params, [], [], [], [], lb, ub, [], options);

disp('Optimized parameters:');
disp(opt_params);
disp('Objective function value:');
disp(fval);

% Calculate model accuracy with optimized parameters
results = WANG_E(opt_params);
model_RT = results(:, 5);
model_status = results(:, 6);
mean_accuracy_model = mean(model_status);

fprintf('Mean Accuracy for Phase 1: %.4f\n', mean_accuracy_phase1);
fprintf('Mean Accuracy for Model with Optimized Parameters: %.4f\n', mean_accuracy_model);

% Define the objective function outside of any script or main function to ensure scope visibility
function cost = objectiveFunction(params, mean_accuracy_phase1, N_phase1, edges_phase1)
    % Run the model with new parameters
    results = WANG_E(params);
    model_RT = results(:, 5);
    model_status = results(:, 6);
    mean_accuracy_model = mean(model_status);

    % Calculate accuracy difference
    accuracy_diff = (mean_accuracy_phase1 - mean_accuracy_model)^2;

    % Calculate histogram differences
    [N_model, ~] = histcounts(model_RT, edges_phase1, 'Normalization', 'pdf');
    
    % Calculate the cost as sum of squared differences in accuracy and histogram bins
    cost = 100*accuracy_diff + sum((N_phase1 - N_model).^2);
end

