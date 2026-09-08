#!/bin/bash
# Uses the bootstrap seed sets as both training and truth resources.
#Models the statistical patterns of “good” variants across multiple annotations:
#SNPs: QD, MQ, MQRankSum, ReadPosRankSum, FS, SOR
#INDELs: QD, FS, ReadPosRankSum, SOR
#Creates recalibration files (.recal) and tranches (.tranches) that GATK will use to score each variant.
#later use ApplyVQSR to filter variants based on chosen tranches.

# Load Required Modules
module load chpc/BIOMODULES
module add gatk/4.2.6.1

# Paths
REF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/NIAB_ARS_BosIndicus_Tharparkar_1.0.fa"
SNP_VCF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.SNPs.vcf.gz"
INDEL_VCF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.INDELs.vcf.gz"
SNP_SEED="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.SNPs.seed.vcf.gz"
INDEL_SEED="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.INDELs.seed.vcf.gz"

# Output files
SNP_RECAL="SNP.recal"
SNP_TRANCHES="SNP.tranches"

INDEL_RECAL="INDEL.recal"
INDEL_TRANCHES="INDEL.tranches"

echo "Building SNP VQSR model..."

gatk VariantRecalibrator \
  -R $REF \
  -V $SNP_VCF \
  --resource:myTrain,known=false,training=true,truth=true,prior=15.0 $SNP_SEED \
  -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR \
  --mode SNP \
  --max-gaussians 6 \
  -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 97.0 -tranche 95.0 \
  -O $SNP_RECAL \
  --tranches-file $SNP_TRANCHES

echo "Building INDEL VQSR model..."

gatk VariantRecalibrator \
  -R $REF \
  -V $INDEL_VCF \
  --resource:myTrainIndel,known=false,training=true,truth=true,prior=12.0 $INDEL_SEED \
  -an QD -an FS -an ReadPosRankSum -an SOR \
  --mode INDEL \
  --max-gaussians 4 \
  -tranche 100.0 -tranche 99.9 -tranche 99.0 -tranche 97.0 \
  -O $INDEL_RECAL \
  --tranches-file $INDEL_TRANCHES

echo "Done!"
echo "SNP recalibration file: $SNP_RECAL"
echo "INDEL recalibration file: $INDEL_RECAL"
