rm(list=ls())
library(IQRtools)
IQRinitCompliance("SCRIPT_01.R")
# Needed if Microsoft Open R is used:
tryCatch({detach('package:RevoUtils', unload=TRUE)}, error=function(x){})
tryCatch({detach('package:RevoUtilsMath', unload=TRUE)}, error=function(x){})


# --------------------------------------------------------------------
# The model and a first simulation
# We just want to look at the structural model, import it to R
# and simulate it 
# --------------------------------------------------------------------

# The structural model is provided as model.txt file - have a look:
file.edit("phototransduction_model.txt")

# Load the model with IQRmodel
model <- >>>>>>>>>>> ENTER content here

# Define a stimulus as an IQRdosing object with administration in to INPUT1 at TIME=0,
# and amount of 2 and an administration duration of 0.5
stimu <- >>>>>>>>>>> ENTER content here

# Simulate the model using sim_IQRmodel() for a simulation time of 20 time units
res   <- >>>>>>>>>>> ENTER content here

# Plot the result
>>>>>>>>>>> ENTER content here


# --------------------------------------------------------------------
# We have gotten some measurement data and want to see if the 
# initial parameterization in the model is allowing to describe the data
# (it will not ... at least not very well)
# --------------------------------------------------------------------

# Import the data using import_IQRsysData()
data <- >>>>>>>>>>> ENTER content here

# Define an IQRsysModel object with "phototransduction_model.txt" as model
# input argument and data as data argument
sysmodel <- >>>>>>>>>>> ENTER content here

# Simulate the IQRsysModel and show results
plot(sim_IQRsysModel(sysmodel))
  

# --------------------------------------------------------------------
# Alright, lets go to parameter estimation 
# We need to setup a more complete IQRsysModel that also contains initial 
# guesses and information about which parameters should be estimated or
# kept fixed
# --------------------------------------------------------------------

sysmodel <- IQRsysModel(
  model = "phototransduction_model.txt",
  data = import_IQRsysData("data.csv"),
  modelSpec = list(

    # Providing initial guesses for all parameters
    POPvalues0 = c(
      PDE0          = 100,
      ARR0          = 5,
      kRGact        = 1,
      k1Gact        = 1,
      k2Gact        = 1,
      kGactPDEact   = 1,
      kRArr1        = 1,
      kRArr2        = 1,
      kGr1          = 1,
      kGr2          = 1,
      kG            = 1
    ),

    # Lets just try to estimate all parameters
    POPestimate = c(
      PDE0          = 1,
      ARR0          = 1,
      kRGact        = 1,
      k1Gact        = 1,
      k2Gact        = 1,
      kGactPDEact   = 1,
      kRArr1        = 1,
      kRArr2        = 1,
      kGr1          = 1,
      kGr2          = 1,
      kG            = 1
    ),

    # Defining the error model 
    errorModel = list(
      OUTPUT1 = c("absrel",0.1, 0.1),
      OUTPUT2 = c("abs", 10)
    )
  )
)

# Setup estimation problem
# This is a helper function making the interface between an IQRsysModel and an IQRsysProject
# "est" then can be used as input argument to write out an IQRsysProject estimation project to 
# the disk.
est <- as_IQRsysEst(
  sysmodel
)

# Generate the IQRsysProject
proj <- IQRsysProject(est, 
                      projectPath = "RUN1",   # Storage location on the disk
                      opt.method = "trust",   # We use the "good" optimizer
                      opt.nfits = 24,         # Performing 24 estimation runs from randomized initial guesses
                      opt.sd = 3,             # SD for randomization
                      opt.iterlim = 1000)     # Lets allow for more than 100 (default) iterations 

# Run the estimation
optsys <- run_IQRsysProject(proj, ncores = 8)


# --------------------------------------------------------------------
# Have a look at the obtained optimum
# --------------------------------------------------------------------

# Its not looking good - yet
plot_IQRsysModel(sim_IQRsysModel(optsys))

# We look at the parameters
getPars_IQRsysModel(optsys)

# Have we found several local minima?
plotWaterfall_IQRsysModel(optsys)
# Doesn't look to good ... 

# Lets see parameter ranges across all fits
plotPars_IQRsysModel(optsys)
# Seems they are not yet well defined


# --------------------------------------------------------------------
# OK, above we have not considered condition specific parameters.
# We know that in the delta_ARR_STIM_0_1 experiment ARR was knocked out and 
# ARR0 should thus be 0 and not estimated - in all other conditions ARR0
# should be 5 and not estimated as well. In the same manner PDE0 should 
# be fixed at 0 in delta_PDE_STIM_0_5 and estimated in all other conditions.
# 
# Lets implement that in the IQRsysModel using the condition specific settings.
# --------------------------------------------------------------------

sysmodel <- IQRsysModel(
  model = "phototransduction_model.txt",
  data = import_IQRsysData("data.csv"),
  modelSpec = list(
    
    # Providing initial guesses for all parameters
    POPvalues0 = c(
      PDE0          = 100,
      ARR0          = 5,
      kRGact        = 1,
      k1Gact        = 1,
      k2Gact        = 1,
      kGactPDEact   = 1,
      kRArr1        = 1,
      kRArr2        = 1,
      kGr1          = 1,
      kGr2          = 1,
      kG            = 1
    ),
    
    # Lets just try to estimate all parameters
    POPestimate = c(
      PDE0          = 1,
      ARR0          = 0,  # Not estimated
      kRGact        = 1,
      k1Gact        = 1,
      k2Gact        = 1,
      kGactPDEact   = 1,
      kRArr1        = 1,
      kRArr2        = 1,
      kGr1          = 1,
      kGr2          = 1,
      kG            = 1
    ),

    errorModel = list(
      OUTPUT1 = c("absrel",0.1, 0.1),
      OUTPUT2 = c("abs", 10)
    ),

    # Define the names of the two conditions that we are considering 
    # using the argument "LOCmodel":
    LOCmodel = list(

>>>>>>>>>>> ENTER content here

    ),
    
    # Define the initial guesses for the condition specific parameters
    # (ARR0 and PDE0) and set them each to 0 for the knocl-out conditions / experiments
    LOCvalues0 = list(

>>>>>>>>>>> ENTER content here

    ),
    
    # Set the parameters to not be estimated - remaining on 0 using the 
    # LOCestimate argument
    LOCestimate = list(

>>>>>>>>>>> ENTER content here

    )
    

  )
)

# Look at the sysmodel overview
sysmodel

# Have a look at the parameters stored in sysmodel using getPars_IQRsysModel()
getPars_IQRsysModel(sysmodel)

# Compare model and data using sim_IQRsysModel() and plot_IQRsysModel() around
res <- sim_IQRsysModel(sysmodel)
plot_IQRsysModel(res)

# Setup estimation problem using as_IQRsysEst() function on the sysmodel
est <- as_IQRsysEst(
  sysmodel
)

# Generate the IQRsysProject using IQRsysProject function.
proj <- IQRsysProject(est, 
                      projectPath = "RUN2", 
                      opt.method = "trust",
                      opt.nfits = 24, 
                      opt.sd = 3, 
                      opt.iterlim = 1000)

# Run the Sys Project
optsys <- run_IQRsysProject(proj, ncores = 8)


# Have a look at the optimum
plot_IQRsysModel(sim_IQRsysModel(optsys))
# Doesn't look to bad?


# Have a look at some other things
getPars_IQRsysModel(optsys)

# Parameters are pretty well defined?
# Maybe with exception of the very high correlated k1Gact and k2Gact ones
plotPars_IQRsysModel(optsys)

# Well not directly a stair ...
plotWaterfall_IQRsysModel(optsys)

# Other possible diagnostics
plotFit_IQRsysModel(optsys, OUTPUT = 1)
plotFit_IQRsysModel(optsys, OUTPUT = 2)
plotWRES_IQRsysModel(optsys, OUTPUT = 2)
plotDVPRED_IQRsysModel(optsys, OUTPUT = 1)

# --------------------------------------------------------------------
# Ok, we have used a "good" optimizer ... now lets try it with 
# another one. Currently available: hookjeves and nelder mead.
# --------------------------------------------------------------------

# Generate the IQRsysProject using IQRsysProject function with use of hookjeeves
proj <- IQRsysProject(est, 
                      projectPath = "RUN3",     # <= do not forget to update the path for the project to not overwrite the previous
                      opt.method = "hjkb",      # Selects hookjeeves
                      opt.nfits = 24, 
                      opt.sd = 3, 
                      opt.iterlim = 1000)

optsys <- run_IQRsysProject(proj, ncores = 8)

# Takes longer ... you might want to reduce the number of fits to run ... but then you get even worse convergence
# In principle you would need to increase the iterations considerably to have a chance at finding the optimum

# Lets assess the outcome:
plot_IQRsysModel(sim_IQRsysModel(optsys))
getPars_IQRsysModel(optsys)
# Still pretty far from the true optimum


# --------------------------------------------------------------------
# Nelder mead ...
# --------------------------------------------------------------------

# Generate the IQRsysProject using IQRsysProject function with use of hookjeeves
proj <- IQRsysProject(est, 
                      projectPath = "RUN4", 
                      opt.method = "nmkb",      # Selects nelder mead
                      opt.nfits = 24, 
                      opt.sd = 3, 
                      opt.iterlim = 1000)

optsys <- run_IQRsysProject(proj, ncores = 8)

# Takes longer ... you might want to reduce the number of fits to run ... but then you get even worse convergence
# In principle you would need to increase the iterations considerably to have a chance at finding the optimum

# Lets assess the outcome:
plot_IQRsysModel(sim_IQRsysModel(optsys))
getPars_IQRsysModel(optsys)
# Still pretty far from the true optimum



# --------------------------------------------------------------------
# Finally ... this example was build in 2006 or 2007 as a banchmark for 
# parameter estimation and as a tutorial example how complicated parameter
# estimation can be - if you like, try it in your facvorit parameter estimation
# tool with your favorite algorithms.
# --------------------------------------------------------------------
