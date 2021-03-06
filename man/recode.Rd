% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/recode.R
\docType{data}
\name{recode}
\alias{recode}
\alias{rec}
\alias{if_val}
\alias{recode<-}
\alias{if_val<-}
\alias{rec<-}
\alias{ifs}
\alias{lo}
\alias{hi}
\alias{copy}
\alias{from_to}
\alias{\%into\%}
\title{Change, rearrange or consolidate the values of an existing or new variable. Inspired by the RECODE command from SPSS.}
\format{An object of class \code{numeric} of length 1.}
\usage{
recode(
  x,
  ...,
  with_labels = FALSE,
  new_label = c("all", "range", "first", "last")
)

rec(x, ..., with_labels = TRUE, new_label = c("all", "range", "first", "last"))

recode(x, with_labels = FALSE, new_label = c("all", "range", "first", "last")) <- value

rec(x, with_labels = TRUE, new_label = c("all", "range", "first", "last")) <- value

ifs(...)

lo

hi

copy(x)

from_to(from, to)

values \%into\% names
}
\arguments{
\item{x}{vector/matrix/data.frame/list}

\item{...}{sequence of formulas which describe recodings. They are used when
\code{from}/\code{to} arguments are not provided.}

\item{with_labels}{logical. FALSE by default for 'recode' and TRUE for 'rec'.
Should we also recode value labels with the same recodings as variable?}

\item{new_label}{one of "all", "range", "first", or "last". If we recode
value labels ('with_labels = TRUE') how we will combine labels for
duplicated values? "all" will use all labels, "range" will use first and
last labels. See examples.}

\item{value}{list with formulas which describe recodings in assignment form
of function/\code{to} list if \code{from}/\code{to} notation is used.}

\item{from}{list of conditions for values which should be recoded (in the
same format as LHS of formulas).}

\item{to}{list of values into which old values should be recoded (in the same
format as RHS of formulas).}

\item{values}{object(-s) which will be assigned to \code{names} for 
\code{\%into\%} operation. \code{\%into\%} supports multivalue assignments.
See examples.}

\item{names}{name(-s) which will be given to \code{values} expression. For 
\code{\%into\%}.}
}
\value{
object of the same form as \code{x} with recoded values
}
\description{
\code{recode} change, rearrange or consolidate the values of an existing 
variable based on conditions. Design of this function inspired by RECODE from
SPSS. Sequence of recodings provided in the form of formulas. For example, 
1:2 ~ 1 means that all 1's and 2's will be replaced with 1. Each value will be
recoded only once. In the assignment form \code{recode(...) = ...} of this 
function values which doesn't meet any condition remain unchanged. In case of
the usual form \code{... = recode(...)} values which doesn't meet any 
condition will be replaced with NA. One can use values or more sophisticated
logical conditions and functions as a condition. There are several special 
functions for usage as criteria - for details see \link{criteria}. Simple 
common usage looks like: \code{recode(x, 1:2 ~ -1, 3 ~ 0, 1:2 ~ 1, 99 ~ NA)}.
For more information, see details and examples.
The \code{ifs} function checks whether one or more conditions are met and
returns a value that corresponds to the first TRUE condition. \code{ifs} can
take the place of multiple nested \code{ifelse} statements and is much
easier to read with multiple conditions. \code{ifs} works in the same manner
as \code{recode} - e. g. with formulas. But conditions
should be only logical and it doesn't operate on multicolumn objects.
}
\details{
Input conditions - possible values for left-hand side (LHS) of formula or
element of \code{from} list:
\itemize{
\item{vector/single value}{ All values in \code{x} which equal to elements of the
vector in LHS will be replaced with RHS.}
\item{logical vector}{ All elements in \code{x} for which elements of vector
in LHS is TRUE will be replaced with RHS. It means you can use logical
condition on the other variable during recoding.}
\item{function}{ Values for which function gives TRUE will be replaced with 
RHS. There are some special functions for the convenience - see \link{criteria}}.
\item{single logical value \code{TRUE}}{ It means all other unrecoded values
(ELSE in SPSS RECODE). All other unrecoded values will be changed to RHS of the
formula or appropriate element of \code{to}.} 
}
Output values - possible values for right-hand side (RHS) of formula or
element of \code{to} list:
\itemize{
\item{value}{ replace elements of \code{x}. This value will be
recycled across rows and columns of \code{x}.}
\item{vector}{ values of this vector will replace values in the corresponding
position in rows of \code{x}. Vector will be recycled across columns of
\code{x}.}
\item{function}{ This function will be applied to values of \code{x} which 
satisfy recoding condition. There is a special auxiliary function \code{copy} 
which just returns its argument. So, in the \code{recode} it just copies old 
value (COPY in SPSS RECODE).  See examples.}}
\code{\%into\%} tries to mimic SPSS 'INTO'. Values from left-hand side will 
be assigned to right-hand side. You can use \code{\%to\%} expression in the 
RHS of \code{\%into\%}. See examples. 
\code{lo} and \code{hi} are shortcuts for \code{-Inf} and \code{Inf}. They
can be useful in expressions with \code{\%thru\%}, e. g. \code{1 \%thru\%
hi}.
}
\examples{
# some examples from SPSS manual
# RECODE V1 TO V3 (0=1) (1=0) (2, 3=-1) (9=9) (ELSE=SYSMIS)
v1  = c(0, 1, 2, 3, 9, 10)
recode(v1) = c(0 ~ 1, 1 ~ 0, 2:3 ~ -1, 9 ~ 9, TRUE ~ NA)
v1

# RECODE QVAR(1 THRU 5=1)(6 THRU 10=2)(11 THRU HI=3)(ELSE=0).
qvar = c(1:20, 97, NA, NA)
recode(qvar, 1 \%thru\% 5 ~ 1, 6 \%thru\% 10 ~ 2, 11 \%thru\% hi ~ 3, TRUE ~ 0)
# the same result
recode(qvar, 1 \%thru\% 5 ~ 1, 6 \%thru\% 10 ~ 2, ge(11) ~ 3, TRUE ~ 0)

# RECODE STRNGVAR ('A', 'B', 'C'='A')('D', 'E', 'F'='B')(ELSE=' '). 
strngvar = LETTERS
recode(strngvar, c('A', 'B', 'C') ~ 'A', c('D', 'E', 'F') ~ 'B', TRUE ~ ' ')

# recode in place. Note that we recode only first six letters
recode(strngvar) = c(c('A', 'B', 'C') ~ 'A', c('D', 'E', 'F') ~ 'B')
strngvar

# RECODE AGE (MISSING=9) (18 THRU HI=1) (0 THRU 18=0) INTO VOTER. 
age = c(NA, 2:40, NA)
voter = recode(age, NA ~ 9, 18 \%thru\% hi ~ 1, 0 \%thru\% 18 ~ 0)
voter
# the same result with '\%into\%'
recode(age, NA ~ 9, 18 \%thru\% hi ~ 1, 0 \%thru\% 18 ~ 0) \%into\% voter2
voter2
# recode with adding labels
voter = recode(age, "Refuse to answer" = NA ~ 9, 
                    "Vote" = 18 \%thru\% hi ~ 1, 
                    "Don't vote" = 0 \%thru\% 18 ~ 0)
voter

# recoding with labels
ol = c(1:7, 99)
var_lab(ol) = "Liking"
val_lab(ol)  = num_lab("
                     1 Disgusting
                     2 Very Poor
                     3 Poor
                     4 So-so
                     5 Good
                     6 Very good
                     7 Excellent
                     99 Hard to say
                     ")

recode(ol, 1:3 ~ 1, 5:7 ~ 7, TRUE ~ copy, with_labels = TRUE)
# 'rec' is a shortcut for recoding with labels. Same result: 
rec(ol, 1:3 ~ 1, 5:7 ~ 7, TRUE ~ copy)
# another method of combining labels
recode(ol, 1:3 ~ 1, 5:7 ~ 7, TRUE ~ copy, with_labels = TRUE, new_label = "range")
# example with from/to notation
# RECODE QVAR(1 THRU 5=1)(6 THRU 10=2)(11 THRU HI=3)(ELSE=0).
list_from = list(1 \%thru\% 5, 6 \%thru\% 10, ge(11), TRUE)
list_to = list(1, 2, 3, 0)
recode(qvar, from_to(list_from, list_to))


list_from = list(NA, 18 \%thru\% hi, 0 \%thru\% 18)
list_to = list("Refuse to answer" = 9, "Vote" = 1, "Don't vote" = 0)
voter = recode(age, from_to(list_from, list_to))
voter

# 'ifs' examples
a = 1:5
b = 5:1
ifs(b>3 ~ 1)                       # c(1, 1, NA, NA, NA)
ifs(b>3 ~ 1, TRUE ~ 3)             # c(1, 1, 3, 3, 3)
ifs(b>3 ~ 1, a>4 ~ 7, TRUE ~ 3)    # c(1, 1, 3, 3, 7)
ifs(b>3 ~ a, TRUE ~ 42)            # c(1, 2, 42, 42, 42)

# advanced usage
#' # multiple assignment with '\%into\%'
set.seed(123)
x1 = runif(30)
x2 = runif(30)
x3 = runif(30)
# note nessesary brackets around RHS of '\%into\%'
recode(x1 \%to\% x3, gt(0.5) ~ 1, other ~ 0) \%into\% (x_rec_1 \%to\% x_rec_3)
fre(x_rec_1)
# the same operation with characters expansion
i = 1:3
recode(x1 \%to\% x3, gt(0.5) ~ 1, other ~ 0) \%into\% text_expand('x_rec2_{i}')
fre(x_rec2_1)

# factor recoding
a = factor(letters[1:4])
recode(a, "a" ~ "z", TRUE ~ copy) # we get factor

# example with function in RHS
data(iris)
new_iris = recode(iris, is.numeric ~ scale, other ~ copy)
str(new_iris)

set.seed(123)
a = rnorm(20)
# if a<(-0.5) we change it to absolute value of a (abs function)
recode(a, lt(-0.5) ~ abs, other ~ copy) 

# the same example with logical criteria
recode(a, a<(-.5) ~ abs, other ~ copy) 
}
\keyword{datasets}
