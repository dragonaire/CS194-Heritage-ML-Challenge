function [target_DIH] = computeTargetDIH_factor2(ages,genders,logDIH_orig,...
    ages_test,genders_test,drugs_train,drugs_test,lab_train,lab_test,cond_train,cond_test,...
    proc_train,proc_test,...
    spec_train,spec_test,place_train,place_test,...
    ndrugs_train,ndrugs_test,nlab_train,nlab_test,nprov_train,nprov_test,...
    nvend_train,nvend_test,npcp_train,npcp_test,extralos_train,extralos_test,...
    nclaims_train,nclaims_test,nspec_train,nspec_test,nplace_train,nplace_test,...
    nproc_train,nproc_test,ncond_train,ncond_test,extradsfs_train,extradsfs_test,...
    exchar_train,exchar_test,extraprob_train,extraprob_test)
constants;
LAMBDA = 0.01;
DIM= 1;
HILLCLIMB = 0;
BASES = [2,4,6,8];
NITERS= 40;
ns = [133,147,155,160,182];
seeds=123:130;
m = size(ages,1);
numpred = length(seeds)*length(ns)*length(BASES);

try
  load(sprintf('cache/factor2_allpreds_m%d_hc%d_lambda%d.mat', ...
    m,HILLCLIMB,round(100000*LAMBDA)));
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
    1,... % nprov
    1,... % nvend
    1,... % npcp
    SIZE.EXTRA,... % los
    1,... % nclaims
    1,... % nspec
    1,... % nplace
    1,... % nproc
    1,... % ncond
    SIZE.EXTRADSFS,...
    SIZE.EXTRACHARLSON,...
    SIZE.EXTRAPROB,...
    ];
  offsets = cumsum(offsets);
  offsets = [0; offsets(1:end)'];

  agesex = ages + 10*(genders-1);
  nrows = length(agesex);
  ncols = offsets(2);
  rows_i = 1:length(agesex);
  cols_i = agesex;
  val = 1;

  % map the data to a new space
  drugs_train = drugMap(drugs_train);
  drugs_test = drugMap(drugs_test);
  lab_train = labMap(lab_train);
  lab_test = labMap(lab_test);
  cond_train = condMap(cond_train);
  cond_test = condMap(cond_test);
  proc_train = procMap(proc_train);
  proc_test = procMap(proc_test);
  spec_train = specMap(spec_train);
  spec_test = specMap(spec_test);
  place_train = placeMap(place_train);
  place_test = placeMap(place_test);
  ndrugs_train = ndrugMap(ndrugs_train);
  ndrugs_test = ndrugMap(ndrugs_test);
  nlab_train = nlabMap(nlab_train);
  nlab_test = nlabMap(nlab_test);
  nprov_train = nprovMap(nprov_train);
  nprov_test = nprovMap(nprov_test);
  nvend_train = nvendMap(nvend_train);
  nvend_test = nvendMap(nvend_test);
  npcp_train = npcpMap(npcp_train);
  npcp_test = npcpMap(npcp_test);
  extralos_train = extralosMap(extralos_train);
  extralos_test = extralosMap(extralos_test);
  nclaims_train = nclaimsMap(nclaims_train);
  nclaims_test = nclaimsMap(nclaims_test);
  nspec_train = nspecMap(nspec_train);
  nspec_test = nspecMap(nspec_test);
  nplace_train = nplaceMap(nplace_train);
  nplace_test = nplaceMap(nplace_test);
  nproc_train = nprocMap(nproc_train);
  nproc_test = nprocMap(nproc_test);
  ncond_train = ncondMap(ncond_train);
  ncond_test = ncondMap(ncond_test);
  extradsfs_train = extradsfsMap(extradsfs_train);
  extradsfs_test = extradsfsMap(extradsfs_test);
  exchar_train = excharMap(exchar_train);
  exchar_test = excharMap(exchar_test);
  extraprob_train = extraprobMap(extraprob_train);
  extraprob_test = extraprobMap(extraprob_test);

  A_orig = [full(sparse(rows_i, cols_i, val, nrows, ncols)), ...%ones(m,1), ...
    drugs_train, lab_train, cond_train, proc_train,...
    spec_train, place_train, ndrugs_train, nlab_train, nprov_train, nvend_train,...
    npcp_train,extralos_train,nclaims_train,nspec_train,nplace_train,...
    nproc_train,ncond_train,extradsfs_train,exchar_train,extraprob_train];
  A_orig = sparse(A_orig);
  m = size(A_orig,1);
  agesex_test = ages_test + 10*(genders_test-1);
  agesex_test = sparse(1:length(ages_test), agesex_test, 1, length(ages_test), SIZE.AGE*SIZE.SEX);
  M = sparse([agesex_test,drugs_test,lab_test,cond_test,proc_test,...
    spec_test,place_test,ndrugs_test,nlab_test,nprov_test,nvend_test,...
    npcp_test,extralos_test,nclaims_test,nspec_test,nplace_test,nproc_test,ncond_test,...
    extradsfs_test,exchar_test,extraprob_test]);
  M = sparse(M);
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
                load(sprintf('cache/factor2_DIM%d_m%d_i%d_seed%d_n%d_base%d_lambda%d.mat',...
                    DIM,m,i,seed,n,BASE,round(100000*LAMBDA)));
            catch
                if prev_opt < cur_opt + CATVEC_TERMINATE_THRESH
                    break
                end
                %keyboard
                prev_opt = cur_opt;
                %try
                    G = A*g;
                    %%%%%%
                    % starting to make it more efficient
                    %Z = B*diag(sparse(reshape(G',m*DIM,1)))*A;
                    %%%%%%%%
                    cvx_clear
                    cvx_begin quiet
                        variables f(n-nstart+1,DIM);
                        minimize( norm( sum(C*(G.*(A*f)),2) - remLogDIH) + LAMBDA*norm(g.*f) )
                        subject to
                    cvx_end
                    if ~strcmp(cvx_status,'Solved') && ~strcmp(cvx_status,'Inaccurate/Solved')
                        'computeTargetDIH_factor2 failed'
                        keyboard
                    end
                    cur_opt = cvx_optval; cur_g = g; cur_f = f; 
                    g = f; % this makes it so it keeps switching sides;
                    save(sprintf('cache/factor2_DIM%d_m%d_i%d_seed%d_n%d_base%d_lambda%d.mat', ...
                        DIM,m,i,seed,n,BASE,round(100000*LAMBDA)), ...
                        'prev_opt','cur_opt','cur_g','cur_f','g');
                %catch
                %    disp('TERMINATED! PROBABLY RAN OUT OF MEMORY');
                %    break
                %end
            end
            % note that error+penalty doesnt necessarily decrease because 
            % postProcessing is not included in the optimization
            err = sqrt((norm(postProcess( sum(C*((A*cur_g).*(A*cur_f)),2) )-remLogDIH)^2)/m);
            fprintf('ITER %d: factor2 TRAINING ERROR: %f, PENALTY: %f\n', ...
              i,err, LAMBDA*norm(cur_f.*cur_g));
        end
        fprintf('factor2 TRAINING ERROR: %f, PENALTY: %f\n', ...
          err, LAMBDA*norm(cur_f.*cur_g));

        %{
        if HILLCLIMB
          x = reshape((A*cur_g)',DIM*m,1).*reshape((A*cur_f)',DIM*m,1);
          err = sqrt((norm(postProcess(B*x)-remLogDIH)^2)/m);
          disp(sprintf('factor2 preHILLCLIMB TRAINING ERROR: %f',err));
          [cur_f,cur_g] = hillClimbCatVec(A,B,cur_f,cur_g,remLogDIH,DIM);
          x = reshape((A*cur_g)',DIM*m,1).*reshape((A*cur_f)',DIM*m,1);
          err = sqrt((norm(postProcess(B*x)-remLogDIH)^2)/m);
          fprintf('factor2 HILLCLIMB TRAINING ERROR: %f\n',err);
        end
        %}

        x = (M(:,nstart:n)*cur_g).*(M(:,nstart:n)*cur_f);
        target_DIH = target_DIH + M(:,1:offsets(BASE))*c + sum(C_test*x,2);
      end
    end
  end
  save(sprintf('cache/factor2_allpreds_m%d_hc%d_lambda%d.mat', ...
    m,HILLCLIMB,round(100000*LAMBDA)), 'target_DIH');
end
target_DIH = target_DIH / numpred;
target_DIH = exp(target_DIH)-1;
end
%TODO these functions make the arrays unsparse. Subtract the min value to
%make them sparse again
function x = condMap(x)
c=1.75;
x = sparse(log(x+c)-log(c));
end
function x = procMap(x)
c=1.1;
x = sparse(log(x+c)-log(c));
end
function x = drugMap(x)
c=0.5;
x = sparse(log(x+c)-log(c));
%x = log(sqrt(x)+6);
%x = sqrt(x);
end
function x = labMap(x)
%x = sparse(x.^1.1);
end
function x = losMap(x)
x = sparse(x.^0.78);
%x = sparse(x.^3.5);
%x = sqrt(x);
%x(:,27) = min(1,x(:,27));
end
function x = charlsonMap(x)
x = sparse(x.^0.9);
%x = sqrt(x);
%x = log(x+1);
end
function x = specMap(x)
%x = sqrt(x);
x = sparse(x.^0.79);
end
function x = placeMap(x)
%x = sqrt(x);
x = sparse(log(x+0.4)-log(0.4));
end
function x = nprovMap(x)
x = x.^1.6;
end
function x = nvendMap(x)
x=x.^0.9;
end
function x = ndrugMap(x)
x=x.^0.65;
end
function x = nlabMap(x)
x=x.^1.4;
end
function x = extralosMap(x)
x = x.^0.8;
end
function x = npcpMap(x)
x = x.^0.9;
end
function x = nclaimsMap(x)
x = x.^0.75;
end
function x = nspecMap(x)
x=x.^1.4;
end
function x = nplaceMap(x)
x=x.^0.8;
end
function x = nprocMap(x)
x=x.^1.5;
end
function x = ncondMap(x)
end
function [x] = extradsfsMap(x)
x=x.^1.5;
end
function [x] = excharMap(x)
end
function [x] = extraprobMap(x)
end
