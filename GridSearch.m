%            Genetic Algorithm for Travelling Salesman Problem           
%                               Grid Search                             
% 
%
% The following code uses a cartesian product of GA parameters provided to 
% perform a grid search. Each set of parameters is run n number of times to 
% calculate average results for the given selection. 
% 
% After all sets have been evaluated, the program will resturn a matrix of
% GA results. Each GA result will hold the following properties:
%
% - config                = The set of parameters used on the GA algorithm.
%
% - best_route            = The best route out of the n number of
%                           iterations.
%
% - generation            = The average number of generations produced in a
%                           single run of the GA algorithm
%
% - time_elapsed          = The average time taken to compute the optimal
%                           solution 
%
% - fitness_score         = The average fitness score of all iterations.
%



% Declare values for the GA parameters
population_size         =   {100, 200}';
generations             =   {10000}';
crossover_probability   =   {0.2, 0.7}';
mutation_probability    =   {0.2, 0.7}';  
SELECTION_METHOD        =   {'RouletteWheel', 'Tournament', 'Truncation'}';    
CROSSOVER_METHOD        =   {'OrderBased', 'PMX', 'None'}';   
MUTATION_METHOD         =   {'Swap', 'Flip', 'None'}';         

% Declare the number of iterations per each combination
iterations = 1;


% % % % % % % % % % % % % % DO NOT CHANGE BELOW % % % % % % % % % % % % % %





% Include necessary paths
addpath('classes', 'helper_functions');

% Generate the cartesian product
cartesian_product       = GenerateCartesianProduct(...
                            population_size,...
                            generations,...
                            crossover_probability,...
                            mutation_probability,...
                            SELECTION_METHOD,... 
                            CROSSOVER_METHOD,...
                            MUTATION_METHOD);

[combinations, ~] = size(cartesian_product);

% Preallocate memory for grid search results
meta = ?GA_result;
gridsearch_results = GA_result.empty(combinations, 0);


SummaryColumns = {'Progress', 'Combination', 'Time'};
fprintf(1, '%s\t %s\t %s\n', SummaryColumns{:});


% Start the grid search 
for combination = 1:combinations
    
    combination_start = tic; 
    
    % Set the parameters configuration
    config = Config;
    
    config.population_size       = cell2mat(cartesian_product(combination, 1));
    config.generations           = cell2mat(cartesian_product(combination, 2));
    config.crossover_probability = cell2mat(cartesian_product(combination, 3));
    config.mutation_probability  = cell2mat(cartesian_product(combination, 4));
    config.SELECTION_METHOD      = char(cartesian_product(combination, 5));
    config.CROSSOVER_METHOD      = char(cartesian_product(combination, 6));
    config.MUTATION_METHOD       = char(cartesian_product(combination, 7));
    
    % Store the configuration
    gridsearch_results(combination, 1).config = config;
    
    % Initialize variables
    gridsearch_results(combination, 1).generation = 0;
    gridsearch_results(combination, 1).time_elapsed = 0;
    gridsearch_results(combination, 1).fitness_score = 0;
    best_fitness_score = 0;
    
    % Run GA for the declared number of iterations
    for i = 1:iterations
        
        % Compute the result
        ga_result = GA(config, true);
        
        % Store the weighted result
        gridsearch_results(combination, 1).generation = ...
                            gridsearch_results(combination, 1).generation  + (ga_result.generation/iterations);
        gridsearch_results(combination, 1).time_elapsed = ...
                            gridsearch_results(combination, 1).time_elapsed + (ga_result.time_elapsed/iterations);
        gridsearch_results(combination, 1).fitness_score = ...
                            gridsearch_results(combination, 1).fitness_score + (ga_result.fitness_score/iterations);
        
        if (i == 1 || ga_result.fitness_score < best_fitness_score) 
            gridsearch_results(combination, 1).best_route = ga_result.best_route;
            best_fitness_score = ga_result.fitness_score;
        end
        
        
    end
    
    % Print progress
    combination_end = toc(combination_start);
    Data = [combination, combination/combinations, combination_end];        
    fprintf(1, '%8d    %11.2f%%     %.2f s\n', Data');
    

end


% Print summary of the results if there are two or more combinations to
% compare
if (combinations > 1)
    GridsearchSummary(gridsearch_results);
end


    
        
        
function GridsearchSummary (gridsearch_results)

    %                            TOP VALUES                               %
     
    % Top generation value
    [top_generation, top_generation_index] = min(...
                                    [gridsearch_results.generation]);
    fprintf('Least amount of generations: %d \n', top_generation);
    disp(gridsearch_results(top_generation_index).config);
    fprintf('\n\n');

    % Top speed value
    [top_speed, top_speed_index] = min(...
                                    [gridsearch_results.time_elapsed]);
    fprintf('Quickest run: %.2f s \n', top_speed);
    disp(gridsearch_results(top_speed_index).config);
    fprintf('\n\n');

    % Top distance value
    [top_distance, top_distance_index] = min(...
                                    [gridsearch_results.fitness_score]);
    fprintf('Shortest distance: %.2f \n', top_distance);
    disp(gridsearch_results( top_distance_index).config);
    fprintf('\n\n');
    
    
    %                           WORST VALUES                              %
    
    % Worst generation value
    [top_generation, top_generation_index] = max(...
                                    [gridsearch_results.generation]);
    fprintf('Most amount of generations: %d \n', top_generation);
    disp(gridsearch_results(top_generation_index).config);
    fprintf('\n\n');

    % Worst speed value
    [top_speed, top_speed_index] = max(...      
                                    [gridsearch_results.time_elapsed]);
    fprintf('Longest run: %.2f s \n', top_speed);
    disp(gridsearch_results(top_speed_index).config);
    fprintf('\n\n');

    % Worst distance value
    [top_distance, top_distance_index] = max(...
                                    [gridsearch_results.fitness_score]);
    fprintf('Longest distance: %.2f \n', top_distance);
    disp(gridsearch_results( top_distance_index).config);
    fprintf('\n\n');


end
