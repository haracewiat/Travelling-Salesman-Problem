function total_distance = CalculateFitness(distances, routes)
    
    % Store the size of the provided routes matrix
    [elements, cities] = size(routes);

    % Create variables to store the calculated distances
    total_distance = zeros(elements, 1);

    % Go through each route to calculate the distance between each city
    for route = 1:elements
        
        % Calculate the distance between the last and the first city
        distance = distances(routes(route,cities), routes(route,1)); 
        
        % Calculate the distance for the remaining cities
        for city = 2:cities
            distance = distance + distances(...
                                        routes(route,city-1),...
                                        routes(route,city));
        end
        
        % Store the total distance
        total_distance(route, 1) = distance;
            
    end
    
    
    
   