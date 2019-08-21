#!/bin/sh
SBATCH -n 8
SBATCH -t 12:00:00
SBATCH -p compute
SBATCH -J sw_q2

samples=100000
q=2
size=16
temps=40
beta_start=0
beta_end=1
beta_increment=`echo "scale=4; $beta_end/$temps" | bc`
beta=$beta_start

directory_name="SW_q_${q}_size_${size}"
mkdir $directory_name
for ((i = 0; i <= $temps; i++ ))
  do 
  	echo $beta
  	filename="${directory_name}/${directory_name}_beta_${beta}.txt"
    mpirun -n 8 ./swprog -x $size -y $size -z $size -q $q -b $beta -f $filename -s $samples
    beta=`echo "scale=4; $beta+$beta_increment" | bc`
 done
 
beta=$beta_start
output_filename="${directory_name}_magnetization.txt"
for ((i = 0; i <= $temps; i++ ))
  do 
  	input_filename="${directory_name}/${directory_name}_beta_${beta}.txt"
    python jackknife.py $input_filename $output_filename $beta
    beta=`echo "scale=4; $beta+$beta_increment" | bc`
 done
