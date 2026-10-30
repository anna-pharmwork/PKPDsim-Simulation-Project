rm(list = ls())
library(PKPDsim)
library(ggplot2)


mod1 <- new_ode_model(
  code = "
    dAdt[1] = -KA * A[1];
    dAdt[2] =  KA * A[1] - (CL/V) * A[2];
  ",
  obs = list(cmt = 2, scale = "V")
)


reg1 <- new_regimen(amt = 100, n = 6, interval = 24, type = "oral")
par1 <- list(CL = 5, V = 50, KA = 1)


my_omega_vector <- c(0.1, 0.05, 0.2) 


sim_res <- sim_ode(ode = mod1,
                   regimen = reg1,
                   n = 50,
                   omega = my_omega_vector, 
                   only_obs = TRUE,
                   parameters = par1,
                   t_max = 160)


data1 <- as.data.frame(sim_res)


if ("t" %in% names(data1)) {
  names(data1)[names(data1) == "t"] <- "time"
}


pk_plot <- ggplot(data1, aes(x = time, y = y, group = id)) +
  geom_line(color = "#ff69b4",alpha = 0.4, size = 0.8) + 
  labs(
    title = "Population modeling (50 patients)",
    x = "Time (hours)",
    y = "Drug concentration in plasma (mg/L)"
  ) +
  theme_minimal()


print(pk_plot)
