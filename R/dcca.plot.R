#' Detrended Cross Correlation Plot
#' 
#' A plotting method for constructing scalewise correlation plot
#' @param rhos an object containing  results from detrended cross correlation
#' analysis. The object should be returned from the \code{dcca} function of this
#' package.
#' @param order integer representing the detrending order used in the dcca 
#' calculation. Default is 1.
#' @param ci a logical indicating whether confidence intervals should be 
#' computed using the \code{iaafft} function from this package. NOTE: with long 
#' time series (>> than N = 1,000), this can greatly reduce processing speed. 
#' Confidence intervals can be used for conventional significance testing of 
#' scale-wise correlation coefficients.
#' @param iterations integer that specifies the the number of surrogate time 
#' series to be generated for the purpose of confidence intervals. 
#' Default = 19. Larger number of surrogates will slow computational speed but
#' produce better confidence interval estimates.
#' @param return.ci logical indicating whether the confidence intervals 
#' should be returned
#' @param loess.rho logical indicating whether a loess fit should be used for 
#' displaying multiscale regression coefficient trajectories
#' @param loess.ci logical indicating whether a loess fit should be used to smooth 
#' confidence intervals
#' @export
dcca.plot = function(rhos, order = 1, ci = FALSE, iterations = NULL,
                     return.ci = FALSE, loess.rho = FALSE, loess.ci = FALSE){
  # initialize y plot range to ensure visible in loop and control scopes
  ymin = 0
  ymax = 0
  
  # store default plot settings
  op = par(no.readonly = TRUE)
  
  #modify margines and text size
  par(mar = c(5,5,.5,1),
      cex.lab = 1.5,
      cex.axis = 1.5)
  
  
  if (ci){
    if (is.null(iterations)) {
      # for 95% confidence limit
      iterations = 19
    }
    
    # compute surrogate time series for x and y
    x.surr = iaafft(rhos$x, iterations)
    y.surr = iaafft(rhos$y, iterations)
    ci.rhos = matrix(NA, nrow = iterations, ncol = length(rhos$rho))
    cis = matrix(NA, nrow = 2, ncol = length(rhos$scales))
    
    # perform dcca on each surrogagte
    for (i in 1:iterations){
      temp.x = as.vector(x.surr[,i])
      temp.y = as.vector(y.surr[,i])
      ci.rhos[i,] = dcca(x.surr[,i], y.surr[,i], order = order, 
                            scales = rhos$scales)$rho
    }
    
    # compute 95% confidence intervals
    for (i in 1:length(rhos$scales)){
      
      cis[,i] = quantile(ci.rhos[,i], c(0.025, 0.9725))
    }
    ymin = min(min(ci.rhos), min(rhos$rho))
    ymax = max(max(ci.rhos), max(rhos$rho))
    if (loess.ci & !loess.rho) {
      loess.upper.ci = loess(cis[1,] ~ rhos$scales)
      loess.lower.ci = loess(cis[2,] ~ rhos$scales)
      plot(rhos$scales, rhos$rho, pch = 16, type = 'b', xlab = 's',
           ylab = expression(rho(s)), ylim = c(ymin, ymax))
      lines(rhos$scales, predict(loess.upper.ci), col = 'red')
      lines(rhos$scales, predict(loess.lower.ci), col = 'red')
      legend('topright',legend = c(expression(rho(s)),'Surrogate CI'), lty = 1,
             col = c('black', 'red'))
    }else if (!loess.ci & loess.rho){
      loess.rho = loess(rhos$rho ~ rhos$scales)
      plot(rhos$scales, predict(loess.rho), pch = 16, type = 'b', xlab = 's',
           ylab = expression(rho(s)), ylim = c(ymin, ymax))
      lines(rhos$scales, cis[1,], col = 'red')
      lines(rhos$scales, cis[2,], col = 'red')
      legend('topright',legend = c(expression(rho(s)),'Surrogate CI'), lty = 1,
             col = c('black', 'red'))
    }else if(loess.ci & loess.rho){
      loess.upper.ci = loess(cis[1,] ~ rhos$scales)
      loess.lower.ci = loess(cis[2,] ~ rhos$scales)
      loess.rho = loess(rhos$rho ~ rhos$scales)
      plot(rhos$scales, predict(loess.rho), pch = 16, type = 'b', xlab = 's',
           ylab = expression(rho(s)), ylim = c(ymin, ymax))
      lines(rhos$scales, predict(loess.upper.ci), col = 'red')
      lines(rhos$scales, predict(loess.lower.ci), col = 'red')
      legend('topright',legend = c(expression(rho(s)),'Surrogate CI'), lty = 1,
             col = c('black', 'red'))
    }else{
      plot(rhos$scales, rhos$rho, pch = 16, type = 'b', xlab = 's',
           ylab = expression(rho(s)), ylim = c(ymin, ymax))
      lines(rhos$scales, cis[1,], col = 'red')
      lines(rhos$scales, cis[2,], col = 'red')
      legend('topright',legend = c(expression(rho(s)),'Surrogate CI'), lty = 1,
             col = c('black', 'red'))
    }
  }else{
    ymin = min(rhos$rho)
    ymax = max(rhos$rho)
    plot(rhos$scales, rhos$rho, pch = 16, type = 'b', xlab = 's',
         ylab = expression(rho(s)), ylim = c(ymin, ymax))
  }
  par(op)
  if (return.ci){
    return(cis)
  }
  
}