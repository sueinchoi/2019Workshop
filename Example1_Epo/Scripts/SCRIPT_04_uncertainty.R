library(IQRtools)
IQRinitCompliance("SCRIPT_04_uncertainty.R")
# Needed if Microsoft Open R is used:
tryCatch({detach('package:RevoUtils', unload=TRUE)}, error=function(x){})
tryCatch({detach('package:RevoUtilsMath', unload=TRUE)}, error=function(x){})

# -------------------------------------------------------------------------#
# Load previously generated sysmodel
# -------------------------------------------------------------------------#

optsys <- load_IQRsysProject("../Models/RUN2/")

# -------------------------------------------------------------------------#
# Generate likelihood profile using profile_IQRsysModel()
# -------------------------------------------------------------------------#

# Add profile likelihood information
optsys <- profile_IQRsysModel(optsys, ncores = 8)

# Plot the profile LL information
plotProfile_IQRsysModel(optsys)

# Display object - it now tells the user that Profile LL information available
optsys

# -------------------------------------------------------------------------#
# Assess impact of assuming certain parameters known (fixed) on identifiability
# of other parameters
# -------------------------------------------------------------------------#

# Scenario 1: initEpo assumed to be known
optsys <- profile_IQRsysModel(optsys, ncores = 8,
                              fixed = "initEpo")

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
  sysModel = optsys,
  modelSpec = modelSpec_IQRest(
    POPvalues0  = c(kex = 0.001, initEpo=160),
    POPestimate = c(kex = 0,     initEpo=0)
  )
)

newest

# Generate and run the parameter estimation
proj <- IQRsysProject(newest, projectPath = "../Models/RUN3_kexfixed", opt.nfits = 24)
optsys2 <- run_IQRsysProject(proj)

# Generate new profiles
optsys2 <- profile_IQRsysModel(optsys2, ncores = 8)
plotProfile_IQRsysModel(optsys2)
