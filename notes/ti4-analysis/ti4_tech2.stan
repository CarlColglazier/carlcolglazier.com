data {
  int<lower=1> E;                      // number of events
  int<lower=1> P;                      // number of players
  int<lower=1> T;                      // number of techs
  int<lower=1, upper=P> players[E, 6]; // player IDs per event
  int<lower=1, upper=6> winner[E];     // winner index (1-6)
  matrix[E * 6, T] tech_matrix;        // binary matrix: 1 if player has tech
  real<lower=0> lasso_scale;           // Laplace scale (lambda)
  vector[P] prior_ability;             // optional prior means for ability
  real<lower=0> ability_sd;            // prior SD for ability (normally 1)
}
parameters {
  vector[P] ability;
  vector[T] tech_effect;
}
model {
  // Priors
  ability ~ normal(prior_ability, ability_sd);
  tech_effect ~ double_exponential(0, lasso_scale);

  // Likelihood
  for (e in 1:E) {
    vector[6] logit_p;
    for (k in 1:6) {
      int p_idx = players[e, k];
      int global_idx = (e - 1) * 6 + k;
      logit_p[k] = ability[p_idx] + dot_product(tech_matrix[global_idx], tech_effect);
    }
    winner[e] ~ categorical_logit(logit_p);
  }
}
