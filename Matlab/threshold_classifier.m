function [label_pred, label_condition] = threshold_classifier(min_pressure)
    label_condition = {};
    label_pred = [];

    threshold = 0.8533;
    epsilon = 1e-3;

    for i = 1:size(min_pressure)
        if min_pressure(i) > threshold + epsilon
            label_condition{i} = "Fault";
            label_pred(i) = 0;
        elseif min_pressure(i) < threshold - epsilon
            label_condition{i} = "Fault";
            label_pred(i) = 0;
        else
            label_condition{i} = "Normal";
            label_pred(i) = 1;
        end
    end

    label_pred = label_pred';
    label_condition = label_condition';
end