# Question 1
# In a population of interest, a sample of 9 men yielded a sample average brain volume of 1,100cc and a standard deviation of 30cc.
# What is a 95% Student's T confidence interval for the mean brain volume in this new population?
1100 + c(-1,1)*qt(0.975, df=9-1)*30/sqrt(9)

# Question 2
# A diet pill is given to 9 subjects over six weeks. The average difference in weight (follow up - baseline) is -2 pounds. What would
# the standard deviation of the difference in weight have to be for the upper endpoint of the 95% T confidence interval to touch 0?
2 * sqrt(9) / qt(0.975, df=8)

# Question 4
# In a study of emergency room waiting times, investigators consider a new and the standard triage systems. To test the systems, administrators
# selected 20 nights and randomly assigned the new triage system to be used on 10 nights and the standard system on the remaining 10 nights. 
# The average MWT for the new system was 3 hours with a variance of 0.60 while the average MWT for the old system was 5 hours with a
# variance of 0.68. Consider the 95% confidence interval estimate for the differences of the mean MWT associated with the new system.
# Assume a constant variance. What is the interval?
n1 <- 10; n2 <- 10
mean1 <- 3; mean2 <- 5
var1 <- 0.6; var2 <- 0.68
sp <- sqrt(((n1 - 1) * var1 + (n2 - 1) * var2) / (n1 + n2 -2))
md <- mean1 - mean2
semd <- sp * sqrt(1/n1 + 1/n2)
md + c(-1, 1) * qt(.975, n1 + n2 -2) * semd

# Question 6
# To further test the hospital triage system, administrators selected 200 nights and randomly assigned a new triage system to be used on 100 nights
# and a standard system on the remaining 100 nights. They calculated the nightly median waiting time (MWT) to see a physician. The average MWT for
# the new system was 4 hours with a standard deviation of 0.5 hours while the average MWT for the old system was 6 hours with a standard deviation 
# of 2 hours. Consider the hypothesis of a decrease in the mean MWT associated with the new treatment. What does the 95% independent group confidence
# interval with unequal variances suggest vis a vis this hypothesis? (Because there's so many observations per group, just use the Z quantile instead of the T.)
x1 <- 4; sd1 <- 0.5; n1 <- 100
x2 <- 6; sd2 <- 2; n2 <- 100
df <- (sd1^2/100 + sd2^2/100)^2 / ((sd1/n1)^2/(n1-1) + (sd2/n2)^2/(n2-1))
t_score <- qt(0.975, df)
interval <- x1 - x2 + c(-1, 1) * t_score * sqrt(sd1^2/n1 + sd2^2/n2)

# Question 7
# Suppose that 18 obese subjects were randomized, 9 each, to a new diet pill and a placebo. Subjects' body mass indices (BMIs) were measured at a baseline
# and again after having received the treatment or placebo for four weeks. The average difference from follow-up to the baseline (followup - baseline) was
# 3 kg/m2 for the treated group and 1 kg/m2 for the placebo group. The corresponding standard deviations of the differences was 1.5 kg/m2 for the treatment
# group and 1.8 kg/m2 for the placebo group. Does the change in BMI over the four week period appear to differ between the treated and placebo groups?
# Assuming normality of the underlying data and a common population variance, calculate the relevant 90% t confidence interval. Subtract in the order of 
# (Treated - Placebo) with the smaller (more negative) number first.
n1 <- 9; n2 <- 9
mean1 <- -3; mean2 <- 1
sd1 <- 1.5; sd2 <- 1.8
sp <- sqrt(((n1 - 1) * sd1^2 + (n2 - 1) * sd2^2) / (n1 + n2 -2))
md <- mean1 - mean2
semd <- sp * sqrt(1/n1 + 1/n2)
md + c(-1, 1) * qt(.95, n1 + n2 -2) * semd
