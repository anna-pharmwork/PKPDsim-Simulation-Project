library(PKPDsim)
library(ggplot2)

pk_model <- new_ode_model(
    code = "
    dAdt[1] = -KA * A[1];
    dAdt[2] =  KA * A[1] - (CL/V) * A[2];
  ",
    obs = list(cmt = 2, scale = "V")
  )


my_parameters <- list(CL = 5, V = 50, KA = 0.5)


my_regimen <- new_regimen(
  amt = 500,
  n = 6,
  interval = 12,
  type = "oral"
)

sim_res <- sim(
  ode = pk_model,
  parameters = my_parameters,
  regimen = my_regimen,
  t_max = 80
)

sim_data <- as.data.frame(sim_res)

if ("t" %in% names(sim_data)) {
  names(sim_data)[names(sim_data) == "t"] <- "time"
}

pk_plot <- ggplot(sim_data, aes(x = time, y = y)) +
  geom_line(color = "#ff69b4", size = 1.2) + 
  labs(
    title = "Pharmacokinetic modeling (1-compartment oral model)",
    x = "Time (hours)",
    y = "Drug concentration in plasma (mg/L)"
  ) +
  theme_minimal()


print(pk_plot)


ggsave("pk_simulation_plot.png", plot = pk_plot, width = 8, height = 5)


