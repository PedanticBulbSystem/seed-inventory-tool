#!/bin/bash

#for i in 321 322 323 324 325 
#for i in 326 327 328 329 340
for i in 330 331 332 333 334 335 336 337 338 339
do
  cat step1output/bx${i}.txt |\
  grep -v "^$" |\
  sed "s/^/BX ${i}||/" > step2output/bx${i}.txt
done
