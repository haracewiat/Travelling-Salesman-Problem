%                     Partially Mapped Cross-Over 
%
%
% The following code performs a PMX cross-over on two provided parent
% chromosomes.
% 

function offspring = PMXCrossover(number_of_genes, parents)

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
        segment1 = parent1(points(1):points(2));
        segment2 = parent2(points(1):points(2));

        % Insert the first segment into the offspring
        offspring(points(1):points(2)) = segment1;

        % Look for alleles that are present in segment2 but not in segment1
        segment2_difference = ~ismember(segment2, segment1);

        % For each of these genes look for alleles of the corresponding
        % genes in segment1
        i_values = segment2(1, segment2_difference);     % segment2 alleles
        j_values = segment1(1, segment2_difference);     % segment1 alleles
 
        % Traverse through all segment1 alleles
        for i = 1:length(i_values)
            
            % Store the values of alleles in segment1 and segment2 at the
            % same index
            i_value = i_values(i);
            j_value = j_values(i);

            % Store the index of the gene from parent2 which contains the
            % value of the current allele from parent1.
            insertion_index = find(parent2(1, :) == j_value);

 
            if (offspring(1, insertion_index) == 0)

                % If the insertion point of the offspring is empty, fill
                % it with the allele from segment2
                offspring(1, insertion_index) = i_value;

            else
                
                % If the insertion point is not empty...
                while (offspring(1, insertion_index) ~= 0)

                    % ... check the value of the gene in parent1 at the 
                    % insertion index
                    k_value = parent1(1, insertion_index);

                    % Search for the k_value index in parent2
                    insertion_index = find(parent2(1, :) == k_value);

                end

                % Store the allele in the new insertion index
                offspring(1, insertion_index) = i_value;
                
            end
            
        end

        % Copy the remaining values from parent2 into the offspring's empty
        % alleles
        indexes = ~logical(offspring(1, :));
        offspring(1, indexes) = parent2(1, indexes);
        
    end

end