function [fc,fc_intervals,omg,omg_intervals] = invert_lsfit(fun,xdata,ydata)
    [fitobj_1,g1of] = fit(xdata,ydata,fun_Brune,'StartPoint',[0,2],...
        'Lower',[min(ydata) min(xdata)],...
        'Upper',[max(ydata) 20  ],...
        'Robust','on');
    CI = confint(fitobj_1,0.95);		 % 95% confidence intervals
    omega =fitobj_1.a;
    fc    =fitobj_1.b;
    omega_intervals =CI(:,1);
    fc_intervals    =CI(:,2);
end