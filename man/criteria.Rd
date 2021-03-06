% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/criteria_functions.R
\name{criteria}
\alias{criteria}
\alias{as.criterion}
\alias{equals}
\alias{eq}
\alias{not_equals}
\alias{ne}
\alias{neq}
\alias{less}
\alias{lt}
\alias{less_or_equal}
\alias{le}
\alias{lte}
\alias{greater}
\alias{gt}
\alias{greater_or_equal}
\alias{ge}
\alias{gte}
\alias{thru}
\alias{\%thru\%}
\alias{is_max}
\alias{is_min}
\alias{contains}
\alias{like}
\alias{fixed}
\alias{perl}
\alias{regex}
\alias{has_label}
\alias{from}
\alias{to}
\alias{items}
\alias{not_na}
\alias{other}
\alias{and}
\alias{or}
\alias{not}
\title{Criteria functions}
\usage{
as.criterion(crit)

equals(x)

not_equals(x)

less(x)

less_or_equal(x)

greater(x)

greater_or_equal(x)

thru(lower, upper)

lower \%thru\% upper

is_max(x)

is_min(x)

contains(
  pattern,
  ignore.case = FALSE,
  perl = FALSE,
  fixed = TRUE,
  useBytes = FALSE
)

like(pattern)

fixed(
  pattern,
  ignore.case = FALSE,
  perl = FALSE,
  fixed = TRUE,
  useBytes = FALSE
)

perl(
  pattern,
  ignore.case = FALSE,
  perl = TRUE,
  fixed = FALSE,
  useBytes = FALSE
)

regex(
  pattern,
  ignore.case = FALSE,
  perl = FALSE,
  fixed = FALSE,
  useBytes = FALSE
)

has_label(x)

from(x)

to(x)

items(...)

not_na(x)

other(x)

and(...)

or(...)

not()
}
\arguments{
\item{crit}{vector of values/function which returns logical or vector. It will be
converted to function of class criterion.}

\item{x}{vector}

\item{lower}{vector/single value - lower bound of interval}

\item{upper}{vector/single value - upper bound of interval}

\item{pattern}{character string containing a regular expression (or character
string for \code{'fixed'}) to be matched in the given character vector.
Coerced by as.character to a character string if possible.}

\item{ignore.case}{logical see \link[base]{grepl}}

\item{perl}{logical see \link[base]{grepl}}

\item{fixed}{logical see \link[base]{grepl}}

\item{useBytes}{logical see \link[base]{grepl}}

\item{...}{numeric indexes of desired items for items, logical vectors or criteria for boolean functions.}
}
\value{
function of class 'criterion' which tests its argument against
  condition and return logical value
}
\description{
Produce criteria which could be used in the different situations - see
'\link{recode}', '\link{na_if}', '\link{count_if}', '\link{match_row}',
'\link{\%i\%}' and etc. For example, \code{'greater(5)'} returns function
which tests whether its argument greater than five. \code{'fixed("apple")'}
returns function which tests whether its argument contains "apple". For
criteria logical operations (|, &, !, xor) are defined, e. g. you can write
something like: \code{'greater(5) | equals(1)'}.
List of functions:
\itemize{
\item{comparison criteria - \code{'equals'}, \code{'greater'} and etc.}{ return
functions which compare its argument against value.}
\item{\code{'thru'}}{ checks whether a value is inside interval.
\code{'thru(0,1)'} is equivalent to \code{'x>=0 & x<=1'}}
\item{\code{'\%thru\%'}}{ is infix version of \code{'thru'}, e. g. \code{'0
\%thru\% 1'}}
\item{\code{'is_max'} and \code{'is_min'}}{ return TRUE where vector value is
equals to maximum or minimum.}
\item{\code{'contains'}}{ searches for the pattern in the strings. By default,
it works with fixed patterns rather than regular expressions. For details
about its arguments see \link[base]{grepl}}
\item{\code{'like'}}{ searches for the Excel-style pattern in the strings. You
can use wildcards: '*' means any number of symbols, '?' means single symbol.
Case insensitive.}
\item{\code{'fixed'}}{ alias for contains.}
\item{\code{'perl'}}{ such as \code{'contains'} but the pattern is perl-compatible
regular expression (\code{'perl = TRUE'}). For details see \link[base]{grepl}}
\item{\code{'regex'}}{ use POSIX 1003.2 extended regular expressions
(\code{'fixed = FALSE'}). For details see \link[base]{grepl}}
\item{\code{'has_label'}}{ searches values which have supplied label(-s).  We
can used criteria as an argument for 'has_label'.}
\item{\code{'to'}}{ returns function which gives TRUE for all elements of
vector before the first occurrence of \code{'x'} and for  \code{'x'}.}
\item{\code{'from'}}{ returns function which gives TRUE for all elements of 
vector after the first occurrence of \code{'x'} and for \code{'x'}.}
\item{\code{'not_na'}}{ returns TRUE for all non-NA vector elements.} 
\item{\code{'other'}}{ returns TRUE for all vector elements. It is intended
for usage with \code{'recode'}.}
\item{\code{'items'}}{ returns TRUE for the vector elements with the given
sequential numbers.}
\item{\code{'and'}, \code{'or'}, \code{'not'}}{ spreadsheet-style boolean functions.}
} 
Shortcuts for comparison criteria:
\itemize{
\item{'equals'}{ - \code{'eq'}}
\item{'not_equals'}{ - \code{'neq'}, \code{'ne'}}
\item{'greater'}{ - \code{'gt'}}
\item{'greater_or_equal'}{ - \code{'gte'}, \code{'ge'}}
\item{'less'}{ - \code{'lt'}}
\item{'less_or_equal'}{ - \code{'lte'}, \code{'le'}}
}
}
\examples{
# operations on vector, '\%d\%' means 'diff'
1:6 \%d\% greater(4) # 1:4
1:6 \%d\% (1 | greater(4)) # 2:4
# '\%i\%' means 'intersect
1:6 \%i\% (is_min() | is_max()) # 1, 6
# with Excel-style boolean operators
1:6 \%i\% or(is_min(), is_max()) # 1, 6

letters \%i\% (contains("a") | contains("z")) # a, z

letters \%i\% perl("a|z") # a, z

letters \%i\% from("w")  # w, x, y, z

letters \%i\% to("c")  # a, b, c

letters \%i\% (from("b") & to("e"))  # b, d, e

c(1, 2, NA, 3) \%i\% not_na() # c(1, 2, 3)

# examples with count_if
df1 = data.frame(
    a=c("apples", "oranges", "peaches", "apples"),
    b = c(32, 54, 75, 86)
)

count_if(greater(55), df1$b) # greater than 55 = 2

count_if(not_equals(75), df1$b) # not equals 75 = 3

count_if(greater(32) & less(86), df1$b) # greater than 32 and less than 86 = 2
count_if(and(greater(32), less(86)), df1$b) # the same result

# infix version
count_if(35 \%thru\% 80, df1$b) # greater than or equals to 35 and less than or equals to 80 = 2

# values that started on 'a'
count_if(like("a*"), df1) # 2

# the same with Perl-style regular expression
count_if(perl("^a"), df1) # 2

# count_row_if
count_row_if(perl("^a"), df1) # c(1,0,0,1)

# examples with 'n_intersect' and 'n_diff'
data(iris)
iris \%>\% n_intersect(to("Petal.Width")) # all columns up to 'Species' 
 
# 'Sepal.Length', 'Sepal.Width' will be left 
iris \%>\% n_diff(from("Petal.Length"))

# except first column
iris \%n_d\% items(1)

# 'recode' examples
qvar = c(1:20, 97, NA, NA)
recode(qvar, 1 \%thru\% 5 ~ 1, 6 \%thru\% 10 ~ 2, 11 \%thru\% hi ~ 3, other ~ 0)
# the same result
recode(qvar, 1 \%thru\% 5 ~ 1, 6 \%thru\% 10 ~ 2, greater_or_equal(11) ~ 3, other ~ 0)


}
\seealso{
\link{recode}, \link{count_if},
  \link{match_row}, \link{na_if}, \link{\%i\%}
}
