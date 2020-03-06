library(IQRtools)
IQRinitCompliance("SCRIPT_02_exploration.R")

# -------------------------------------------------------------------------#
# Import a simplified data format as
# -------------------------------------------------------------------------#

dataSys <- import_IQRsysData("../Data/dataRAW.csv")
dataSys
IQRsaveCSVdata(dataSys,filename="../Data/dataSYS.csv")

# -------------------------------------------------------------------------#
# IQRsysData() reads data in the natural format ----
# used by IQRtools for modeling
# -------------------------------------------------------------------------#

dataSys <- IQRsysData("../Data/dataSYS.csv")
dataSys

# -------------------------------------------------------------------------#
# Use the data argument of IQRsysmodel() to link model to a data set ----
# -------------------------------------------------------------------------#

# Load the model + data
sysobj <- IQRsysModel("Resources/model.txt",
                      data = list(datafile = "../Data/dataSYS.csv"))

# Simulate with user-defined time points
sysobj <- sim_IQRsysModel(sysobj, simtime = 1:300)

# Plot model + data
plot_IQRsysModel(sysobj)

# -------------------------------------------------------------------------#
# Manually change parameters and re-simulate ----
# -------------------------------------------------------------------------#

# Selectively set parameters
sysobj <- setPars_IQRsysModel(sysobj,
                              kde = 0.05,
                              ke  = 0.1,
                              kon = 0.21)

getPars_IQRsysModel(sysobj)
# Simulate with user-defined time points
sysobj <- sim_IQRsysModel(sysobj, simtime = 1:300)

# Plot model + data
plot_IQRsysModel(sysobj)

# -------------------------------------------------------------------------#
# Simulate new parameter values without changing the sysobj ----
# -------------------------------------------------------------------------#

# Simulate with new parameter values
plot_IQRsysModel(sim_IQRsysModel(sysobj, simtime = 1:300,
                     parameters = c(kde=1,kon=1)))

# -------------------------------------------------------------------------#
# Collect all relevant information for ----
# parameter estimation with as_IQRsysEst()
# -------------------------------------------------------------------------#

est <- as_IQRsysEst(sysobj,
                    modelSpec = list(
                      POPestimate = c(
                        initEpo     = 0,
                        initEpoRrel = 1,
                        kde         = 1,
                        kdi         = 1,
                        ke          = 1,
                        kex         = 1,
                        koff        = 1,
                        kon         = 1,
                        kt          = 1
    )
  )
)

# Print information collected in the estimation object
print(est)

