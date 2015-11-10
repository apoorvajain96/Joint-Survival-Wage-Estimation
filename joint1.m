function [p fval history] = joint1(x0, lw_r2010, y, ysm, idind, X, E, age, mig_age, year_fe, mig_risk, lb, ub)
func = overall_joint_estimation_cost_function(lw_r2010, y, ysm, idind, X, E, age, mig_age, year_fe, mig_risk);
      history = [];
    options = optimset('OutputFcn', @myoutput);
    [p fval] = fmincon(func, x0,[],[],[],[], lb, ub,[], options);
        
    function stop = myoutput(p,optimvalues,state);
        stop = false;
        if ~isequal(state,'iterrupt')                   
            if size(history,1) >=20
                history = history(2:20,:); 
            end
          history = [history; p'];
          %history
          save('param_history.txt', 'history', '-ascii')
        end
   end

end