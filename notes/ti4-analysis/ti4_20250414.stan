data {
  int<lower=1> E;                      // number of events
  int<lower=1> P;                      // total number of players
  int<lower=1, upper=P> players[E, 6]; // player IDs per event
  int<lower=1, upper=6> winner[E];     // winner index (1-6)
}
parameters {
  vector[P] ability;                   // faction strength
}
model {
  ability ~ normal(0, 1);             // priors

  for (e in 1:E) {
    vector[6] logit_p;
    for (k in 1:6) {
      logit_p[k] = ability[players[e, k]];
    }
    winner[e] ~ categorical_logit(logit_p);
  }
}