#!/bin/bash
# ============================================================
# SIMPLIFIED JOINT GENOTYPING PIPELINE (for teaching purposes)
# Combines per-sample GVCFs into a GenomicsDB workspace, then
# genotypes them into a final VCF — shown for one chromosome
# ============================================================

REFERENCE=/mnt/All_projects/AsianZebu/NIAB_ARS_BosIndicus_Tharparkar_1.0.fa
WORK_DIR=/mnt/All_projects/AsianZebu/SNPs
GENOMICSDB_DIR=$WORK_DIR/genomicsdb_per_chromosome
OUTPUT_DIR=$WORK_DIR/vcf_per_chromosome
CHROM=NC_091760.1        # one chromosome, for teaching

mkdir -p $GENOMICSDB_DIR $OUTPUT_DIR

# 1. Import per-sample GVCF(s) into a GenomicsDB workspace for this chromosome
#    (add one -V per sample GVCF, e.g. -V YPZ5.g.vcf.gz -V sample2.g.vcf.gz ...)
gatk GenomicsDBImport \
    -V $WORK_DIR/YPZ5.g.vcf.gz \
    --genomicsdb-workspace-path $GENOMICSDB_DIR/$CHROM \
    -L $CHROM \
    -R $REFERENCE

# 2. Joint-genotype the samples in that workspace
gatk GenotypeGVCFs \
    -R $REFERENCE \
    -V gendb://$GENOMICSDB_DIR/$CHROM \
    -O $OUTPUT_DIR/$CHROM.vcf.gz

echo "Done. Final VCF: $OUTPUT_DIR/$CHROM.vcf.gz"
