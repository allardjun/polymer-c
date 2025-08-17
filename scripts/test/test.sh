#!/bin/bash

d=$(date +%Y.%d.%m)

NStart=218
NEnd=220

what='single'

for NumSeg in $(seq $NStart $NEnd); do
  echo run.${what}.N${NumSeg}_${d}
done