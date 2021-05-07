function choices = RouletteWheelSelection(fitness_values, population_size)
    
    % Prepare variable for n choices
    choices = zeros(2, 1);
    
    % Produce probability for each fitness value
    probabilities = fitness_values/sum(fitness_values);

    % Transform the probabilities into cumulative probabilities
    cumulative_probabilities = cumsum(probabilities);
    
    for choice = 1:2
        
        % Calculate probability
        probability = rand();
        
        % Select the winner
        for index = 1 : population_size
            
            if (cumulative_probabilities(index) > probability)
              choices(choice) = index;
              break;
            end
            
        end
        
    end