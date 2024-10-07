% Load phase1 data
phase1_RT = phase1.RT;
phase1_status = phase1.status;
mean_accuracy_phase1 = mean(phase1_status == 1); % Assuming status '1' means correct
mean_RT_phase1 = mean(phase1_RT);


% Assuming opt_params = [u0_opt, thr_opt] from your optimization results
% Let's assume you have those values for the sake of example
u0_opt = 30.0043;  % example value
thr_opt = 0.4999; % example value

% Run the model with optimized parameters
results = WANG_E([thr_opt, u0_opt]);
model_RT = results(:, 5);
model_status = results(:, 6);
mean_accuracy_model = mean(model_status);
mean_RT_model = mean(model_RT);

fprintf('Mean Accuracy for Phase 1: %.4f\n', mean_accuracy_phase1);
fprintf('Mean Accuracy for Model with Optimized Parameters: %.4f\n', mean_accuracy_model);

fprintf('Mean RT for Phase 1: %.4f\n', mean_RT_phase1);
fprintf('Mean RT for Model with Optimized Parameters: %.4f\n', mean_RT_model);

figure;
subplot(1,2,1); % Phase 1 histogram
histogram(phase1_RT, 'Normalization', 'probability', 'BinWidth', 0.05);
title('Histogram of RT for Phase 1');
xlabel('Reaction Time (seconds)');
ylabel('Probability Density');

subplot(1,2,2); % Model histogram
histogram(model_RT, 'Normalization', 'probability', 'BinWidth', 0.05);
title('Histogram of RT for Model with Optimized Params');
xlabel('Reaction Time (seconds)');
ylabel('Probability Density');

sgtitle('Comparison of Reaction Times');
