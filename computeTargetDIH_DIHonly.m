% find optimal # of days give prev DIH (Y2, Y3)
cvx_begin
    variables logDIH(total, 1);
    minimize(norm(logDIH - logDIHprev));
cvx_end

DIH = exp(logDIH) - 1;

target_DIH = DIH;
