% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{dcca}
\alias{dcca}
\title{Detrended Cross-Correlation Analysis}
\usage{
dcca(x, y, order, scales)
}
\arguments{
\item{x}{A real valued vector (i.e., time series data) to be analyzed.}

\item{y}{A real valued vector (i.e., time series data) to be analyzed.}

\item{order}{is an integer indicating the polynomial order used for 
detrending the local windows (e.g, 1 = linear, 2 = quadratic, etc.). There 
is not a pre-determined limit on the order of the polynomial order but the 
user should avoid using a large polynomial on small windows. This can result
in overfitting and non-meaningful estimates.}

\item{scales}{An integer vector of scales over which to compute correlation. 
Unlike univariate DFA, MRA does not require that scales be in log units.
Scale intervals can be sequential, for example, when the analysis is 
exploratory and no a priori hypotheses have been made about the scale of 
correlation. A small subset of targeted scales may also be investigated 
where scale-specific research questions exist. We have found that windows
smaller than say 8 observations create stability problems due to 
overfitting. This is espcially when the order of the fitting polynomial is 
large.}
}
\value{
The object returned from the function is a list including the following:
\itemize{ 
 \item \code{scales} indicates the values of the scales used for estimates \eqn{\rho}DCCA
 \item \code{rho} includes the scale-wise estimates of \eqn{\rho}DCCA
}
}
\description{
Fast function for computing detrended cross-correlation analysis (DCCA) on long time series, which is a 
bivariate extension of detrended fluctuation analysis (DFA).
}
\details{
Details of the algorithm are specified in Podobnik and Stanley (2008) and in Zebende (2011).
In general, the output of the algorithm are estimates of \eqn{\rho}DCCA, which range from -1 to 1 and can generally be interpreted as follows: 
\itemize{
 \item \eqn{\rho DCCA = -1.0 ->} perfect anti-cross-correlation
 \item \eqn{\rho DCCA =  0.0 ->} no cross-correlation
 \item \eqn{\rho DCCA =  1.0 ->} perfect cross-correlation
}
}
\examples{



# Here is a simple example for running DCCA using a white noise and pink noise time series.
# For more detailed examples, see the vignette. 

noise <- rnorm(5000)

pink.noise <- fgn_sim(n = 5000, H = 0.9)

scales <- logscale(scale_min = 10, scale_max = 1250, scale_ratio = 1.1)

dcca.out <- dcca(noise, pink.noise, order = 1, scales = scales)



}
\references{
Podobnik, B., & Stanley, H. E. (2008). Detrended cross-correlation analysis: a new method for analyzing two nonstationary time series. Physical review letters, 100(8), 084102.

Zebende, G. F. (2011). DCCA cross-correlation coefficient: Quantifying level of cross-correlation. Physica A: Statistical Mechanics and its Applications, 390(4), 614-618.

//'
}
