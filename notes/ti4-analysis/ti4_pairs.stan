data {
  int<lower=1> E;                      // number of games
  int<lower=1> P;                      // number of factions
  int<lower=1, upper=P> players[E, 6]; // faction IDs per game
  int<lower=1, upper=6> winner[E];     // index of winner (1 to 6)
}
parameters {
  vector[P] ability;                   // base ability of each faction
  matrix[P, P] interact;               // effect on i when j is present
}
model {
  ability ~ normal(0, 1);
  to_vector(interact) ~ normal(0, 0.5);

  for (e in 1:E) {
    vector[6] logit_p;
    // All factions present in game e
    int game_factions[6] = players[e];
    for (k in 1:6) {
      int f = game_factions[k]; // focal faction
      real interaction_effect = 0;
      for (j in 1:6) {
        if (j != k) {
          int g = game_factions[j];
          interaction_effect += interact[f, g];
        }
      }
      logit_p[k] = ability[f] + interaction_effect;
    }
    winner[e] ~ categorical_logit(logit_p);
  }
}
