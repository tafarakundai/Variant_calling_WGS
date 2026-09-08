#!/bin/bash
#Applies VQSR models separately for SNPs and INDELs.
#--truth-sensitivity-filter-level 99.0 keeps ~99% of likely true variants (adjustable).
#Converts VQSLOD scores into PASS or FILTER labels.
#Merges SNPs + INDELs into a single final VCF.

# Load Required Modules
module load chpc/BIOMODULES
module add gatk/4.2.6.1

# Paths 
REF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/NIAB_ARS_BosIndicus_Tharparkar_1.0.fa"
SNP_VCF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.SNPs.vcf.gz"
INDEL_VCF="/mnt/lustre/users/mmalima/All_projects/AsianZebu/SNPs/cohort.INDELs.vcf.gz"

SNP_RECAL="SNP.recal"
SNP_TRANCHES="SNP.tranches"
INDEL_RECAL="INDEL.recal"
INDEL_TRANCHES="INDEL.tranches"

# Output files
SNP_VQSR="cohort.SNPs.VQSR.vcf.gz"
INDEL_VQSR="cohort.INDELs.VQSR.vcf.gz"
FINAL_VCF="cohort.VQSR.vcf.gz"

echo "Applying VQSR to SNPs..."
gatk ApplyVQSR \
  -R $REF \
  -V $SNP_VCF \
  --recal-file $SNP_RECAL \
  --tranches-file $SNP_TRANCHES \
  --truth-sensitivity-filter-level 99.0 \
  --mode SNP \
  -O $SNP_VQSR

echo "Applying VQSR to INDELs..."
gatk ApplyVQSR \
  -R $REF \
  -V $INDEL_VCF \
  --recal-file $INDEL_RECAL \
  --tranches-file $INDEL_TRANCHES \
  --truth-sensitivity-filter-level 99.0 \
  --mode INDEL \
  -O $INDEL_VQSR

echo "Merging SNPs and INDELs into final VCF..."
gatk MergeVcfs \
  -I $SNP_VQSR \
  -I $INDEL_VQSR \
  -O $FINAL_VCF

echo "Done!"
echo "Final VQSR-filtered VCF: $FINAL_VCF"

echo ""
echo "================================================"
echo "=== Final VCF Statistics ==="
echo "================================================"
echo "Total variants: $(zcat $FINAL_VCF | grep -cv '^#')"
echo "PASS variants: $(zcat $FINAL_VCF | grep -v '^#' | grep 'PASS' | wc -l)"
echo "Filtered variants: $(zcat $FINAL_VCF | grep -v '^#' | grep -v 'PASS' | wc -l)"
echo ""
echo "SNP statistics:"
echo "  Total SNPs: $(zcat $SNP_VQSR | grep -cv '^#')"
echo "  PASS SNPs: $(zcat $SNP_VQSR | grep -v '^#' | grep 'PASS' | wc -l)"
echo ""
echo "INDEL statistics:"
echo "  Total INDELs: $(zcat $INDEL_VQSR | grep -cv '^#')"
echo "  PASS INDELs: $(zcat $INDEL_VQSR | grep -v '^#' | grep 'PASS' | wc -l)"
echo "================================================"
