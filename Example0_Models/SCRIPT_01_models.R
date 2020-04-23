library(IQRtools)

##############################
# Basic model simulation
##############################

# Look at the model file
file.edit("firstmodel.txt")

# Load the model from text file into R as an object
model <- IQRmodel("firstmodel.txt")

# Simulate the model (parameters and initial conditions
# as defined in the model file)
res <- sim_IQRmodel(model,simtime=80)

# Plot results
plot(res)

# Plot specific output
plot(res$TIME,res$Y1)


##############################
# Simulation with changed initial conditions
##############################

# IC for X1=5, IC for Y1=2
res <- sim_IQRmodel(model,simtime=80,IC = c(X1=5,Y1=2))

# Plotting only subset and not all elements
plot(res[,c("TIME","X1","Y1")])





##############################
# Simulation with changed parameters
##############################

# Setting k to 0.5
res <- sim_IQRmodel(model,simtime=80,parameters = c(k=0.5))

# Plotting only subset and not all elements
plot(res[,c("TIME","X1","Y1")])




##############################
# Exporting an IQRmodel as text file in different formats
##############################

# Exporting as ODE model
export_IQRmodel(model,filename = "modelexported.txt")

# Exporting as BC model
export_IQRmodel(model,filename = "modelexportedBC.txt",FLAGbc = TRUE)



##############################
# Simulation of model with dosing input (but no dosing)
##############################

# Look at the model file
file.edit("firstmodel_dosing.txt")

# Load the model from text file into R as an object
model <- IQRmodel("firstmodel_dosing.txt")

# Simulate the model (parameters and initial conditions
# as defined in the model file)
res <- sim_IQRmodel(model,simtime=80)

# Plot results
plot(res[,c("TIME","X1","Y1","Z1")])


##############################
# Definition of a dosing object
##############################

dosing <- IQRdosing(
  TIME = 0, # Time of dosing (required)
  AMT  = 2, # Amount of dosing (required)
  ADM  = 1, # Location of administration 1=>INPUT1, 2=>INPUT2, ... (required)
  TINF = 2, # Duration of administration (optional. default: 0)
  ADDL = 4, # Number of additional repeated doses (optional. default: 0)
  II   = 12 # Dosing interval (required if ADDL is defined)
)

dosing

##############################
# Simulation of model with dosing object
##############################

# Load the model from text file into R as an object
model <- IQRmodel("firstmodel_dosing.txt")

# Simulate the model with the dosing object
res <- sim_IQRmodel(model,simtime=80,dosingTable = dosing)

# Plot results
plot(res[,c("TIME","X1","Y1","Z1")])


#
# ##############################
# # Hands-on ... complete to perform a single dose simulation
# ##############################
#
# dosing <- IQRdosing(
#   TIME =
#   AMT  =
#   ADM  =
# )
# model <- IQRmodel("firstmodel_dosing.txt")
# res <- sim_IQRmodel(model,simtime=80,dosingTable = dosing)
# plot(res[,c("TIME","X1","Y1","Z1")])


##############################
# Simulate more complex model
##############################

file.edit("Shah mAb PBPK JPKPD 2012.txt")
file.edit("Shah mAb PBPK JPKPD 2012 BC.txt")

modelODE <- IQRmodel("Shah mAb PBPK JPKPD 2012.txt",FLAGsym=FALSE)
modelBC <- IQRmodel("Shah mAb PBPK JPKPD 2012 BC.txt",FLAGsym=FALSE)

# Simulate IV Single Dose 1 mg/kg ----

dosing <- IQRdosing(TIME=0,AMT=0.028*1,ADM=1) # (mg) 1 mg/kg

resmodelODE <- sim_IQRmodel(model = modelODE,
                         dosingTable = dosing,
                         simtime = 20*24,
                         opt_abstol = 1e-15,
                         opt_reltol = 1e-15,
                         opt_maxstep = 0.05)

resmodelBC <- sim_IQRmodel(model = modelBC,
                           dosingTable = dosing,
                           simtime = 20*24,
                           opt_abstol = 1e-15,
                           opt_reltol = 1e-15,
                           opt_maxstep = 0.05)

# Plot results

simPlot <- rbind(
  data.frame(
    TIME = resmodelODE$TIME/24,
    VALUE = resmodelODE$Plasma_nM,
    TISSUE = "Plasma",
    TYPE = "ODE MODEL"
  ),
  data.frame(
    TIME = resmodelBC$TIME/24,
    VALUE = resmodelBC$Plasma_nM,
    TISSUE = "Plasma",
    TYPE = "BC MODEL"
  ),

  data.frame(
    TIME = resmodelODE$TIME/24,
    VALUE = resmodelODE$Lung_nM,
    TISSUE = "Lung",
    TYPE = "ODE MODEL"
  ),
  data.frame(
    TIME = resmodelBC$TIME/24,
    VALUE = resmodelBC$Lung_nM,
    TISSUE = "Lung",
    TYPE = "BC MODEL"
  ),

  data.frame(
    TIME = resmodelODE$TIME/24,
    VALUE = resmodelODE$Skin_nM,
    TISSUE = "Skin",
    TYPE = "ODE MODEL"
  ),
  data.frame(
    TIME = resmodelBC$TIME/24,
    VALUE = resmodelBC$Skin_nM,
    TISSUE = "Skin",
    TYPE = "BC MODEL"
  ),

  data.frame(
    TIME = resmodelODE$TIME/24,
    VALUE = resmodelODE$TUMOR_nM,
    TISSUE = "Tumor",
    TYPE = "ODE MODEL"
  ),
  data.frame(
    TIME = resmodelBC$TIME/24,
    VALUE = resmodelBC$TUMOR_nM,
    TISSUE = "Tumor",
    TYPE = "BC MODEL"
  )
)

library(ggplot2)

# Remove 0 Values to avoid warning when log transforming PK simulation data
simPlot <- simPlot[simPlot$VALUE>0,]
print(IQRggplot(simPlot) +
        geom_line(size=1,aes(x=TIME,y=VALUE,color=TISSUE,linetype=TYPE)) +
        scale_color_IQRtools() +
        scale_y_log10() +
        ylab("Concentration [nM]") +
        xlab("Time [Days]") )

run_IQRsim()
