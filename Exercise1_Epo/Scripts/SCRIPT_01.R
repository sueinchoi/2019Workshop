rm(list=ls())
library(IQRtools)
IQRinitCompliance("SCRIPT_01.R")
# Needed if Microsoft Open R is used:
tryCatch({detach('package:RevoUtils', unload=TRUE)}, error=function(x){})
tryCatch({detach('package:RevoUtilsMath', unload=TRUE)}, error=function(x){})






# -------------------------------------------------------------------------#
# Explore model with different binding affinities ----
# -------------------------------------------------------------------------#

# Problem:
# New experimental data will be provided that contains Epo measurements
# for a different Epo preparation. Based on the current fitted model,
# how would Epo time courses look like for higher/lower Epo binding
# affinity?
#
# Instructions:
# - Simulate and plot the "model_nolog.txt" for the estimated parameter
#   values, changing "kon"
#                              -------- or ---------
#
# - Define an IQRsysModel with conditions "Epo_Low", "Epo_Control",
#   and "Epo_High" and set different "kon" values for each condition
#








# -------------------------------------------------------------------------#
# Load data into the model and plot only data ----
# Do you expect higher or lower binding affinity for the new preparation?
# -------------------------------------------------------------------------#

# Problem:
# The new experimental data has arrived ("../Data/dataRAW_TwoPreps.csv").
# Can you guess the binding affinity from the looks of the data?
#
# Instructions:
# - Import the new raw data as IQRsysData object and write to
#   file "../Data/dataSYS_TwoPreps.csv"
# - Create an IQRsysModel including the new data and
#   condition-specific "kon"
# - Plot only the data and try to guess the correct "kon" value
#   for the new experiment
# - Plot prediction and data for your guess
#








# -------------------------------------------------------------------------#
# Estimate parameters for both conditions jointly ----
# -------------------------------------------------------------------------#

# Problem:
# Estimate all model parameters (except for "initEpo") and condition-
# specific "kon" values from the new data set. Choose a relative error
# model for OUTPUT1 and an absolute-proportional error model for OUTPUT2
# and OUTPUT3.
#
# Instructions:
# - Create an IQRsysModel with the appropriate modelSpec and error model
# - Run 36 fits and compute the profile likelihood
# - Have a look at the goodness of fit plots
# - Compare the profile likelihood between the old data (one condition)
#   and new data (two conditions) side-by-side.
#










# -------------------------------------------------------------------------#
# Comparison between local optima ----
# -------------------------------------------------------------------------#

# Problem:
# Parameter estimation reveals the existence of local optima. What is the
# difference between the best and second best optimum?
#
# Instructions:
# - Identify the parameters with the largest differences between first
#   and second optimum based on plotPars_IQRsysModel()
# - Compute the profile likelihood for these parameters for both optima
#   (use switchOpt_IQRsysModel()) and see what happens when you use
#   plotProfile_IQRsysModel()
# - Create plots with plot_IQRsysModel() for both local optima
#





