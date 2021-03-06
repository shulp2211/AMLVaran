#!/bin/bash

#scripts="$( dirname "$0" )"
SCRIPT_DIR=$(readlink -f $0)
SCRIPT_DIR=${SCRIPT_DIR%/*}

dir=$1
sample=$2

mkdir -p $dir/varscan/bcf

echo "Processing sample ${sample} with VarScan"
if [ ! -f $dir/varscan/${sample}_indels.vcf ] || [ ! -f $dir/varscan/${sample}_snvs.vcf ] ; then

  if [ ! -f $dir/varscan/bcf/${sample}.bcf ] ; then
    samtools mpileup -f $GENOME $dir/${sample}.bam > $dir/varscan/bcf/${sample}.bcf
    if [ $? -ne 0 ]; then
      echo "Error VarScan: mpileup"
      rm $dir/varscan/bcf/${sample}.bcf
      exit 1
    fi
  fi
  
  varscan mpileup2snp $dir/varscan/bcf/${sample}.bcf > $dir/varscan/${sample}_snvs.vcf
  if [ $? -ne 0 ]; then
    echo "Error VarScan: mpileup2snp"
    rm $dir/varscan/${sample}_snvs.vcf
    exit 2
  fi
  
  varscan mpileup2indel $dir/varscan/bcf/${sample}.bcf > $dir/varscan/${sample}_indels.txt
  if [ $? -ne 0 ]; then
    echo "Error VarScan: mpileup2indel"
    rm $dir/varscan/${sample}_indels.txt
    exit 3
  fi

  python $SCRIPT_DIR/Convert_varscan.py $dir/varscan/${sample}_indels.txt $dir/varscan/${sample}_indels.vcf
fi

if [ -d $dir/varscan/bcf/ ] ; then
  rm -R $dir/varscan/bcf/
fi
