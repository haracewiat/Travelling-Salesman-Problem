%                            Figure Generator        
%
%
% The following code creates a visualisation of the provided route.
%

function GenerateFigure(xy, dmat, optimal_route)
    figure('Name','TSP_GA | Results','Numbertitle','off');
    subplot(2,2,1);
    pclr = ~get(0,'DefaultAxesColor');
    plot(xy(:,1),xy(:,2),'.','Color',pclr);
    title('City Locations');
    subplot(2,2,2);
    rte = optimal_route([1:100 1]);
    plot(xy(rte,1),xy(rte,2),'r.-');
    title(sprintf('Total Distance = %1.4f',CalculateFitness(dmat, optimal_route)));
    
    
