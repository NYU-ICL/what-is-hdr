import pandas as pd 
import numpy as np
from scipy.stats import norm

def jod_to_p_pref(jods):
    sigma_cdf = 1.4826; # The standard deviation for the JOD/JND units (1 JOD = 0.75 p_A_better)
    p_A_better = norm.cdf( jods, 0, sigma_cdf ) * 100
    p_pref = (p_A_better*2-100)/100
    return (p_pref+1)*.5

def model( X, Y, params ):
    JOD = (np.log10(Y) ** params[2]) * (params[0] - params[1] * X ** .5) - params[3]
    return JOD

model_name = 'contentAware' # ["fixed", "contentAware", "hvei26"]
df = pd.read_csv('../data/model_param.csv')
params = df[df["modelName"] == model_name][["k1", "k2", "k3", "k4"]].to_numpy()[0]

contrast_A = 1000 # 1,000:1
peakLuminance_A = 200 # 200 nits
black_level_A = peakLuminance_A / contrast_A # black level
JOD_A = model(black_level_A, peakLuminance_A, params)

contrast_B = 2000 # 2,000:1
peakLuminance_B = 100 # 100 nits
black_level_B = peakLuminance_B / contrast_B # black level
JOD_B = model(black_level_B, peakLuminance_B, params)

pref = jod_to_p_pref(JOD_A - JOD_B)
print('Display A is preferred over B by {:.1f}% of users.'.format(pref * 100))