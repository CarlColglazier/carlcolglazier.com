data {
  int<lower=1> E;                      // number of events
  int<lower=1> P;                      // total number of players
  int<lower=1, upper=P> players[E, 6]; // player IDs per event
  int<lower=0, upper=1> took_mr[E, 6];
  int<lower=1, upper=6> winner[E];     // winner index (1-6)
  vector[P] prior_ability;             // optional prior means for ability
  real<lower=0> ability_sd;            // prior SD for ability (normally 1)
}
parameters {
  vector[P] ability;                   // faction strength
  real mecatol;
}
model {
  ability ~ normal(prior_ability, ability_sd);
  mecatol ~ normal(0, 1);

  for (e in 1:E) {
    vector[6] logit_p;
    for (k in 1:6) {
      logit_p[k] = ability[players[e, k]] + mecatol * took_mr[e,k];
    }
    winner[e] ~ categorical_logit(logit_p);
  }
}
