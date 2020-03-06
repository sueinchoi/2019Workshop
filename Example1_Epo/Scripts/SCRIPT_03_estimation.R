library(IQRtools)
IQRinitCompliance("SCRIPT_03_estimation.R")
# Needed if Microsoft Open R is used:
tryCatch({detach('package:RevoUtils', unload=TRUE)}, error=function(x){})
tryCatch({detach('package:RevoUtilsMath', unload=TRUE)}, error=function(x){})

# -------------------------------------------------------------------------#
# Use IQRsysProject() and run_IQRsysProject() ----
# to create and run estimation projects
# -------------------------------------------------------------------------#

# Load the model
sysobj <- IQRsysModel(
  model = "Resources/model.txt",
  data = list(datafile = "../Data/dataSYS.csv"),
  modelSpec = list(
    POPvalues0 = c(
      initEpo     = 1350,
      initEpoRrel = 0.01,
      kde         = 0.01,
      kdi         = 0.01,
      ke          = 0.01,
      kex         = 0.01,
      koff        = 0.01,
      kon         = 0.01,
      kt          = 1
    ),
    errorModel = list(
      OUTPUT1 = c("abs", 0.1),
      OUTPUT2 = c("abs", 0.1),
      OUTPUT3 = c("abs", 0.1)
    )
  )
)

# Check if set-up looks as expected
getPars_IQRsysModel(sysobj)

# Create estimation object and project
est <- as_IQRsysEst(sysobj)

# Create sys project and prepare to run a single estimation
proj <- IQRsysProject(est, "../Models/RUN1", opt.nfits = 1)

# Run sys project
optsys <- run_IQRsysProject(proj)


# -------------------------------------------------------------------------#
# run_IQRsysProject() returns an optimized IQRsysModel ----
# -------------------------------------------------------------------------#

# Inspect the estimated parameters
getPars_IQRsysModel(optsys)

# Inspect data and optimized prediction for estimated parameters
optsys <- sim_IQRsysModel(optsys, simtime = 1:300)

# Plot results
plot_IQRsysModel(optsys)



# -------------------------------------------------------------------------#
# Create multi-start project with 36 parameter fits from randomly chosen initial
# guesses. The original initial guess is always part of these multiple guesses
# as_IQRsysProject(., opt.nfits, opt.sd) ----
# -------------------------------------------------------------------------#


proj <- IQRsysProject(est, "../Models/RUN2",
                      opt.nfits = 36,
                      opt.sd = 2)

optsys <- run_IQRsysProject(proj, ncores = 8)


# -------------------------------------------------------------------------#
# plotWaterfall_IQRsysModel() shows sorted objective values of all fits ----
# -------------------------------------------------------------------------#

plotWaterfall_IQRsysModel(optsys)


# -------------------------------------------------------------------------#
# plotPars_IQRsysModel(optsys) shows parameter estimates for all fits ----
# -------------------------------------------------------------------------#

plotPars_IQRsysModel(optsys)


# -------------------------------------------------------------------------#
# plotPred_IQRsysModel(optsys) shows model trajectories ----
# for all (distinct) fits
# -------------------------------------------------------------------------#

plotPred_IQRsysModel(optsys)


# -------------------------------------------------------------------------#
# Other diagnostic plots:
# plotWRES_IQRsysModel(optsys) and plotDVPRED_IQRsysModel(optsys) ----
# -------------------------------------------------------------------------#

plotWRES_IQRsysModel(optsys, OUTPUT = 1)

plotDVPRED_IQRsysModel(optsys, OUTPUT = 1)


# -------------------------------------------------------------------------#
# switchOpt_IQRsysModel() lets you take a close look at local optima ----
# -------------------------------------------------------------------------#

# Produce waterfall plot
plotWaterfall_IQRsysModel(optsys)

# Switch to another local optimum
optsys <- switchOpt_IQRsysModel(optsys, optimum = 19)

# Print parameters of the selected optimum
getPars_IQRsysModel(optsys)

# Simulate for the slected optimum and plot
optsys <- sim_IQRsysModel(optsys, simtime = 1:300)
plot_IQRsysModel(optsys)


# Switch back to global optimum
optsys <- switchOpt_IQRsysModel(optsys, optimum = 1)

# Print parameters of the selected optimum
getPars_IQRsysModel(optsys)

# Simulate for the slected optimum and plot
optsys <- sim_IQRsysModel(optsys, simtime = 1:300)
plot_IQRsysModel(optsys)
