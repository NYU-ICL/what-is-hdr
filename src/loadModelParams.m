function data = loadModelParams( modelName )
    % load model parameters
    T = readtable('../data/model_param.csv');
    data = T(strcmp(T.modelName, modelName), :);
end