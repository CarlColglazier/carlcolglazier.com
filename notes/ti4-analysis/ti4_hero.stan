data {
  int<lower=1> E;  // number of games
  int<lower=1> P;  // number of factions
  int<lower=1, upper=P> players[E, 6];
  int<lower=0, upper=1> hero_purged[E, 6];
  int<lower=0, upper=1> hero_unlocked[E, 6];
  int<lower=0, upper=1> can_purge[E, 6];
  int<lower=1, upper=6> winner[E];
}
parameters {
  vector[P] raw_ability;
  vector[P] hero_effect;
  real unlock_effect;
}
transformed parameters {
  vector[P] ability;
  ability = raw_ability - mean(raw_ability);
}
model {
  raw_ability ~ normal(0, 1);
  hero_effect ~ normal(0, 1);
  unlock_effect ~ normal(0, 1);

  for (e in 1:E) {
    vector[6] logit_p;
    for (k in 1:6) {
      int p_id = players[e, k];
      real h_effect = 0;
      if (can_purge[e, k] == 1) {
        h_effect = hero_effect[p_id] * (hero_purged[e, k] - 0.5);
      }
      logit_p[k] = ability[p_id]
                 + h_effect
                 + unlock_effect * hero_unlocked[e, k];
    }
    winner[e] ~ categorical_logit(logit_p);
  }
}
