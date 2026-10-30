# Population Pharmacokinetic Modeling Using PKPDsim

This repository contains a professional data science project focused on population pharmacokinetic (PK) simulation. Using ordinary differential equations (ODEs) within the `PKPDsim` R package, the project simulates and visualizes inter-individual variability across a virtual patient cohort.

## Project Overview

The simulation models a **1-compartment oral administration profile** over a course of 6 days (multi-dose regimen). Instead of simulating a single "average" individual, this project introduces **Inter-Individual Variability (IIV)** via a variance-covariance matrix (`omega`) to mimic real-world clinical scenarios with a cohort of 50 virtual patients.

### Model Specifications & Parameters
- **Dosing Regimen:** 100 mg oral doses administered every 24 hours for a total of 6 doses (`n = 6`, `interval = 24`).
- **Structural Parameters (`par1`):**
  - Clearance (`CL`): 5 L/h
  - Volume of Distribution (`V`): 50 L
  - Absorption Rate Constant (`KA`): 1 h⁻¹
- **Variability (`omega`):** Applied log-normal individual deviations to `CL` (10%), `V` (5%), and `KA` (20%).

## Repository Structure

- `simulation_project.R`: The complete, reproducible R script that defines the ODE model, generates the population data, and builds the final visualization.
- `pk_simulation_plot.png`: The exported high-resolution plot demonstrating the simulated pharmacokinetic curves.
- `README.md`: Project documentation and summary.

## Simulation Results

The generated plot beautifully illustrates the classic pharmacokinetic "spikes" following oral dosing, the accumulation phase, and the eventual achievement of the pharmacokinetic **steady-state** around the 4th-5th dose (approx. 100 hours). 

Due to the introduced IIV, the chart clearly shows the expected clinical spread, with peak plasma concentrations varying significantly between individuals.

![Population PK Simulation Profile](pk_simulation_plot.png)

