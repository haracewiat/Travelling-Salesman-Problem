classdef Config
    % The Config class acts as a container for all GA parameters.
    
    properties
        population_size             % Recommended: 100-200
        generations                 % Recommended at least 2000
        crossover_probability       % Value between 0 and 1
        mutation_probability        % Value between 0 and 1
        SELECTION_METHOD            % 'RouletteWheel' | 'Tournament' | 'Truncation' 
        CROSSOVER_METHOD            % 'OrderBased' | 'PMX' 
        MUTATION_METHOD             % 'Swap' | 'Flip' 
    end
    
end

