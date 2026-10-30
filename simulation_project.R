rm(list = ls())
library(PKPDsim)
library(ggplot2)

#  THE BASE PK MODEL

pk_model <- new_ode_model(
  code = "
    dAdt[1] = -KA * A[1];
    dAdt[2] =  KA * A[1] - (CL/V) * A[2];
  ",
  obs = list(cmt = 2, scale = "V")
)


par1 <- list(CL = 5, V = 50, KA = 1)
my_omega_vector <- c(0.1, 0.05, 0.2)     

Emax <- 100
EC50 <- 1.5

#POPULATION PROFILE + THERAPEUTIC WINDOW

reg_standard <- new_regimen(amt = 100, n = 6, interval = 24, type = "oral")

sim_pop <- sim_ode(ode = pk_model, regimen = reg_standard, n = 50,
                   omega = my_omega_vector, only_obs = TRUE, parameters = par1, t_max = 144)
data_pop <- as.data.frame(sim_pop)
if ("t" %in% names(data_pop)) names(data_pop)[names(data_pop) == "t"] <- "time"


data_pop$EFFECT <- (Emax * data_pop$y) / (EC50 + data_pop$y)


plot_window <- ggplot(data_pop, aes(x = time, y = y, group = id)) +
  geom_line(color = "#ff69b4", alpha = 0.3, size = 0.7) +
  geom_hline(yintercept = 0.8, color = "#000bbb", linetype = "dashed", size = 1) + 
  geom_hline(yintercept = 2.5, color = "#000bbb", linetype = "dashed", size = 1) +
  annotate("text", x = 12, y = 2.7, label = "MTC (Maximum Tolerated Concentration)", color = "#000bbb", hjust = 0) +
  annotate("text", x = 12, y = 0.6, label = "MEC (Minimum Effective Concentration)", color = "#000bbb", hjust = 0) +
  labs(title = "Population PK Profile & Therapeutic Window", x = "Time (hours)", y = "Plasma Concentration (mg/L)") +
  theme_minimal()

print(plot_window)
ggsave("1_therapeutic_window.png", plot = plot_window, width = 8, height = 5)


#REGIMEN OPTIMIZATION COMPARISON (100 mg QD vs 50 mg BID)

reg_twice_daily <- new_regimen(amt = 50, n = 12, interval = 12, type = "oral")

sim_standard <- sim_ode(ode = pk_model, regimen = reg_standard, parameters = par1, t_max = 144)
sim_twice <- sim_ode(ode = pk_model, regimen = reg_twice_daily, parameters = par1, t_max = 144)

df_standard <- as.data.frame(sim_standard)
df_standard$regimen <- "100 mg Once Daily (QD)"
df_twice <- as.data.frame(sim_twice)
df_twice$regimen <- "50 mg Twice Daily (BID)"

data_comp <- rbind(df_standard, df_twice)
if ("t" %in% names(data_comp)) names(data_comp)[names(data_comp) == "t"] <- "time"

plot_comp <- ggplot(data_comp, aes(x = time, y = y, color = regimen)) +
  geom_line(size = 1.2) +
  scale_color_manual(values = c("#ff69b4", "#4b0082")) +
  labs(title = "Dosing Regimen Comparison (Equal Total Daily Dose)", x = "Time (hours)", y = "Plasma Concentration (mg/L)") +
  theme_minimal() + theme(legend.position = "bottom")

print(plot_comp)
ggsave("2_regimen_comparison.png", plot = plot_comp, width = 8, height = 5)


#MISSED DOSE SIMULATION 

reg_missed <- new_regimen(
  amt = c(100, 100, 100, 100, 100),
  times = c(0, 24, 72, 96, 120), 
  type = "oral"
)

sim_missed <- sim_ode(ode = pk_model, regimen = reg_missed, parameters = par1, t_max = 144)
data_missed <- as.data.frame(sim_missed)
if ("t" %in% names(data_missed)) names(data_missed)[names(data_missed) == "t"] <- "time"

plot_missed <- ggplot(data_missed, aes(x = time, y = y)) +
  geom_line(color = "#ff69b4", size = 1.2) +
  geom_vline(xintercept = 48, color = "black", linetype = "dotted", size = 1) +
  annotate("text", x = 49, y = 25, label = "Missed Dose\nat 48 Hours!", color = "black", hjust = 0) +
  labs(title = "Impact of Patient Non-Compliance on Plasma Levels", x = "Time (hours)", y = "Plasma Concentration (mg/L)") +
  theme_minimal()

print(plot_missed)
ggsave("3_missed_dose.png", plot = plot_missed, width = 8, height = 5)


# PD RESPONSE PROFILE

plot_pd <- ggplot(data_pop, aes(x = time, y = EFFECT, group = id)) +
  geom_line(color = "#9370db", alpha = 0.3, size = 0.7) + 
  labs(title = "Pharmacodynamic Output (Population Emax Response)", x = "Time (hours)", y = "Pharmacological Effect (%)") +
  theme_minimal()

print(plot_pd)
ggsave("4_pd_effect.png", plot = plot_pd, width = 8, height = 5)
