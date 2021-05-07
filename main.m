%            Genetic Algorithm for Travelling Salesman Problem          
%
%
% The following code allows you to run the GA algorithm. The algorithm uses
% a config object to define its parameters. The parameters you can adjust 
% are briefly explained below:
%
% - population_size       = Number of chromosomes in the genome. In other 
%                           words, it defines the number of population 
%                           members.
%
% - generations           = Number of genomes to be created. This number
%                           defines for how many generations the code will 
%                           run. If the new genomes result don't improve 
%                           over a set number of iterations, the code will
%                           terminate prematurely.
%
% - crossover_probability = The probability for a pair of offspring 
%                           chromosomes to undergo a crossover. Usually
%                           set to a relatively high value, e.g. 70%.
%
% - mutation_probability  = The probability for a pair of offspring to
%                           mutate. Usually set to a lower value, e.g. 20%.
%
% - SELECTION_METHOD      = The method used to select parent chromosomes
%                           for a new pair of offspring. Can be set to 
%                           'RouletteWheel', 'Tournament' and 'Truncation'.
%
% - CROSSOVER_METHOD      = The method used to perform cross-over on a pair
%                           of offspring. Can be set to 'OrderBased', 
%                           'PMX' and 'None'.
%
% - MUTATION_METHOD       = The method used to mutate a pair of offspring. 
%                           Can be set to 'Swap', 'Flip' and 'None'.


% Set the parameters configuration
addpath('classes');
config = Config;

config.population_size       = 200;
config.generations           = 10000;
config.crossover_probability = 0.2;
config.mutation_probability  = 0.8;
config.SELECTION_METHOD      = 'Truncation';
config.CROSSOVER_METHOD      = 'PMX';
config.MUTATION_METHOD       = 'Flip';

% Run the GA algorithm
ga_result = GA(config, false);




