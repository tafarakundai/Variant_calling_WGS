#!/usr/bin/bash
# ============================================================
# SIMPLIFIED VARIANT CALLING PIPELINE (for teaching purposes)
# Continues from *_dedup.bam produced by the earlier BAM prep script
# ============================================================

# 1. Define your files
REFERENCE=/mnt/tafara/NIAB_ARS_BosIndicus_Tharparkar_1.0.fa
SAMPLE=YPZ5
OUTDIR=/mnt/tafara/SNPs
DEDUP_BAM=$OUTDIR/${SAMPLE}_dedup.bam

mkdir -p $OUTDIR

# 2. Call variants per-sample with HaplotypeCaller (GVCF mode)
gatk HaplotypeCaller \
    -R $REFERENCE \
    -I $DEDUP_BAM \
    -O $OUTDIR/${SAMPLE}.g.vcf.gz \
    -ERC GVCF

echo "Done. Final GVCF: $OUTDIR/${SAMPLE}.g.vcf.gz"
