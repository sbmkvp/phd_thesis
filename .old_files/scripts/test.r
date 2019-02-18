#! /usr/local/bin/Rscript

library(xtable)
data <- data.frame(x = c("a", "b"), y = c(1, 2))
print(xtable(data, type="latex"), include.rownames = FALSE)
