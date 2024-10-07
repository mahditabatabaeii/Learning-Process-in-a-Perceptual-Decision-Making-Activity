clc; clear;

% Define the file names
file_names = {'wang.csv', 'phase1.csv', 'phase3.csv'};

% Prepare a container to store accuracy for each file
accuracy = zeros(1, numel(file_names));

% Initialize arrays to store all RT data and total counts
all_data = [];
total_counts = zeros(1, numel(file_names));

% Read all data to find the common x-axis range and calculate total counts for normalization
for i = 1:length(file_names)
    data = readtable(file_names{i});
    all_data = [all_data; data.RT]; % Concatenate all RT data
    total_counts(i) = height(data);
    accuracy(i) = mean(data.status); % Calculate accuracy as mean of status
end

% Common x-axis range
x_min = min(all_data);
x_max = max(all_data);
bin_width = 0.05;
bins = x_min:bin_width:x_max; % Define bin edges

% Create a figure for the histograms
figure;
sgtitle('Normalized Reaction Time Histograms Across Different Phases');

% Plot histograms with adjusted normalization
for i = 1:length(file_names)
    data = readtable(file_names{i});
    
    % Calculate weight for normalization
    weight = ones(height(data), 1) ./ total_counts(i);
    
    % Calculate histogram
    [counts, edges] = histcounts(data.RT, bins, 'Normalization', 'count');
    weighted_counts = counts .* weight(1); % Adjust counts by the weight
    
    subplot(1, 3, i);
    bar(edges(1:end-1), weighted_counts, 'histc');
    title(strrep(file_names{i}, '.csv', '')); % Removing '.csv' from filename for the title
    xlabel('Reaction Time (seconds)');
    ylabel('Scaled Frequency');
    xlim([x_min x_max]);
    grid on;
end

% Display the accuracy table
disp(table(file_names', accuracy', 'VariableNames', {'File', 'Accuracy'}));

% Adjust layout
set(gcf, 'Position', [100, 100, 1400, 500]); % Adjust figure size
