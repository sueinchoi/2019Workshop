library(IQRtools)
rm(list=ls())
IQRinitCompliance("SCRIPT_03_estimation.R")
# Needed if Microsoft Open R is used:
tryCatch({detach('package:RevoUtils', unload=TRUE)}, error=function(x){})
tryCatch({detach('package:RevoUtilsMath', unload=TRUE)}, error=function(x){})

IQRinitCompliance('SCRIPT_01_estimation.R')

# Setting up sysModel object with data and model specification
sysobj <- IQRsysModel(
  # Model
  model = "Resources/model.txt",
  # Data
  data  = list(
    datafile = "../Data/data.csv",
    regressorNames = c("Fabs1", "ka", "CL", "Vc", "Q1", "Vp1", "Tlag1", "PLbase")
  ),
  # Specs
  modelSpec = list(
    POPvalues0      = c(GR = 0.02 , hill = 4, EMAX = 0.1, EC50 = 0.01),
    POPestimate     = c(GR = 1    , hill = 1, EMAX = 1  , EC50 = 1),
    errorModel = list(
      OUTPUT1 = c(type = "abs", guess = 1)
    )
  )
)

plot(sysobj)

# Generate a SysProject
est <- as_IQRsysEst(sysobj)
proj <- IQRsysProject(est,
                      projectPath = "../Models/01_NoIIV",
                      opt.nfits = 24,
                      opt.sd = 2,
                      opt.parupper = c(hill = 10),
                      opt.parlower = c(hill = 1))

# Run the estimation
optsys <- run_IQRsysProject(proj, ncores = 8, FLAGgof = FALSE)

# Plot best fit
plot(optsys)

# Plot some diagnostics
plotWaterfall_IQRsysModel(optsys)
plotPars_IQRsysModel(optsys)
plotPred_IQRsysModel(optsys, states = "OUTPUT1")


##########################################################
# Now lets take into account inter-individual variability
# on GR, EMAX, and EC50
##########################################################

# Estimate population parameters + IIV
est <- as_IQRsysEst(sysobj,
                    modelSpec = list(
                      IIVdistribution = c(GR ='L' , EMAX ='L' , EC50 ='L' ),
                      IIVvalues0      = c(GR = 0.5, EMAX = 0.5, EC50 = 0.5),
                      IIVestimate     = c(GR = 2  , EMAX = 2  , EC50 = 2  )
                    ))

# Generate a SysProject
proj <- IQRsysProject(est,
                      projectPath = "../Models/02_IIV",
                      opt.nfits = 24,
                      opt.sd = 2,
                      opt.parupper = c(hill = 10),
                      opt.parlower = c(hill = 1))

# Run the estimation
optsys <- run_IQRsysProject(proj, ncores = 8, FLAGgof = TRUE)

# Plot best fit
plot(optsys)

# Plot some diagnostics
plotWaterfall_IQRsysModel(optsys)
plotPars_IQRsysModel(optsys)
plotPred_IQRsysModel(optsys, states = "OUTPUT1")

# Look at results
getPars_IQRsysModel(optsys)

