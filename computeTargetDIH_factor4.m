function [target_DIH] = computeTargetDIH_factor4(ages,genders,logDIH_orig,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,...
    spec_train,spec_test,place_train,place_test,...
    ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test,nspec_train,nspec_test,nplace_train,nplace_test,...
    nproc_train,nproc_test,ncond_train,ncond_test,extradsfs_train,extradsfs_test,...
    exchar_train,exchar_test,extraprob_train,extraprob_test,...
    extracg_train,extracg_test,LAMBDA,seeds)
constants;
VERBOSE = true;
DIM= 2;
HILLCLIMB = 0;
BASES = [2,4,6,8];
BASES = [8];
NITERS= 40;
ns = [133,147,155,160,182,185];
ns = [185];
%seeds=123:130;
m = size(ages,1);
%LAMBDA = 20e-7;
m*LAMBDA
numpred = length(seeds)*length(ns)*length(BASES);

try
  load('dasds')
  load(sprintf('cache/factor4_allpreds_m%d_hc%d_lambda%d.mat', ...
    m,HILLCLIMB,round(10000000*LAMBDA)));
catch
  offsets = [...
    SIZE.AGE*SIZE.SEX,...%1,...% a constant
    SIZE.DRUG_1YR,...
    SIZE.LAB_1YR,...
    SIZE.COND_GROUP,...
    SIZE.PROCEDURE,...
    SIZE.SPECIALTY,...
    SIZE.PLACE,...
    SIZE.EXTRA-1,... % ndrug
    SIZE.EXTRA-1,... % nlab
    3,... % nprov,nvend,npcp
    SIZE.EXTRA,... % los
    5,... % nclaims,nspec,nplace,nproc,ncond
    SIZE.EXTRADSFS,...
    SIZE.EXTRACHARLSON,...
    SIZE.EXTRAPROB,...
    SIZE.EXTRACG,...
    ];
  offsets = cumsum(offsets);
  offsets = [0; offsets(1:end)'];

  agesex = ages + 10*(genders-1);
  nrows = length(agesex);
  ncols = offsets(2);
  rows_i = 1:length(agesex);
  cols_i = agesex;
  val = 1;

  try
      %sprintf('cache/factor4/data_m%d.mat', m)
      load(sprintf('cache/factor4/data_m%d.mat', m));
  catch
    disp('Failed to load test and training data. Building now.');
    % map the data to a new space
    [drugs_train,drugs_test] = logMap(drugs_train,drugs_test,0.5);
    [lab_train,lab_test] = identityMap(lab_train,lab_test);
    [cond_train,cond_test] = logMap(cond_train,cond_test,1.75);
    [proc_train,proc_test] = logMap(proc_train,proc_test,1.1);
    [spec_train,spec_test] = logMap(spec_train,spec_test,0.79);
    [place_train,place_test] = logMap(place_train,place_test,0.4);
    [ndrugs_train,ndrugs_test] = powMap(ndrugs_train,ndrugs_test,0.65);
    [nlab_train,nlab_test] = powMap(nlab_train,nlab_test,1.4);
    [nprov_train,nprov_test] = powMap(nprov_train,nprov_test,1.6);
    [nvend_train,nvend_test] = powMap(nvend_train,nvend_test,0.9);
    [npcp_train,npcp_test] = powMap(npcp_train,npcp_test,0.9);
    [extralos_train,extralos_test] = powMap(extralos_train,extralos_test,0.8);
    [nclaims_train,nclaims_test] = powMap(nclaims_train,nclaims_test,0.75);
    [nspec_train,nspec_test] = powMap(nspec_train,nspec_test,1.4);
    [nplace_train,nplace_test] = powMap(nplace_train,nplace_test,0.8);
    [nproc_train,nproc_test] = powMap(nproc_train,nproc_test,1.5);
    [ncond_train,ncond_test] = identityMap(ncond_train,ncond_test);
    [extradsfs_train,extradsfs_test] = powMap(extradsfs_train,extradsfs_test,1.5);
    [exchar_train,exchar_test] = identityMap(exchar_train,exchar_test);
    [extraprob_train,extraprob_test] = identityMap(extraprob_train,extraprob_test);
    [extracg_train,extracg_test] = identityMap(extracg_train,extracg_test);

    A_orig = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
      drugs_train, lab_train, cond_train, proc_train,...
      spec_train, place_train, ndrugs_train, nlab_train, nprov_train, nvend_train,...
      npcp_train,extralos_train,nclaims_train,nspec_train,nplace_train,...
      nproc_train,ncond_train,extradsfs_train,exchar_train,extraprob_train,...
      double(extracg_train)];
    A_orig = sparse(A_orig);

    agesex_test = ages_test + 10*(genders_test-1);
    agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
    M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,...
      spec_test,place_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
      npcp_test,extralos_test,nclaims_test,nspec_test,nplace_test,nproc_test,ncond_test,...
      extradsfs_test,exchar_test,extraprob_test,double(extracg_test)]);
    M = sparse(M);
    save(sprintf('cache/factor4/data_m%d.mat', m), 'A_orig','M');
  end
  m = size(A_orig,1);
  m_test = size(M,1);

  try
      load(sprintf('cache/C_DIM%d_m%d.mat',DIM,m));
  catch
      C=sparse(1:m,1:m,1,m,m);
      C_test=sparse(1:m_test,1:m_test,1,m_test,m_test);
      save(sprintf('cache/C_DIM%d_m%d.mat',DIM,m),'C','C_test');
  end
  nstart = offsets(1)+1;
  target_DIH = zeros(m_test,1);
  % Average over many bases
  for BASE=BASES
    % Average over many ns
    for n=ns
      % Average over many seeds
      for seed=seeds
        randn('seed',seed); rand('seed',seed);
        r = randperm(m);
        A = A_orig(r,nstart:n);
        logDIH=logDIH_orig(r);

        % compute base ages
        c = A(:,1:offsets(BASE)) \ logDIH;
        remLogDIH = logDIH - A(:,1:offsets(BASE))*c;
        
        fprintf('Base %d, n %d, seed %d, LAMBDA %f, training error: %f\n', ...
          BASE, n, seed, LAMBDA, sqrt(mean(remLogDIH.^2)));

        f = rand(n-nstart+1,DIM)-0.5; g = rand(n-nstart+1,DIM)-0.5;
        prev_opt = inf; cur_opt = inf; cur_g = g; cur_f = f;
        for i=1:NITERS
            try
                load(sprintf('cache/factor4_DIM%d_m%d_i%d_seed%d_n%d_base%d_lambda%d.mat',...
                    DIM,m,i,seed,n,BASE,round(10000000*LAMBDA)));
            catch
                if prev_opt < cur_opt + CATVEC_TERMINATE_THRESH
                    break
                end
                %keyboard
                prev_opt = cur_opt;
                %try
                    G = A*g;
                    cvx_clear
                    cvx_begin quiet
                        cvx_precision low;
                        variables f(n-nstart+1,DIM);
                        minimize( norm( sum(C*(G.*(A*f)),2) - remLogDIH) + m*LAMBDA*norm(g.*f) )
                        subject to
                    cvx_end
                    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
                        'computeTargetDIH_factor4 failed'
                        keyboard
                    end
                    fprintf('curopt %f, %f, %f, %f\n', cvx_optval, m*LAMBDA*norm(g.*f),...
                        m*LAMBDA, norm(g.*f));
                    cur_opt = cvx_optval; cur_g = g; cur_f = f; 
                    g = f; % this makes it so it keeps switching sides;
                    save(sprintf('cache/factor4_DIM%d_m%d_i%d_seed%d_n%d_base%d_lambda%d.mat', ...
                        DIM,m,i,seed,n,BASE,round(10000000*LAMBDA)), ...
                        'prev_opt','cur_opt','cur_g','cur_f','g');
                %catch
                %    disp('TERMINATED! PROBABLY RAN OUT OF MEMORY');
                %    break
                %end
            end
            % note that error+penalty doesnt necessarily decrease because 
            % postProcessing is not included in the optimization
            err = sqrt((norm(postProcess( sum(C*((A*cur_g).*(A*cur_f)),2) )-remLogDIH)^2)/m);
            if VERBOSE
                fprintf('ITER %d: factor4 TRAINING ERROR: %f\n', i,err);
            end
        end
        if VERBOSE
            fprintf('factor4 TRAINING ERROR: %f\n', err);
        end

        %{
        if HILLCLIMB
          x = reshape((A*cur_g)',DIM*m,1).*reshape((A*cur_f)',DIM*m,1);
          err = sqrt((norm(postProcess(B*x)-remLogDIH)^2)/m);
          disp(sprintf('factor4 preHILLCLIMB TRAINING ERROR: %f',err));
          [cur_f,cur_g] = hillClimbCatVec(A,B,cur_f,cur_g,remLogDIH,DIM);
          x = reshape((A*cur_g)',DIM*m,1).*reshape((A*cur_f)',DIM*m,1);
          err = sqrt((norm(postProcess(B*x)-remLogDIH)^2)/m);
          fprintf('factor4 HILLCLIMB TRAINING ERROR: %f\n',err);
        end
        %}

        x = (M(:,nstart:n)*cur_g).*(M(:,nstart:n)*cur_f);
        target_DIH = target_DIH + M(:,1:offsets(BASE))*c + sum(C_test*x,2);
      end
    end
  end
  %save(sprintf('cache/factor4_allpreds_m%d_hc%d_lambda%d.mat', ...
  %  m,HILLCLIMB,round(10000000*LAMBDA)), 'target_DIH');
end
target_DIH = target_DIH / numpred;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function [x,y] = logMap(x,y,c)
x = sparse(log(x+c)-log(c));
y = sparse(log(y+c)-log(c));
end
function [x,y] = powMap(x,y,c)
x=x.^c;
y=y.^c;
end
function [x,y] = identityMap(x,y)
end