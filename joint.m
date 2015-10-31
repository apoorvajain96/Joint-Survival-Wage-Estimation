function [p fval history] = joint(x0, lw_r, y, ysm, idind, X, E, age, mig_age)
func = overall_joint_estimation_cost_function(lw_r, y, ysm, idind, X, E, age, mig_age);
      history = [];
    options = optimset('OutputFcn', @myoutput);
    [p fval] = fminsearch(func, x0, options);
        
    function stop = myoutput(p,optimvalues,state);
        stop = false;
        if ~isequal(state,'iterrupt')                   
            if size(history,1) >=20
                history = history(2:20,:); 
            end
          history = [history; p'];
          %history
          save('param_history_new', 'history', '-ascii')
        end
   end

end