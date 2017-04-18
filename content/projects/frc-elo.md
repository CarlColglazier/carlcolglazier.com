---
date: 2017-04-16T18:59:27-04:00
languages:
- Rust
- SQL
- HTML
source: "https://github.com/CarlColglazier/frc-elo"
title: FRC Elo
summary: "An Elo ranking system for FIRST Robotics."
---

<script type="text/javascript"
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
</script>

## Mathematics

### Rating System

An [Elo rating](https://en.wikipedia.org/wiki/Elo_rating_system) is an
estimate of a player's skill. The FRC Elo rating system makes the following
major changes from the original Elo system:

1. Using score margins instead of wins and losses for adjustments.
2. Accounting for multiple players (alliances).
3. Changing the weight based on context.
4. New teams start with a rating of `$0$` and each team is reverted to a
   mean of `$150$` while retaining `$80%$` of their rating from the last
   season.

The system works as follows.

Let `$red_r = \sum_{i=1}^n rating_i$` be the sum of the red alliance
members' ratings and `$blue_r = \sum_{j=1}^n rating_j$` be the sum of
the blue alliance members' ratings where `$n$` is the number of teams
on each alliance.

The expected win probability `$E_r$` for the red alliance is
calculated as `$$E_r = \frac{1}{1+10^{(blue_r-red_r)/400}}$$`

Let `$\sigma$` represent the standard deviation match score for a given year. The
expected score margin is `$G(E_r)$` where `$G(y)$` is the inverse of the normal
distribution which a zero mean and a standard deviation of `$\sigma$`.

The score for each team on the red alliance is adjusted after the
match according to the formula `$$\text{rating} = \text{rating} + K
\times \frac{\text{score margin} - G(E_r)}{\sigma \times L}$$` where
`$L = 1$` in qualification matches and `$L = 3$` in elimination matches
and `$K = 15$`. The adjustment is subtracted for members of the blue
alliance.

With this system, teams are rewarded for performing above expectations
and punished for performing below expectations.

### Credits

Various model adjustments and optimizations are based on the
[work](https://www.chiefdelphi.com/forums/showthread.php?t=152796) of
[Caleb Sykes](calebsyk@gmail.com).

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  tex2jax: {
    inlineMath: [['$','$'], ['\\(','\\)']],
    displayMath: [['$$','$$'], ['\[','\]']],
    processEscapes: true,
    processEnvironments: true,
    skipTags: ['script', 'noscript', 'style', 'textarea', 'pre'],
    TeX: { equationNumbers: { autoNumber: "AMS" },
         extensions: ["AMSmath.js", "AMSsymbols.js"] }
  }
});
</script>

<script type="text/x-mathjax-config">
  MathJax.Hub.Queue(function() {
    // Fix <code> tags after MathJax finishes running. This is a
    // hack to overcome a shortcoming of Markdown. Discussion at
    // https://github.com/mojombo/jekyll/issues/199
    var all = MathJax.Hub.getAllJax(), i;
    for(i = 0; i < all.length; i += 1) {
        all[i].SourceElement().parentNode.className += ' has-jax';
    }
});
</script>

