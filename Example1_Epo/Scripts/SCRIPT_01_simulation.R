library(IQRtools)
IQRinitCompliance("SCRIPT_01_simulation.R")
aux_version("IQRtools",minVersion = "1.0.8")
setwd("C:/Users/admin/Dropbox/Vactocertib")
setwd("C:/Users/admin/Documents/Intiquan_QSP(2019)/IntiQuan/QSP/Example1_Epo/Scripts")
# -------------------------------------------------------------------------#
# Have a look at the implemented model in the ODE syntax
# -------------------------------------------------------------------------#

file.edit("Resources/model.txt")

# -------------------------------------------------------------------------#
# IQR_sysModel() generates a sysmodel
# -------------------------------------------------------------------------#

# Create sysModel object
sysobj <- IQRsysModel(model = "Model_DDI_final.cpp")

# Get basic information
sysobj

# -------------------------------------------------------------------------#
# sim_IQRsysModel() lets you perform model simulation
# plot_IQRsysModel() plots the results of this simulation
# -------------------------------------------------------------------------#

# Perform a simulation (adds results to the IQRsysModel object)
sysobj <- sim_IQRsysModel(sysobj)
sysobj
# Plot (trivial) results - nothing happens as no Epo was dosed
plot_IQRsysModel(sysobj)

# Explore more options:
#  - Change simulation time vector
#  - Show output and input variables and all state variables
sysobj <- sim_IQRsysModel(sysobj,
                          simtime = seq(0, 20, .1),
                          FLAGoutputsOnly = FALSE)

plot_IQRsysModel(sysobj)

# By default no error bands based on error model parameters are shown
plot_IQRsysModel(sysobj,FLAGerror = TRUE)

# Of course ... this was a trivial simulation result and error parameters
# are set to default values (not estimated yet)


# -------------------------------------------------------------------------#
# Simulate the model with dosing of Epo
# Use the dosing argument of IQRsysmodel() to define model inputs/dosing
# -------------------------------------------------------------------------#

# Define dosing schedule for compound administration
# Here: Single dose at time=0 into INPUT1 with 10 hours infusion time and amount of 1 unit
mydosing <- IQRdosing(TIME = 0,
                      ADM = 1,
                      TINF = 10,
                      AMT = 1)

# Provide dosing information into the sysModel
sysobj <- IQRsysModel("Resources/model.txt",
                      dosing = mydosing)

# Simulate the model
sysobj <- sim_IQRsysModel(sysobj,
                          simtime = seq(1, 100, .1),
                          FLAGoutputsOnly = FALSE)

plot_IQRsysModel(sysobj)


# -------------------------------------------------------------------------#
# getPars_IQRsysModel() lets you print and access model parameters
# -------------------------------------------------------------------------#

# Get parameter information of the model
getPars_IQRsysModel(sysobj)

# Store parameter values in vector
mypars <- getPars_IQRsysModel(sysobj)
mypars

# Selectively get parameters
mypars <- getPars_IQRsysModel(sysobj, "kde", "ke", "kon")
mypars

# -------------------------------------------------------------------------#
# setPars_IQRsysModel() lets you set model parameters
# -------------------------------------------------------------------------#

# Selectively set parameters
sysobj <- setPars_IQRsysModel(sysobj,
                              kde = 0.05,
                              ke  = 0.1,
                              kon = 0.21)


# Simulate the model again with the updated parameters
sysobj <- sim_IQRsysModel(sysobj,
                          FLAGoutputsOnly = FALSE)
sysobj
plot_IQRsysModel(sysobj)


# -------------------------------------------------------------------------#
# Use the modelSpec argument of IQRsysmodel()
# to define multi-conditional models
# -------------------------------------------------------------------------#

# Create sysModel with local parameters
sysobj <- IQRsysModel(
  model = "Resources/model.txt",
  dosing = IQRdosing(TIME = 0, ADM = 1, AMT = 1),
  modelSpec = list(
    LOCmodel = list(
      kon = c("Epo_Human", "Epo_Recombinant")
    ),
    LOCvalues = list(
      kon = c(Epo_Human = 1.5, Epo_Recombinant = 0.001)
    )
  )
)

# Basic print-out shows conditions
sysobj

# Simulate and plot
sysobj <- sim_IQRsysModel(sysobj)
plot_IQRsysModel(sysobj)


# Grouped plot by condition - better for comparison
plot_IQRsysModel(sysobj,FLAGgroupCONDITION = TRUE)


# -------------------------------------------------------------------------#
# How to set condition specific parameters
# -------------------------------------------------------------------------#

# 1st approach: attaching name of condition to name of parameter by underscore
#                               parametername_conditionname
sysobj <- setPars_IQRsysModel(sysobj, kon_Epo_Recombinant = 1e-5)

# Plot results and change time vector avoid plotting log(0) at 0
plot_IQRsysModel(sim_IQRsysModel(sysobj,
                          simtime = seq(1, 300,1),
                          FLAGoutputsOnly = FALSE),
                 FLAGgroupCONDITION = TRUE)


# 2nd approach: using a named vector for parameter definition
sysobj <- setPars_IQRsysModel(sysobj, kon = c(Epo_Recombinant = 10))

# Plot
plot_IQRsysModel(sim_IQRsysModel(sysobj,
                                 simtime = seq(1, 300,1),
                                 FLAGoutputsOnly = FALSE),
                 FLAGgroupCONDITION = TRUE)


# Condition names documented in the object
sysobj


# -------------------------------------------------------------------------#
# Use the dosing argument of IQRsysmodel()
# to implement condition-specific dosing
# -------------------------------------------------------------------------#

# Create sysModel with local dosing and parameters
sysobj <- IQRsysModel(
  model = "Resources/model.txt",
  dosing = list(
    Epo_Human = IQRdosing(TIME = 0, ADM = 1, AMT = 1, TINF = 0),
    Epo_Recombinant = IQRdosing(TIME = 0, ADM = 1, AMT = 1, TINF = 10, ADDL=2, II=100)
  ),
  modelSpec = list(
    LOCmodel = list(
      kon = c("Epo_Human", "Epo_Recombinant")
    ),
    LOCvalues = list(
      kon = c(Epo_Human = 1.5, Epo_Recombinant = 1e-4)
    )
  )
)

# Create output
sysobj <- sim_IQRsysModel(sysobj,
                          simtime = seq(1, 300, 1),
                          FLAGoutputsOnly = FALSE)

# Plot result
plot_IQRsysModel(sysobj, FLAGgroupCONDITION = TRUE)


license_IQRtools()
