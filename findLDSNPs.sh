
#!/bin/bash

SECONDS=0

FILE=~/findLDSNPs_1000Genomes/snp150Common.bed
DIR=~/findLDSNPs_1000Genomes
SNPS=$(pwd)/$1
echo Proccesing file:
echo $SNPS 

#check if working folder exist, if not, create

if [ ! -d $DIR ]
then
mkdir ~/findLDSNPs_1000Genomes
fi

cd ~/findLDSNPs_1000Genomes

#check if dbsnp file exists, if not, download from snp150Common table using mysql

if [ ! -f $FILE ]
then
mysql --user=genome --host=genome-mysql.cse.ucsc.edu -A -N -D hg19 -e 'SELECT chrom, chromStart, chromEnd, name FROM snp150Common' > snp150Common.bed
fi

#find positions of snps from the input list by comparing to snpdb
awk 'NR==FNR {h[$1] = 1; next} {if(h[$4]==1) print$0}' $SNPS snp150Common.bed > $1.bed

sed -i 's/chr//g' $1.bed


FILEPLINK="plink-1.07-x86_64.zip"
FILEBED=$1.bed
LD_SCORE=$2
LD_METRIC=$3

if [ ! -f $FILEPLINK ]
then

wget http://zzz.bwh.harvard.edu/plink/dist/plink-1.07-x86_64.zip
unzip plink-1.07-x86_64.zip
cp ./plink-1.07-x86_64/plink .
chmod 755 plink

fi


#for chr in {1..22}
#do

# if  [ ! -f genotypes_chr$chr.vcf ]
# then
#
# tabix -fh ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$chr.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz $chr > genotypes_chr$chr.vcf
# fi

#done

for file in `find . -name $FILEBED`
do
        filename=$(basename $file .bed)

        while read line; do
                set $line
                tabix -fh ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chr$1.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz $1:`expr $2 - 10000`-`expr $2 + 10000` > genotypes_chr$1_$4.vcf
                ./plink --vcf genotypes_chr$1_$4.vcf --ld-snp $4 --r2 dprime --ld-window-r2 0.5 --out ld_results_${filename}
        cat ld_results_${filename}.ld >> ${filename}.leadplusLD

        rm genotypes_chr$1_$4.vcf
        rm ld_results_${filename}.ld
        done < $file
done


grep X $FILEBED > $FILEBED.X
grep Y $FILEBED > $FILEBED.Y

for file in `find . -name $FILEBED.X`
do
        filename=$(basename $file .bed.X)

        while read line; do
                set $line
                tabix -fh ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz $1:`expr $2 - 10000`-`expr $2 + 10000` > genotypes_chr$1_$4.vcf
                ./plink --vcf genotypes_chr$1_$4.vcf --ld-snp $4 --r2 dprime --ld-window-r2 0.5 --out ld_results_${filename}.X
        cat ld_results_${filename}.X.ld >> ${filename}.leadplusLD

        rm genotypes_chr$1_$4.vcf
        rm ld_results_${filename}.X.ld
        done < $file
done

for file in `find . -name $FILEBED.Y`
do
        filename=$(basename $file .bed.Y)

        while read line; do
                set $line                
		tabix -fh ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrY.phase3_integrated_v2a.20130502.genotypes.vcf.gz $1:`expr $2 - 10000`-`expr $2 + 10000` > genotypes_chr$1_$4.vcf
                ./plink --vcf genotypes_chr$1_$4.vcf --ld-snp $4 --r2 dprime --ld-window-r2 0.5 --out ld_results_${filename}.Y
        cat ld_results_${filename}.Y.ld >> ${filename}.leadplusLD

        rm genotypes_chr$1_$4.vcf
        rm ld_results_${filename}.Y.ld
        done < $file
done


tabsep $SNPS.leadplusLD
grep -v CHR $SNPS.leadplusLD > $SNPS.leadplusLD.cut

if [ "$LD_METRIC" = "R2" ]
then
awk '{if ($7>"'"$LD_SCORE"'") printf $0"\n"}' $SNPS.leadplusLD.cut > $SNPS.leadplusLD.cut.select
fi

if [ "$LD_METRIC" = "dprime" ]
then
awk '{if ($8> "'"$LD_SCORE"'") printf $0"\n"}' $SNPS.leadplusLD.cut > $SNPS.leadplusLD.cut.select
fi

tabsep $SNPS.leadplusLD.cut.select
cut -f7 $SNPS.leadplusLD.cut.select > $SNPS.leadplusLD.final.list

