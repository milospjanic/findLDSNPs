# findLDSNPs

**findLDSNPs** is a bash/mtSQL/awk script to obtain SNPs that are in linkage disequilibrium (LD) with the input list of SNPs using a user defined r2 value.

First, script will check if ~/1000Genomes_VCF_files_by_chr folder is present or not. If not it will create it. 

Next it will check if dbSNP file for human genome hg19 exists, if not, it will download it from snp150Common table using mysql.

Next, the script will find positions of snps from the input list provided as $1 by comparing to dbSNP database bed file snp150Common.bed using awk.

Then, the script will check if **PLINK** is present and if not it will download it and unzip it.

Next, 


