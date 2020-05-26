function x = ssp_pso(fv,displ,model,x0)
        index1=find(fv<=1,1,'last');
        ew =expWeight(30);
        ex =[-30:1:30]';
        fun_Brune = @(par,x)  par(1)./(1+(x./par(2)).^2);
        fun_Boore = @(par,x) par(1)./((1.+(x./par(2)).^2).*(1+(x./par(3)).^par(4)));
        fun_Brune2 = @(par,x)  par(1)./(1+(x./par(2)).^par(3));
        switch model
            case 1
                fitnessfcn = fun_Brune;
%                 options = fitnessfcn('init',[0 2]) ;
%                 problem.options = options ;
                %------------------------------------------------------------------
                uplimits= [0 2];
                lolimits= [1 10];
                problem.options.InitialPopulation = x0 ;
                problem.Aineq = [] ; problem.bineq = [] ;
                problem.Aeq = [] ;   problem.beq = [] ;
                problem.LB = lolimits ;
                problem.UB = uplimits ;
        % 		problem.LB = [] ;
        % 		problem.UB = [] ;

                problem.fitnessfcn = fitnessfcn ;
                problem.nvars = 2 ;
                problem.nonlcon = [] ;

                fprintf('pso searching ... ');              tic;
                [x, misfit_min,exitflag,output,population,scores]=pso(problem);
		fprintf('end');                             toc;
            case 2
                fitnessfcn = fun_Boore;
                options = fitnessfcn('init') ;
                problem.options = options ;
                %------------------------------------------------------------------
                uplimits= [max(displ(1:index1)) 3.5 20 5];
                lolimits= [min(displ(1:index1)) 0.5 10 1];
                problem.options.InitialPopulation = x0 ;
                problem.Aineq = [] ; problem.bineq = [] ;
                problem.Aeq = [] ;   problem.beq = [] ;
                problem.LB = lolimits ;
                problem.UB = uplimits ;
        % 		problem.LB = [] ;
        % 		problem.UB = [] ;

                problem.fitnessfcn = fitnessfcn ;
                problem.nvars = 4 ;
                problem.nonlcon = [] ;

                fprintf('pso searching ... ');              tic;
                [x, misfit_min,exitflag,output,population,scores]=pso(problem);
                fprintf('end');                             toc;
            case 3
                fitnessfcn = fun_Brune2;
                options = fitnessfcn('init') ;
                problem.options = options ;
                %------------------------------------------------------------------
                uplimits= [max(displ(1:index1)) 3.5 20 5];
                lolimits= [min(displ(1:index1)) 0.5 10 1];
                problem.options.InitialPopulation = x0 ;
                problem.Aineq = [] ; problem.bineq = [] ;
                problem.Aeq = [] ;   problem.beq = [] ;
                problem.LB = lolimits ;
                problem.UB = uplimits ;
        % 		problem.LB = [] ;
        % 		problem.UB = [] ;

                problem.fitnessfcn = fitnessfcn ;
                problem.nvars = 4 ;
                problem.nonlcon = [] ;

                fprintf('pso searching ... ');              tic;
                [x, misfit_min,exitflag,output,population,scores]=pso(problem);
                fprintf('end');                             toc;
        end
		
end