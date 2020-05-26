function state = psoplotswarmsurf(options,state,flag)
% Shows the evolution of a 2-variable population over a known surface. This
% plotting function is useful for observing the performance of the swarm
% over a given 2-D search space. It is used when running demonstration
% cases of pso through the PSODEMO function.
%
% See also: PSODEMO

notinf = isfinite(state.Score') ;
% notinf = ~state.OutOfBounds ;

if strcmpi(flag(1:4),'init') % Initialize
    delete(findobj(gca,'-regexp','Tag','*Locations'))
    
    line(state.Population(notinf,1),state.Population(notinf,2),...
        state.Score(notinf)',...
        'Color',0.75*ones(1,3),...
        'Marker','.',...
        'LineStyle','none',...
        'Tag','Initial Locations') ;
    
    % Set reasonable axes limits
    % ---------------------------------------------------------------------
    xlim([options.PopInitRange(1,1) options.PopInitRange(2,1)])
    ylim([options.PopInitRange(1,2) options.PopInitRange(2,2)])
    view(3)
    % ---------------------------------------------------------------------
    
    if ~strcmpi(options.DemoMode,'off')
        set(state.hfigure,'Units','normalized',...
            'Position',[0.2, 0.3, 0.6, 0.5])
        overlaysurface(state.fitnessfcn,options) ;
    end % if ~isempty
    
    line(state.Population(notinf,1),...
        state.Population(notinf,2),...
        state.Score(notinf)',...
        'LineStyle','none',...
        'Marker','.',...
        'Color','blue',...
        'Tag','Swarm Locations') ;
    set(gca,'Tag','Swarm Plot 3D',...
        'NextPlot','add',...
        'Projection','perspective')
    rotate3d(gca,'on')
elseif strcmpi(flag(1:4),'iter') % Iterate
    set(findobj(gca,'Tag','Swarm Locations','Type','line'),...
        'XData',state.Population(notinf,1),...
        'YData',state.Population(notinf,2),...
        'ZData',state.Score(notinf)')
end