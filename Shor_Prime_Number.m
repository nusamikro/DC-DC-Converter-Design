
% 
% ==============================================================
%  Penggunaan Algoritma SHOR untuk Penentuan Bilangan Prima
%  -------------------------------------------------------------
%  Meinggunakan Menambahkan ToolBox Quantum-Computing 
%  pada Software MATLAB Desktop / Laptop anda
%  ( yang sudah saya coba : Versi 2025a atau 2025-B
% --------------------------------------------------------------
%  Contoh Program yang telah tersedia (saya salin di bawaah ini)
%  < https://tinyurl.com/3yxrau3j >
% --------------------------------------------------------------
%                    Bandung 22 Nopember 2025 
% ==============================================================
%
function cg = cswapGate(control,target1,target2)
  gates = [cxGate(3,2); ccxGate(1,2,3); cxGate(3,2)];
  cg = compositeGate(gates,[control target1 target2]);
end
%
% ---------------------------------------------------------------------------
%
function Ua = modexpUnitary(a,N)
% Construct a mod N based on these references:
% [1] Shor, P. https://doi.org/10.48550/arXiv.quant-ph/9508027.
% [2] Markov, I. L., and M. Saeedi. https://doi.org/10.48550/arXiv.1202.6614.
% [3] Tomčala, J. https://doi.org/10.1007/s10773-023-05532-4.
% For N = 15, the values for a are 2, 4, 7, 8, 11, 13.
% For N = 143, only a = 21 is considered.
% For N = 147, only a = 8 is considered.
% Qubit 1 is set as a control qubit, followed by m qubits as targets.

  % For N = 15, see figure 3 of [2]
  if N == 15
    switch a
      case 2
        Ua = [cswapGate(1,2,5); cswapGate(1,2,3); cswapGate(1,3,4)];
      case 4
        Ua = [cswapGate(1,2,4); cswapGate(1,3,5)];
      case 7
        Ua = [cxGate(1,2:5); cswapGate(1,3,4); cswapGate(1,2,3); cswapGate(1,2,5)];
      case 8
        Ua = [cswapGate(1,2,3); cswapGate(1,2,4); cswapGate(1,2,5)];
      case 11
        Ua = [cxGate(1,2:5); cswapGate(1,2,4); cswapGate(1,3,5)];
      case 13
        Ua = [cxGate(1,2:5); cswapGate(1,2,5); cswapGate(1,2,3); cswapGate(1,3,4)];
    end
  end

  % For N = 143, see figure 8 of [3]
  if N == 143
    switch a
      case 21
        Ua = [mcxGate([1 9],5,[]); mcxGate([1 9],7,[]); cxGate(1,5); ...
              mcxGate([1 5],6,[]); mcxGate([1 5],7,[]); mcxGate([1 5],9,[]); ...
              mcxGate([1 5 9],3,[]); mcxGate([1 5 9],4,[]); mcxGate([1 5 9],6,[]); ...
              mcxGate([1 5 9],7,[]); cxGate(1,[5 7]); mcxGate([1 5 6],3,[]); ...
              mcxGate([1 5 6],4,[]); mcxGate([1 7 9],5,[]); mcxGate([1 7 9],6,[]); ...
              cxGate(1,7)];
    end
  end

  % For N = 247, see figure 6 of [3]
  if N == 247
    switch a
      case 8
        Ua = [cswapGate(1,3,6); cswapGate(1,6,9); cswapGate(1,8,9); ccxGate(1,8,5); ...
              cswapGate(1,2,9); mcxGate([1 5 9],2,[]); mcxGate([1 5 9],4,[]); ...
              cswapGate(1,7,9); mcxGate([1 2 4],5,[]); mcxGate([1 7 9],6,[]); ...
              mcxGate([1 6 7],3,[]); mcxGate([1 6 7],4,[]); mcxGate([1 6 8],9,[]); ...
              mcxGate([1 3 5],4,[]); mcxGate([1 2 3],4,[]); mcxGate([1 2 3],5,[]); ...
              mcxGate([1 2 3],6,[]); mcxGate([1 2 3],9,[]); mcxGate([1 7 8],2,[]); ...
              mcxGate([1 7 8],4,[]); mcxGate([1 7 8],6,[]); cxGate(1,8); ...
              mcxGate([1 5 7 8],2,[]); mcxGate([1 5 7 8],3,[]); ...
              mcxGate([1 5 7 8],4,[]); mcxGate([1 5 7 8],6,[]); ...
              mcxGate([1 5 7 8],9,[]); cxGate(1,8:9); mcxGate([1 7 8 9],2,[]); ...
              mcxGate([1 7 8 9],5,[]); mcxGate([1 7 8 9],6,[]); cxGate(1,9); ...
              mcxGate([1 6 7 8],9,[]); cxGate(1,5:6); mcxGate([1 2 3 6],9,[]); ...
              mcxGate([1 5 6 9],2,[]); mcxGate([1 5 6 9],3,[]); cxGate(1,5:6)];
    end
  end
end
%
%
%
N = 15;
a = 7;
m = 4;
Ua = modexpUnitary(a,N);
initState = "1" + string(dec2bin(1,m))
%
%
gates = compositeGate(Ua,[1 2:(m+1)]);
c = quantumCircuit(gates);
state = initState;
for k = 1:5
  state = simulate(c,state);
  bitStr = char(formula(state))
  dec = bin2dec(bitStr(end-m:end-1))
end
%
%
%
N = 15
%
function aList = findCoprime(n)
  aList = [];
  for x = 2:(n-1)
    if gcd(x,n) == 1
      aList(end+1) = x;
    end
  end
end
%
%
%
aList = findCoprime(N);
a = aList(3)
%
%
n = 4;
m = ceil(log2(N-1));
%
%
UfQPE = [];
for k = 0:n-1
  Ua_2tok = compositeGate(repmat(modexpUnitary(a,N),2^k,1), ...
                          [n-k (n+1):(n+m)]);
  UfQPE = [UfQPE; Ua_2tok];
end
%
%
gates = [hGate(1:n); xGate(n+m)];
gates = [gates; UfQPE; inv(qftGate(1:n))];
c = quantumCircuit(gates);
figure
plot(c)
%
%
s = simulate(c);
figure
histogram(s,1:n,Threshold=0.02)
%
%
[states,probabilities] = querystates(s,1:n,Threshold=0.02);
%
%
phase = bin2dec(states)/2^n
%
[num,den] = rat(phase,1/2^(n+1))
%
%
found = false;
attempt = 1;
while ~found && attempt <= numel(den)
  r = den(attempt);
  if mod(r,2) == 0 && phase(attempt) ~= 0
      p = gcd(a^(floor(r/2))-1,N);
      q = gcd(a^(floor(r/2))+1,N);
      found = true;
  else
    attempt = attempt + 1;
  end
end
if found == true
  fprintf("Prime factors found: %d and %d \n", p, q);
else
  fprintf("No factors found. Choose different a.")
end
%
%
function [p,q] = findPrimeFactors(N,a)
  n = 7;
  m = ceil(log2(N-1));
  UfQPE = [];
  for k = 0:n-1
    Ua_2tok = compositeGate(repmat(modexpUnitary(a,N),2^k,1), ...
                            [n-k (n+1):(n+m)]);
    UfQPE = [UfQPE; Ua_2tok];
  end
  gates = [hGate(1:n); xGate(n+m)];
  gates = [gates; UfQPE; inv(qftGate(1:n))];
  c = quantumCircuit(gates);
  s = simulate(c);
  [states,probabilities] = querystates(s,1:n,Threshold=0.02);
  phase = bin2dec(states)/2^n;
  [num,den] = rat(phase,1/2^(n+1));
  found = false;
  attempt = 1;
  while ~found && attempt <= numel(den)
    r = den(attempt);
    if mod(r,2) == 0 && phase(attempt) ~= 0
      p = gcd(a^(floor(r/2))-1,N);
      q = gcd(a^(floor(r/2))+1,N);
      found = true;
    else
      attempt = attempt + 1;
    end
  end
  if found == true
    fprintf("Prime factors found: %d and %d \n", p, q);
  else
    p = 1;
    q = N;
    fprintf("No factors found. Choose different a.")
  end
end
%
%
[p,q] = findPrimeFactors(143,21)
%
[p,q] = findPrimeFactors(247,8)













