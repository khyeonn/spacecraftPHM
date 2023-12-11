clear
close all
clc

train_dir = dir('C:\Users\maxki\Documents\School\ENME 691\Final Project\Train\data\*.csv');
test_dir = dir('C:\Users\maxki\Documents\School\ENME 691\Final Project\Test\data\*.csv');

train_label = readtable('C:\Users\maxki\Documents\School\ENME 691\Final Project\Train\labels.xlsx');
test_label = readtable('C:\Users\maxki\Documents\School\ENME 691\Final Project\Test\labels_spacecraft.xlsx');
answer = readtable('C:\Users\maxki\Documents\School\ENME 691\Final Project\Test\answer.csv');

% rename columns for clarity
train_label.Properties.VariableNames(1) = "Case";
train_label.Properties.VariableNames(2) = "Spacecraft";
train_label.Properties.VariableNames(3) = "Condition";

train_size = size(train_dir);
test_size = size(test_dir);

%% read data
train_data = cell(train_size);
test_data =cell(test_size);

for i = 1:train_size
    train_data{i} = readtable(fullfile(train_dir(i).folder, train_dir(i).name));
end

for i = 1:test_size
    test_data{i} = readtable(fullfile(test_dir(i).folder, test_dir(i).name));
end

%% create labels
train_label_true = nan(train_size);
test_label_true = nan(test_size);

for i = 1:train_size
    if train_label.Condition(i, 1) == "Normal"
        train_label_true(i) = 1;
    else
        train_label_true(i) = 0;
    end
end

for i = 1:test_size
    if answer.TestCondition(i, 1) == "Normal"
        test_label_true(i) = 1;
    else
        test_label_true(i) = 0;
    end
end

%% get pressure features
close all
min_pressure_training = get_min_pressure(train_data);

figure(Position=[933 575 706 545]);
plot(1:177, min_pressure_training)
title('Sum of Minimum Pressure From All Sensors')
subtitle('Training Data')
ylabel('MPa')
xlabel('Sample')

min_pressure_testing = get_min_pressure(test_data);

figure(Position=[933 575 706 545]);
plot(1:46, min_pressure_testing)
title('Sum of Minimum Pressure From All Sensors')
subtitle('Testing Data')
ylabel('MPa')
xlabel('Sample')



%% threshold classifier for training 
[train_label_pred, train_label_condition] = threshold_classifier(min_pressure_training);

figure(Position=[933 575 706 545]);

scatter(1:177, train_label_true, 30, 'blue');
hold on
scatter(1:177, train_label_pred, 10, 'red')

ylabel('CV')
xlabel('Sample')
title('Threshold Based Separation')
subtitle('Training Data')
legend('True Condition', 'Predicted Condition', 'Location', 'best')
grid on
ylim([-0.05, 1.05])

% confusion matrix
figure(Position=[933 575 706 545]);

cmat = confusionmat(train_label_true, train_label_pred);
cm = confusionchart(cmat);
cm.Title = 'Threshold Classifer Model';

%% logistic regression classifier for training

b = glmfit(min_pressure_training, train_label_true, 'binomial', 'Link', 'logit');
yfit = glmval(b, min_pressure_training, 'logit');

for i = 1:train_size
    if yfit(i) > 0.95
        train_label_pred(i) = 1;
    else
        train_label_pred(i) = 0;
    end
end

figure(Position=[933 575 706 545]);
scatter(1:177, train_label_true, 30, 'blue');
hold on
scatter(1:177, train_label_pred, 10, 'red')

ylabel('CV')
xlabel('Sample')
title('Logistic Regression Based Separation')
subtitle('Training Data')
legend('True Condition', 'Predicted Condition', 'Location', 'best')
grid on
ylim([-0.05, 1.05])

% confusion matrix
figure(Position=[933 575 706 545]);

cmat = confusionmat(train_label_true, train_label_pred);
cm = confusionchart(cmat);
cm.Title = 'Logistic Regression Model';

%% testing models
[test_label_pred, test_label_condition] = threshold_classifier(min_pressure_testing);

figure(Position=[933 575 706 545]);

scatter(1:46, test_label_true, 30, 'blue');
hold on
scatter(1:46, test_label_pred, 10, 'red')

ylabel('CV')
xlabel('Sample')
title('Threshold Based Separation')
subtitle('Testing Data')
legend('True Condition', 'Predicted Condition', 'Location', 'best')
grid on
ylim([-0.05, 1.05])

% confusion matrix
figure(Position=[933 575 706 545]);

cmat = confusionmat(test_label_true, test_label_pred);
cm = confusionchart(cmat);
cm.Title = 'Threshold Classifer Model';

%% 
yfit = glmval(b, min_pressure_testing, 'logit');

for i = 1:test_size
    if yfit(i) > 0.95
        test_label_pred(i) = 1;
    else
        test_label_pred(i) = 0;
    end
end

figure(Position=[933 575 706 545]);
scatter(1:46, test_label_true, 30, 'blue');
hold on
scatter(1:46, test_label_pred, 10, 'red')

ylabel('CV')
xlabel('Sample')
title('Logistic Regression Based Separation')
subtitle('Testing Data')
legend('True Condition', 'Predicted Condition', 'Location', 'best')
grid on
ylim([-0.05, 1.05])

% confusion matrix
figure(Position=[933 575 706 545]);

cmat = confusionmat(test_label_true, test_label_pred);
cm = confusionchart(cmat);
cm.Title = 'Logistic Regression Model';