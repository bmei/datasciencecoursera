# for question 1
base<-c(140, 138, 150, 148, 135)
wk2<-c(132, 135, 151, 146, 130)
t.test(base, wk2, paired = T)$p.value


# question 2
# A sample of 9 men yielded a sample average brain volume of 1,100cc and a standard deviation
# of 30cc. What is the complete set of values of mu0 that a test of H0: mu=mu0 would fail to reject
# the null hypothesis in a two sided 5% Students t-test?
n = 9
mn = 1100
std = 30
mn + c(-1, 1) * qt(0.975, df=n-1) * std / sqrt(n)


# question 3
# Researchers conducted a blind taste test of Coke versus Pepsi. Each of four people was asked which
# of two blinded drinks given in random order that they preferred. The data was such that 3 of the 4
# people chose Coke. Assuming that this sample is representative, report a P-value for a test of the
# hypothesis that Coke is preferred to Pepsi using a one sided exact test.
pbinom(2, size=4, prob=0.5, lower.tail=F)

# question 4
# Infection rates at a hospital above 1 infection per 100 person days at risk are believed to be too
# high and are used as a benchmark. A hospital that had previously been above the benchmark recently
# had 10 infections over the last 1,787 person days at risk. About what is the one sided P-value for
# the relevant test of whether the hospital is *below* the standard?
ppois(10, lambda = 1/100*1787, lower.tail=T)

# for question 5
n1 = 9; n2 = 9
mn1 = -3; mn2 = 1
sd1 = 1.5; sd2 = 1.8
sp <- sqrt((sd1^2/(n1-1) + sd2^2/(n2-1))/(n1 + n2 -2))
interval <- mn1 - mn2 + c(-1, 1)*qt(0.99, df=n1+n2-2)*sp*sqrt(1/n1 + 1/n2)
interval

# question 6
# Brain volumes for 9 men yielded a 90% confidence interval of 1,077 cc to 1,123 cc. Would you reject
# in a two sided 5% hypothesis test of H0: mu=1,078?
n = 9
mn = (1077 + 1123)/2
# 1123 = mn + qt(0.95, df=n-1) * std / sqrt(n)
std = (1123 - mn) / qt(0.95, df=n-1) * sqrt(n)
interval = 1078 + c(-1, 1) * qt(0.975, df=n-1) * std / sqrt(n)
interval; mn

# question 7
# Researchers would like to conduct a study of 100 healthy adults to detect a four year mean brain volume
# loss of .01 mm3. Assume that the standard deviation of four year volume loss in this population is .04 mm3.
# About what would be the power of the study for a 5% one sided test versus a null hypothesis of no volume loss?
n = 100
mn = -0.01
std = 0.04
upper <- mn + qt(0.95, df=n-1) * std / sqrt(n)
t = (upper - 0) / (std / sqrt(n))
pt(t, df=n-1, lower.tail=F)
# this problem can also be solved using normal distribution as n is big here
upper <- mn + qnorm(0.95) * std / sqrt(n)
pnorm(upper, mean=0, sd=std/sqrt(n), lower.tail=F)

# question 8
# Researchers would like to conduct a study of n healthy adults to detect a four year mean brain volume loss of
# .01 mm3. Assume that the standard deviation of four year volume loss in this population is .04 mm3. About what
# would be the value of n needded for 90% power of type one error rate of 5% one sided test versus a null hypothesis
# of no volume loss?
n = 139              # use different n to see how much the power can achieve
mn = -0.01
std = 0.04
upper <- mn + qt(0.95, df=n-1) * std / sqrt(n)
t = (upper - 0) / (std / sqrt(n))
power = pt(t, df=n-1, lower.tail=F)
power
