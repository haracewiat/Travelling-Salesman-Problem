classdef GA_result
    % The GA_result class acts as a container for GA algorithm output.
    
    properties
        config                      % The hyperparameters used 
        best_route                  % A matrix containing the best route 
        generation                  % Numer of generations bred
        time_elapsed                % Seconds taken to finish 
        fitness_score               % Shortest distance achieved
    end
    
end

