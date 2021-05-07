%            Genetic Algorithm for Travelling Salesman Problem          
%
%
% The following code allows you to compute an optimal route for the
% Travelling Salesman Problem (TSP). 
% 
% The code relies on the existance of a file containing a matrix of city
% loactions named 'xy.mat' in the same directory. Make sure it's included
% before running the program.
%

function ga_result = GA( config, suppress_output )


    % Unpack the config object
    population_size         = config.population_size;
    generations             = config.generations;
    crossover_probability   = config.crossover_probability;
    mutation_probability    = config.mutation_probability;
    SELECTION_METHOD        = config.SELECTION_METHOD;
    CROSSOVER_METHOD        = config.CROSSOVER_METHOD;
    MUTATION_METHOD         = config.MUTATION_METHOD;

    % Set-up
    addpath(...
                'cross-over',... 
                'mutation',... 
                'selection',...
                'helper_functions',...
                'classes'); 

    load('xy.mat');

    cities = xy;
    number_of_genes = length(cities);

    duplicate_fitness_value = 1;
    generations_without_change = 200;
    keep_elite = true;

    SummaryColumns = {'Generation', 'Progress', 'Distance', 'Time'};


    % Precompute a matrix with distances between all cities
    distances = CalculateDistances();

    % Generate initial population
    GeneratePopulation();


    if (~suppress_output)
        fprintf(1, '%s\t %s\t %s\t %s\n', SummaryColumns{:}); 
    end



% % % % % % % % % % % % % % % START THE GA % % % % % % % % % % % % % % % %

    % Keep track of the start time
    ga_start = tic;

    for generation = 1:generations

        % Calculate fitness of each of the chromosomes 
        population = EvaluatePopulationFitness(population);
       
        % Keep record of the best fitness value seen
        best_distance = population(1, end);

        % Preallocate space for new population
        new_population = zeros(population_size, number_of_genes + 1);  
        new_population_size = 0;

        % REPLACEMENT STAGE
        % Keep the 2 best chromosomes
        ReplacementStage();


        % Create a new population
        while (new_population_size < population_size) 
            
            % Predefine parents and offspring
            parents = zeros(2, number_of_genes);
              

            % SELECTION STAGE
            % Two parent chromosomes are selected for breeding offspring.
            SelectionStage();
            offspring = parents;
         
            
            % CROSS-OVER STAGE
            % A cross-over method is chosen to introduce variation in the offsprings' 
            % genetic information.
            CrossoverStage();


            % MUTATION STAGE
            % Mutations are introduced to the offsprings' genom at a specified mutation
            % probability.
            MutationStage();



            % INSERTION STAGE
            % The newly created offspring are added to the new population.
            new_population(new_population_size+1, 1:number_of_genes) = offspring(1, :);
            new_population(new_population_size+2, 1:number_of_genes) = offspring(2, :);
            new_population_size = new_population_size + 2;


        end


        % Calculate fitness of each new chromosome
        new_population = EvaluatePopulationFitness(new_population);
        new_best_distance = new_population(1, end);

        % RESET VALUES
        new_population_size = 0;
        population = new_population;

        % PRODUCE SUMMARY   
        progress = generation/generations * 100;
        generation_end = toc(ga_start);
        
        Data = [generation progress new_best_distance generation_end];  
        
        if (~suppress_output)
            fprintf(1, '%10d     %5.2f%%     %7.2f     %.2f s\n', Data');
        end
        

        % END CONDITION
        % If no improvement has been noted for a defined number of generations,
        % stop the algorithm.
        if (best_distance == new_best_distance)
            duplicate_fitness_value = duplicate_fitness_value + 1;
        else 
            duplicate_fitness_value = 1;
        end

        if (duplicate_fitness_value == generations_without_change)
            break;
        end



    end

    ga_end = toc(ga_start);

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



    % Print the result
    best_route = new_population(1, 1:number_of_genes);
    if (~suppress_output)
        GenerateFigure(xy, distances, best_route);
    end


    % Pack the GA result
    ga_result = GA_result;

    ga_result.config = config;
    ga_result.generation = generation;
    ga_result.time_elapsed = ga_end;
    ga_result.best_route = best_route;
    ga_result.fitness_score = new_population(1, number_of_genes+1);
    
    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


    function distances = CalculateDistances()
        
        % Get the size of cities
        n = size(cities,1);
        
        % Preallocate a grid
        a = meshgrid(1:n);
        
        % Compute the distances
        distances = reshape(...
                    sqrt(sum((xy(a, :)-xy(a', :)).^2,2)), n, n);
                
    end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    function GeneratePopulation()
        
        % Preallocate space for each chromosome
        population = zeros(population_size, number_of_genes + 1);  

        % Create random permutations
        for i = 1:population_size
            population(i, 1:number_of_genes) = randperm(number_of_genes);
        end
        
    end

    function evaluated_population = EvaluatePopulationFitness(population_to_evaluate) 
        
        % Calculate the fitness score for each chromosome
        population_to_evaluate(:, number_of_genes + 1) = CalculateFitness(...        
                                            distances,... 
                                            population_to_evaluate(:, 1:number_of_genes));

        % Sort the chromosomes based on their fitness
        population_to_evaluate = sortrows(population_to_evaluate, number_of_genes + 1);
        
        evaluated_population = population_to_evaluate;
        
    end

    function ReplacementStage
       
        % Select two best fitted chromosomes
        if (keep_elite) 
            new_population(1:2,:) = population(1:2, :);
            new_population_size = 2;
        end
        
    end

    function SelectionStage 
       
        switch SELECTION_METHOD

            case 'RouletteWheel'
                chosen_chromosomes = RouletteWheelSelection(...
                                                population(:, end),...
                                                population_size);
                parents = population(chosen_chromosomes, 1:number_of_genes);

            case 'Tournament'
                chosen_chromosomes = TournamentSelection(...
                                                population(:, end),...
                                                population_size);

                parents = population(chosen_chromosomes, 1:number_of_genes);

            case 'Truncation'
                parents(1:2, :) = population(1:2, 1:number_of_genes);

            otherwise
                error('Invalid selection method');

        end
                
    end


    function CrossoverStage()
       
        switch CROSSOVER_METHOD

            case 'OrderBased'
                if (rand() < crossover_probability)
                    offspring = OrderBasedCrossover(...
                                    number_of_genes,...
                                    parents(:, 1:number_of_genes));
                end


            case 'PMX'
                if (rand() < crossover_probability)
                    offspring = PMXCrossover(...
                                    number_of_genes,...
                                    parents(:, 1:number_of_genes));
                end

            case 'None'
                % Skip


            otherwise
                error('Invalid cross-over method');

        end
            
    end


    function MutationStage()

        
        switch MUTATION_METHOD

            case 'Swap'
                offspring = SwapMutation(...
                                    offspring(:, 1:number_of_genes),...
                                    mutation_probability);


            case 'Flip'
                if (rand() < mutation_probability)
                    offspring = FlipMutation(...
                                        offspring(:, 1:number_of_genes));
                end


            case 'None'
                % Skip


            otherwise
                error('Invalid mutation method');

        end
            
    end

end

