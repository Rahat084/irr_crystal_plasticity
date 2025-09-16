#!/bin/bash

output=$(echo $1 | sed 's/geo/msh/g')

gmsh $1 -3 -clscale $2 -o $output

echo 'created as' $output
