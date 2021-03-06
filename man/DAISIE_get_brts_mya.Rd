% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DAISIE_get_brts_mya.R
\name{DAISIE_get_brts_mya}
\alias{DAISIE_get_brts_mya}
\title{Extract the sorted branching times, in million years ago.
from a data table}
\usage{
DAISIE_get_brts_mya(data_table)
}
\arguments{
\item{data_table}{data table}
}
\value{
the sorted branching times, in million years ago
}
\description{
Extract the sorted branching times, in million years ago.
from a data table
}
\examples{
  data(Galapagos_datatable)
  brts_mya <- DAISIE_get_brts_mya(data_table = Galapagos_datatable)
  testit::assert(length(brts_mya) > 1)
  testit::assert(all(brts_mya > 0))
}
\author{
Richel J.C. Bilderbeek
}
