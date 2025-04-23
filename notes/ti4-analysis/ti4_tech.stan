data {
  int<lower=1> N;               // number of players
  int<lower=1> F;               // number of factions
  int<lower=1> J;               // number of techs
  int<lower=1, upper=F> faction_id[N]; // player factions
  int<lower=0, upper=1> win[N];       // win outcome
  int<lower=0, upper=1> tech[N, J];   // tech matrix
}

parameters {
  real alpha;
  vector[F] beta;                // faction strengths

  vector[J] mu;                  // global tech effects
  matrix[F, J] gamma_raw;        // faction-specific deviations
  real<lower=0> sigma_tech;      // SD of tech effects
}

transformed parameters {
  matrix[F, J] gamma;
  gamma = rep_matrix(mu', F) + gamma_raw .* sigma_tech;
}

model {
  alpha ~ normal(0, 1);
  beta ~ normal(0, 1);
  mu ~ normal(0, 1);
  to_vector(gamma_raw) ~ normal(0, 1);
  sigma_tech ~ exponential(1);

  for (n in 1:N) {
    int f = faction_id[n];
    vector[J] tech_row = to_vector(tech[n]);
    real tech_effect = dot_product(tech_row, gamma[f]');
    win[n] ~ bernoulli_logit(alpha + beta[f] + tech_effect);
  }
}
