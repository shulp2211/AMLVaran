#!/bin/bash

dir=$1
sample=$2

mkdir -p $dir/freebayes

echo "Processing sample ${sample} with FreeBayes"
if [ ! -f $dir/freebayes/${sample}\.vcf ] ; then
  freebayes -F 0.01 -f $GENOME $dir/${sample}.bam > $dir/freebayes/${sample}.vcf
  if [ $? -ne 0 ]; then
    echo "Error FreeBayes"
    rm $dir/freebayes/${sample}.vcf
    exit 1
  fi
fi

