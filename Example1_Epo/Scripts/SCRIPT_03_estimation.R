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
  model = "Imatinib_x.txt",
  data = list(datafile = "Imatinib_sys.csv"),
  modelSpec = list(
    POPvalues0 = c(
      Vc_kg = 3.5,
      Vp_kg = 1.55,
      CLadd         = 1.8,
      Vc_kg_MA         = 25,
      Vp_kg_MA          = 23.2,
      CLadd_MA         = 14,
      SF        = 1,
      CLint_extra = 0.1,
      CLint_extra_MA = 34.6,
      CLin = 1,
      CLout = 10,
      CLin_MA = 35,
      CLout_MA = 38
        ),
    errorModel = list(
      OUTPUT1 = c("absrel", 1, 0.5),
      OUTPUT2 = c("absrel", 1, 0.5)
    )
  )
)


# Check if set-up looks as expected

a <- getPars_IQRsysModel(sysobj)
a <- as.data.frame(a)
est <- as_IQRsysEst(sysobj)

# Create sys project and prepare to run a single estimation
proj <- IQRsysProject(est, "RUN3_1", opt.nfits = 1)

proj <- IQRsysProject(est, "RUN3_2",
                      opt.nfits = 8,
                      opt.sd = 2,
                      FLAGprofileLL = TRUE)

optsys <- run_IQRsysProject(proj, ncores = 8)



optsys <- profile_IQRsysModel(optsys, ncores = 8,
                              fixed = c("CL_int_extra", "CLint_extra_MA", "KA"))




#####
# Scenario 1: initEpo assumed to be known
optsys <- profile_IQRsysModel(optsys, ncores = 8,
                              fixed = c("CLint_extra_MA", "KA"))

plotProfile_IQRsysModel(optsys)


# Scenario 2: initEpo and kex assumed to be known
optsys <- profile_IQRsysModel(optsys, ncores = 8,
                              fixed = c("initEpo", "kex"))

plotProfile_IQRsysModel(optsys)


# -------------------------------------------------------------------------#
# initEpo: lets assume it was subsequently measured to be 160
# kex:     lets assume the whole team agreed that kex=0.001 is the correct value
# -------------------------------------------------------------------------#

# Convert previous model into an estimation object
# and set parameters according to new information - fix them and do not estimate them
newest <- as_IQRsysEst(
  sysModel = sysobj,
  modelSpec = modelSpec_IQRest(
    POPvalues0  = c(CLint_extra_MA = 34.6, SF = 2, KA = 1.5),
    POPestimate = c(CLint_extra_MA = 0, SF = 1, KA = 0)
  )
)

newest

# Generate and run the parameter estimation
proj <- IQRsysProject(newest, projectPath = "RUN3_kexfixed", opt.nfits = 24, ncores = 8)
optsys2 <- run_IQRsysProject(proj)

# Generate new profiles
optsys2 <- profile_IQRsysModel(optsys2, ncores = 8)
plotProfile_IQRsysModel(optsys2)











# Run sys project
optsys <- run_IQRsysProject(proj)


# -------------------------------------------------------------------------#
# run_IQRsysProject() returns an optimized IQRsysModel ----
# -------------------------------------------------------------------------#

# Inspect the estimated parameters
getPars_IQRsysModel(optsys2)

# Inspect data and optimized prediction for estimated parameters
optsys <- sim_IQRsysModel(optsys2, simtime = 1:50)

# Plot results
plot_IQRsysModel(optsys)

optsys

# -------------------------------------------------------------------------#
# Create multi-start project with 36 parameter fits from randomly chosen initial
# guesses. The original initial guess is always part of these multiple guesses
# as_IQRsysProject(., opt.nfits, opt.sd) ----
# -------------------------------------------------------------------------#
getwd()

proj <- IQRsysProject(est, "RUN3_2",
                      opt.nfits = 8,
                      opt.sd = 2,
                      FLAGprofileLL = TRUE)

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

plotWRES_IQRsysModel(optsys, OUTPUT = 2)

plotDVPRED_IQRsysModel(optsys, OUTPUT = 2)


# -------------------------------------------------------------------------#
# switchOpt_IQRsysModel() lets you take a close look at local optima ----
# -------------------------------------------------------------------------#

# Produce waterfall plot
plotWaterfall_IQRsysModel(optsys)

# Switch to another local optimum
optsys <- switchOpt_IQRsysModel(optsys, optimum = 11)

# Print parameters of the selected optimum
getPars_IQRsysModel(optsys)

# Simulate for the slected optimum and plot
optsys <- sim_IQRsysModel(optsys, simtime = 1:50)
plot_IQRsysModel(optsys)


# Switch back to global optimum
optsys <- switchOpt_IQRsysModel(optsys, optimum = 1)

# Print parameters of the selected optimum
getPars_IQRsysModel(optsys)

# Simulate for the slected optimum and plot
optsys <- sim_IQRsysModel(optsys, simtime = 1:50)
plot_IQRsysModel(optsys)
