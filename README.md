# findLDSNPs

**findLDSNPs** is a bash/mtSQL/awk script to obtain SNPs that are in linkage disequilibrium (LD) with the input list of SNPs using a user defined R2 or dprime values, and user defined window arround the SNP to look for linkage disequilibrium. LD calculations are based on 1000Genomes phased genomes phase 3 release.

First, script will check if ~/findLDSNPs_1000Genomes folder is present or not. If not it will create it. 

Next it will check if dbSNP file for human genome hg19 exists, if not, it will download it from snp150Common table using mysql.

Next, the script will find positions of snps from the input list provided as $1 by comparing to dbSNP database bed file snp150Common.bed using awk.

Then, the script will check if **PLINK** is present and if not it will download it and unzip it.

Next, the first loop will process all the autosomal chromosomes using **TABIX** and **PLINK** and the following code will process separately X and Y chromosomes as their vcf files are labeled differently. TABIX will use 1000 Genomes phase 3 vcf data available via FTP: ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/. 

Finally, the script will cut and filter the concatenated list of SNPs and LD SNPs and output it as $1.leadplusLD.cut

The R2 or DPRIME value used for PLINK to output the LD SNPs is provided as $2 and $3 parameters when running the script, e.g. type 0.8 R2 or 0.8 dprime.

#Example run

Input file:

<pre>
mpjanic@zoran:~/findLDSNPs_1000Genomes$ cat test_SNPs
rs75041078
rs10139550
rs62076439
rs4301033
rs143803699
rs1964272
rs2149821
rs2843152
rs602633
rs11898671
rs1333046
rs178002
rs17726488
rs72823056
rs68170813
rs6544713
rs57759964
rs11617955
rs781622
rs2048327
</pre>

