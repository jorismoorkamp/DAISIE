# DAISIE

Branch|[Travis](https://travis-ci.org)|[Codecov](https://www.codecov.io)
---|---|---
`master`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=master)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=master)](https://codecov.io/github/rsetienne/DAISIE/branch/master)
`develop`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=develop)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=develop)](https://codecov.io/github/rsetienne/DAISIE/branch/develop)
`richel_mainland_extinction`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=richel_mainland_extinction)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=richel_mainland_extinction)](https://codecov.io/github/rsetienne/DAISIE/branch/richel_mainland_extinction)
`pedro_ontogeny`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=pedro_ontogeny)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=pedro_ontogeny)](https://codecov.io/github/rsetienne/DAISIE/branch/pedro_ontogeny)
`sebastian_archipelago`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=sebastian_archipelago)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=sebastian_archipelago)](https://codecov.io/github/rsetienne/DAISIE/branch/sebastian_archipelago)
`shu_traits`|[![Build Status](https://travis-ci.org/rsetienne/DAISIE.svg?branch=shu_traits)](https://travis-ci.org/rsetienne/DAISIE)|[![codecov.io](https://codecov.io/github/rsetienne/DAISIE/coverage.svg?branch=shu_traits)](https://codecov.io/github/rsetienne/DAISIE/branch/shu_traits)

Dynamic Assembly of Island biota through Speciation, Immigration and Extinction in R

This is a development version before the official release on CRAN.

## Installing DAISIE

The DAISIE package has a stable version on CRAN and
a development version on GitHub.

### From CRAN

From within R, do:

```
install.packages("DAISIE")
```

### From GitHub

Because the DAISIE package is located in the folder `DAISIE`, do:

```
devtools::install_github("rsetienne/DAISIE")
```

## Using DAISIE as a package dependency

### From CRAN

To your DESCRIPTION file, add `DAISIE` as any normal package.

If your package directly uses `DAISIE`:

```
Imports:
  DAISIE
```

If your package uses `DAISIE` in its perepherals (e.g. vignettes and tests):

```
Suggests:
  DAISIE
```

### From GitHub

```
Remotes:
  rsetienne/DAISIE
```

## `git` branching model

 * `master`: build should always pass. @rsetienne has control over `develop` to `master` merges.
 * `develop`: merge of topic branches, merge with `master` by @rsetienne iff build passes.
 * `pedro_ontogeny`: @Neves-P's topic branch adding island ontongeny functionality for simulation and parameter estimation.
 * `richel_mainland_extinction`: @richelbilderbeek's topic branch adding dynamic mainland processes.
 * `shu_traits`: @xieshu95's topic branch adding lineage trait functionality
 * `sebastian_archipelago`: Sebastian Mader's topic branch adding archipelago dynamics to DAISIE in C++
 
@Neves-P is responsible for day-to-day merging and repository maintenance. For questions open an issue or contact @Neves-P.
