# Welcome to the IntiQuan QSP Workshop!
# =====================================
#
# Please follow this guide to setup the software that is required for hands-on
# experience during the workshop. Ideally, you do this preparation before the
# date of the workshop.
#
# We try to make it as easy as possible ... the setup is written as an R script
# with only very few commands to execute. Installation information is provided
# for Windows, Linux, and MacOS.

# -------------------------------------------------------------------------------------
# R and R Studio
# -------------------------------------------------------------------------------------

# Please ensure you have R and RStudio installed on your computers.
# For reproducibility reasons the latest R version that should be
# used is R 3.5.3. But you can use any version from 3.4.0.

# When you get any weird errors during installation -- try to install able
# new and clean R version and repeat the IQR Tools installation. R is one
# of the least reproducible softwares out there without careful
# administration. But IQR Tools will take care of that.

# -------------------------------------------------------------------------------------
# Windows
# -------------------------------------------------------------------------------------

# Step 1: Installation of Rtools
# ------------------------------
# Rtools is needed on Windows as it provides required compilers to compile C-code.
# If you already have installed Rtools, then you can skip this step and go to Step 3.

# PREFERRED method of installation:
# 1) Download Rtools35.exe from: https://cran.r-project.org/bin/windows/Rtools/
# 2) Install it with admin rights or let an admin install it for you

# Method without admin rights:
# The following R commands will install R tools on your computer at the correct place.
# Admin rights are NOT required!

source("https://iqrtools.intiquan.com/install.R")
install_Rtools()


# Step 2: Restart R / RStudio
# ---------------------------
# R needs to be restarted for the path updates to take effect and R being able to
# find Rtools. If you do not restart R and Rstudio, the next step will fail!


# Step 3: Installation IQRtools
# -----------------------------
# The following commands will install IQR Tools. Depending on your R system a number
# of packages will be loaded.

source("https://iqrtools.intiquan.com/install.R")
installVersion.IQRtools(forceDependencies = TRUE)

# If at any point during this installation issues arise they come most likely from a
# corrupt R installation on your computer. The issue of R is that typically there is no
# control over versions of installed packages - a reproducibility nightmare.
# So, when an issue arises with the installation, please install a clean R version in
# a different folder than your current R version and repeat Step 3.


# Step 4: Test IQR Tools
# ----------------------

library(IQRtools)
test_IQRtools()

# If you see an output that looks like a data.frame - then R Tools and IQR Tools are
# correctly installed. If you do not see such an output - please contact info@intiquan.com
# and we will help you.

# Step 5 (Optional): Installation of IQRsbml
# ------------------------------------------
# This step is needed if you want to be able to import SBML models to R.
# You can install it by following instructions on: https://iqrsbml.intiquan.com/


# -------------------------------------------------------------------------------------
# MacOS
# -------------------------------------------------------------------------------------

# Step 1: Xcode and XQuartz
# -------------------------
# Ensure that Xcode and XQuartz are installed on your Mac and ensure your R installation
# is able to build source packages that need compilation. If in doubt, please ask your
# sysadmin.


# Step 2: Installation IQRtools
# -----------------------------
# The following commands will install IQR Tools. Depending on your R system a number
# of packages will be loaded.

source("https://iqrtools.intiquan.com/install.R")
installVersion.IQRtools(forceDependencies = TRUE)

# If at any point during this installation issues arise they come most likely from a
# corrupt R installation on your computer. The issue of R is that typically there is no
# control over versions of installed packages - a reproducibility nightmare.
# So, when an issue arises with the installation, please install a clean R version. We
# know that this is painful on MacOS - but with a corrupt R there is not much that can
# be done else.


# Step 3: Test IQR Tools
# ----------------------

library(IQRtools)
test_IQRtools()

# If you see an output that looks like a data.frame - then R Tools and IQR Tools are
# correctly installed. If you do not see such an output - please contact info@intiquan.com
# and we will help you.


# -------------------------------------------------------------------------------------
# Linux
# -------------------------------------------------------------------------------------

# You might need get support of your sysadmin to install IQR Tools. In this case the
# sysadmin can contact us as info@intiquan.com.


# Step 1: Installation IQRtools
# -----------------------------
# The following commands will install IQR Tools. Depending on your R system a number
# of packages will be loaded.

source("https://iqrtools.intiquan.com/install.R")
installVersion.IQRtools(forceDependencies = TRUE)


# Step 2: Test IQR Tools
# ----------------------

library(IQRtools)
test_IQRtools()

# If you see an output that looks like a data.frame - then R Tools and IQR Tools are
# correctly installed. If you do not see such an output - please contact info@intiquan.com
# and we will help you.
