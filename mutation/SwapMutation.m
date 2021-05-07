%                             Swap Mutation                                
%
%
% The following function performs a swap mutation on the provided
% chromosomes by traversing through each of the genes and swapping its 
% allele with a randomly drawn gene at a specified mutation probability.
% 

function offspring = SwapMutation(offspring, mutation_probability)

    % Store the size of the offspring matrix
    [chromosomes, genes] = size(offspring);
    
    % Perform the swap mutation on each of the chromosomes
    for chromosome = 1:chromosomes

        % Perform a swap for each gene at the specified probability
        for gene = 1:genes

            if (rand(1) < mutation_probability) 

                % Select a second gene other than the current one
                gene_to_swap = randi([1,100]);

                while (gene_to_swap == gene)
                    gene_to_swap = randi([1,100]);
                end
                
                % Store the alleles of both genes
                allele1 = offspring(chromosome, gene);
                allele2 = offspring(chromosome, gene_to_swap);

                % Swap the alleles between the genes
                offspring(chromosome, gene) = allele2;
                offspring(chromosome, gene_to_swap) = allele1;

            end

        end

    end