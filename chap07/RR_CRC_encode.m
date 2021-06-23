function [checkvalue] = RR_CRC_encode(d,v,k,r)
% function w = RR_CRC_encode(d,v,k,r)
% Encodes the binary data vector d(z) using the cyclic basis polynomial v(z).
% Note: all polynomials ordered from highest power to zero'th power of z in vectors.
% INPUTS: d=vector of binary (logical) coefficients of the data polynomial
%         v=vector of binary (logical) coefficients of the basis polynomial 
%         k=number of data bits (size of d)
%         r=number of parity bits (r+1 = size of v)
% OUTPUT: w=vector of coefficients of the corresponding codeword polynomial
%         rem=check bits
% EXAMPLE CALL (encodes/decodes logical vectors using the CRC32 code):
%     k=16; r=3; (note: this demo code works for k+r<=64)
%     ds=sprintf('%d',rand(1,k)>.5), d=eval(strcat('0b',ds,'u64'))
      d=0b1101100111011010u32;
      v=0b1111u32 
%     [rem]=RR_CRC_encode(d,v,k,r);
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

% follows this:
% https://www.mathworks.com/help/matlab/matlab_prog/perform-cyclic-redundancy-check.html

v = bitshift(v,k-r-1); dec2bin(v)
v = bitshift(v,r);
rem = bitshift(d,r);
dec2bin(v)
dec2bin(rem)
for k = 1:k
  if bitget(rem,k+r), rem = bitxor(rem,v), end
  rem = bitshift(rem,1);
end
dec2bin(rem)
CRC_check_value = bitshift(rem,-k);
checkvalue=dec2bin(CRC_check_value)

rem = bitshift(d,r);
rem = bitor(rem,CRC_check_value);
rem = bitset(rem,6);
dec2bin(rem)
for k = 1:k
  if bitget(rem,k+r), rem = bitxor(rem,v); end
  rem = bitshift(rem,1);
end
if rem == 0
  disp('Message is error free.')
else
  disp('Message contains errors.')
end