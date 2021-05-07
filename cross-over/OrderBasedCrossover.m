%                        Order Based Cross-Over 
%
%
% The following code performs an order based cross-over on two provided 
% parent chromosomes.
% 

function offspring = OrderBasedCrossover(number_of_genes, parents)

    % Draw two random genes
    points = sort(randperm(number_of_genes, 2));
    
    % Create offspring
    offspring(1, :) = ProduceOffspring(...
                                parents(1, :),...
                                parents(2, :));
                            
    offspring(2, :) = ProduceOffspring(...
                                parents(2, :),...
                                parents(1, :));

    

    
    function offspring = ProduceOffspring(parent1, parent2)
        
        % Create an offspring
        offspring = zeros(1, number_of_genes);
        
        % Extract segments of genes from both parents
        segment = parent1(points(1):points(2));
        
        % Insert the segment into the offspring
        offspring(1, points(1):points(2)) = segment;


        % Keep track of the indexes        
        current_index = points(2);
        insertion_index = points(2);
        
        % Traverse through genes of parent 2 and use them to fill the
        % offspring
        offspring_genes_count = length(segment);
        
        while (offspring_genes_count < number_of_genes)

            % Move the current index
            if (current_index == number_of_genes) 
                current_index = 1;
            else
                current_index = current_index + 1;
            end

            % Store the allele of the parent at the current index
            allele = parent2(current_index);

            % If the offspring doesn't contain such an allele, insert it
            if ~ismember(allele, offspring(:))

                % Move the insertion index
                if (insertion_index == number_of_genes)
                    insertion_index = 1;
                else
                    insertion_index = insertion_index + 1;
                end

                % Insert the allele into the offspring
                offspring(1, insertion_index) = allele;
                offspring_genes_count = offspring_genes_count + 1;

            end

        end
        
    end

end