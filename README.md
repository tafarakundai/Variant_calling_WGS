# Variant_calling_WGS

# 1. Quality control
# 2. Alignment 
# 3. GenomicDB store
# 4. HaplotypeCaller 
Completed HaplotypeCaller, which generated GVCF files. These are single-sample variant files that contain:
All variant sites (SNPs, indels)
Non-variant sites (reference blocks)
Genotype likelihoods for each position
# 5. Joint Genotyping 
# 6. Split InDeLs and SNPS
# 7 Build VQSR model 
Uses the bootstrap seed sets as both training and truth resources.
Models the statistical patterns of “good” variants across multiple annotations:
SNPs: QD, MQ, MQRankSum, ReadPosRankSum, FS, SOR
INDELs: QD, FS, ReadPosRankSum, SOR
Creates recalibration files (.recal) and tranches (.tranches) that GATK will use to score each variant.
later use ApplyVQSR to filter variants based on chosen tranches.
# 7. Modeling (if you have no known varinats use BVQSR instead of VQSR)

