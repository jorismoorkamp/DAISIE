#' Internal function of the DAISIE simulation
#' @param time Simulated amount of time
#' @param mainland_n A numeric stating the number of mainland species, that
#'   is, the number of species that can potentially colonize the island.
#'   If \code{\link{DAISIE_sim}} uses a clade-specific diversity dependence,
#'   this value is set to 1. 
#'   If \code{\link{DAISIE_sim}} uses an island-specific diversity dependence,
#'   this value is set to the number of mainland species.
#' @param pars A numeric vector:
#' \itemize{
#'   \item{[1]: cladogenesis rate}
#'   \item{[2]: extinction rate}
#'   \item{[3]: carrying capacity}
#'   \item{[4]: immigration rate}
#'   \item{[5]: anagenesis rate}
#' }
#' @param Apars A named list containing area parameters as created by create_area_params:
#' \itemize{
#'   \item{[1]: maximum area}
#'   \item{[2]: value from 0 to 1 indicating where in the island's history the 
#'   peak area is achieved}
#'   \item{[3]: sharpness of peak}
#'   \item{[4]: total island age}
#' }
#' @param Epars A numeric vector:
#' \itemize{
#'   \item{[1]: minimum extinction when area is at peak}
#'   \item{[2]: extinction rate when current area is 0.10 of maximum area}
#' }
#' @param island_ontogeny A string describing the type of island ontogeny. Can be \code{"const"},
#' \code{"beta"} for a beta function describing area through time,
#'  or \code{"linear"} for a linear function
DAISIE_sim_with_ontogeny <- function(
  time,
  mainland_n,
  pars,
  Apars = NULL,
  Epars = NULL,
  island_ontogeny = "const"
) {
  testit::assert(length(pars) == 5)
  testit::assert(is.null(Apars) || are_area_params(Apars))
  
  if (pars[4] == 0) {
    stop('Rate of colonisation is zero. Island cannot be colonised.')
  }  
  
  if (!is.null(Apars) && island_ontogeny == 0) {
    stop("Apars specified for constant island_ontogeny. Set Apars to NULL.")
  }
  
  if ((is.null(Epars) || is.null(Apars)) && island_ontogeny != "const") {
    stop("Island ontogeny specified but Area parameters and/or extinction 
         parameters not available. Please either set island_ontogeny to NULL, or 
         specify Apars and Epars.")
  }
  
  testit::assert(DAISIE::is_island_ontogeny_input(island_ontogeny))
  
  timeval <- 0
  totaltime <- time
  lac <- pars[1]
  mu <- pars[2]
  K <- pars[3]
  gam <- pars[4]
  laa <- pars[5]
  extcutoff <- max(1000, 1000 * (laa + lac + gam))
  testit::assert(is.numeric(extcutoff))
  ext_multiplier <- 0.5
  testit::assert((totaltime <= Apars$total_island_age) || is.null(Apars))
  
  
  mainland_spec <- seq(1, mainland_n, 1)
  maxspecID <- mainland_n
  
  island_spec = c()
  stt_table <- matrix(ncol = 4)
  colnames(stt_table) <- c("Time","nI","nA","nC")
  stt_table[1,] <- c(totaltime,0,0,0)
  testit::assert(is.null(Apars) || are_area_params(Apars))
  # Pick t_hor (before timeval, to set Amax t_hor)
  t_hor <- get_t_hor(
    timeval = 0,
    totaltime = totaltime,
    Apars = Apars,
    ext = 0,
    ext_multiplier = ext_multiplier,
    island_ontogeny = island_ontogeny, 
    t_hor = NULL
  )
  #### Start Gillespie ####
  while (timeval < totaltime) {
    # Calculate rates
    rates <- update_rates(timeval = timeval,
                          totaltime = totaltime,
                          gam = gam,
                          mu = mu,
                          laa = laa,
                          lac = lac,
                          Apars = Apars,
                          Epars = Epars,
                          island_ontogeny = island_ontogeny,
                          extcutoff = extcutoff,
                          K = K,
                          island_spec = island_spec,
                          mainland_n = mainland_n,
                          t_hor = t_hor)
    
    timeval_and_dt <- calc_next_timeval(rates, timeval)
    timeval <- timeval_and_dt$timeval
    dt <- timeval_and_dt$dt
    
    if (timeval <= t_hor) {
      testit::assert(are_rates(rates))
      
      # Determine event
      possible_event <- DAISIE_sample_event(
        rates = rates,
        island_ontogeny = island_ontogeny
      )
      
      updated_state <- DAISIE_sim_update_state(
        timeval = timeval, 
        totaltime = totaltime,
        possible_event = possible_event,
        maxspecID = maxspecID,
        mainland_spec = mainland_spec,
        island_spec = island_spec,
        stt_table = stt_table
      )
      
      island_spec <- updated_state$island_spec
      maxspecID <- updated_state$maxspecID
      stt_table <- updated_state$stt_table
    } else {
      #### After t_hor is reached ####
      
      timeval <- t_hor
      t_hor <- get_t_hor(
        timeval = timeval,
        totaltime = totaltime,
        Apars = Apars,
        ext = rates$ext_rate,
        ext_multiplier = ext_multiplier,
        island_ontogeny = island_ontogeny
      )
    }
    # TODO Check if this is redundant, or a good idea
    if (rates$ext_rate_max >= extcutoff && length(island_spec[,1]) == 0) {
      timeval <- totaltime
    }
  }
  #### Finalize stt_table ####
  stt_table <- rbind(stt_table, 
                     c(0, 
                       stt_table[nrow(stt_table), 2],
                       stt_table[nrow(stt_table), 3],
                       stt_table[nrow(stt_table), 4]))
  
  island <- DAISIE_create_island(stt_table = stt_table,
                                 totaltime = totaltime,
                                 island_spec = island_spec,
                                 mainland_n = mainland_n)
  return(island)
}