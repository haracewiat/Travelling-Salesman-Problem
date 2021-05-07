function choices = TournamentSelection(candidates, population_size)
    
    % With replacement 
    
    % Prepare variable for n choices
    choices = zeros(2, 1);
    
    for choice = 1:2
        
        % Choose two competitors
        competitor1 = randi(population_size);
        competitor2 = randi(population_size);
        
        % Select the winner (smaller fitness value (distance) wins)
        if (candidates(competitor1) < candidates(competitor2)) 
            winner = competitor1;
        else
            winner = competitor2;
        end
        
        choices(choice) = winner;
              
    end