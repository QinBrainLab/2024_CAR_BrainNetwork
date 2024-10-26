function [fractional_occupancy, mean_life,mean_life_var, dominant_state]  = compute_occupancy_and_mean_life_subject_wise(temporal_evolution_of_states, max_nstates)
n_subjs = length(temporal_evolution_of_states);
for subj=1:n_subjs
      [fractional_occupancy(subj,:), mean_life(subj,:),mean_life_var(subj,:),count(subj,:)] = summary_stats_fast(temporal_evolution_of_states{subj}, 1:max_nstates);
end

