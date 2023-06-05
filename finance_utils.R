monthly_payment <- function(
    principal,
    annual_interest_rate,
    number_of_months
) {
  r = annual_interest_rate / 12
  p = principal
  n = number_of_months
  a = p * ((r * ((1 + r) ^ n)) / (((1 + r) ^ n) - 1))
  a
}

monthly_payment_per_1k <- function(
    annual_interest_rate,
    number_of_months
) {
  monthly_payment(1000, annual_interest_rate, number_of_months)
}

amount_financed <- function(
    given_monthly_payment,
    annual_interest_rate,
    number_of_months
) {
  mpp1k = monthly_payment_per_1k(
    annual_interest_rate,
    number_of_months
  )
  1000 * (given_monthly_payment / mpp1k)
}

amortized_loan_formula <- function(
    principal,
    interest_rate,
    years,
    compoundings_per_year
  ) {
  p = principal
  r = interest_rate
  t = years
  n = compoundings_per_year
  tn = t * n
  ron = r / n
  ronp1 = 1 + ron
  ronp1tn = ronp1 ^ tn
  p * (ron * ronp1tn) / (ronp1tn - 1)
}
