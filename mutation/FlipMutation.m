%                            Flip Mutation          
%
%
% The following function performs a flip mutation on the provided
% chromosomes by drawing two random genes and flipping the inbetween
% alleles.
% 

function offspring = FlipMutation(offspring)

    % Store the size of the offspring matrix
    [chromosomes, genes] = size(offspring);
    
    % Draw two random points
    points = sort(randperm(genes, 2));

    % Perform the flip mutation on each of the chromosomes
    for chromosome = 1:chromosomes

        % Flip the alleles between the drawn points
        offspring(chromosome, points(1):points(2)) = ...
                            offspring(chromosome, points(2):-1:points(1));
    end