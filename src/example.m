% specify display parameters
peakLuminance = 100; % 100 nits
contrast = 1000; % 1,000:1
blackLevel = contrast / peakLuminance; % black level

modelName = 'contentAware';
params = loadModelParams( modelName );

jod = model(blackLevel, peakLuminance, params);

display(jod);
