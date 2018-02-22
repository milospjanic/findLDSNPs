# findLDSNPs

**findLDSNPs** is a bash/mySQL/awk script to obtain SNPs that are in linkage disequilibrium (LD) with the input list of SNPs using a user defined R2 or dprime values, and user defined window arround the SNP to look for linkage disequilibrium. LD calculations are based on 1000Genomes phased genomes phase 3 release.

First, script will check if ~/findLDSNPs_1000Genomes folder is present or not. If not it will create it. 

Next it will check if dbSNP file for human genome hg19 exists, if not, it will download it from snp150Common table using mysql.

Next, the script will find positions of snps from the input list provided as $1 by comparing to dbSNP database bed file snp150Common.bed using awk.

Then, the script will check if **PLINK** is present and if not it will download it and unzip it.

Next, the first loop will process all the autosomal chromosomes using **TABIX** and **PLINK** and the following code will process separately X and Y chromosomes as their vcf files are labeled differently. TABIX will use 1000 Genomes phase 3 vcf data available via FTP: ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/. 

Finally, the script will cut and filter the concatenated list of SNPs and LD SNPs and output it as $1.leadplusLD.cut

The R2 or DPRIME value used for PLINK to output the LD SNPs is provided as $2 and $3 parameters when running the script, e.g. type 0.8 R2 or 0.8 dprime.

findLDSNPs will firest obtain all SNPs in LD with R2 >= 0.2 and then filter according to the parameters given as $2 and $3 parameters.

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

Run with a R2 parameter and 0.7 threshold:
<pre>
mpjanic@zoran:~/findLDSNPs_1000Genomes$ ./rsID2bed.sh test_SNPs 0.7 R2
mpjanic@zoran:~/findLDSNPs_1000Genomes$ cat test_SNPs.leadplusLD.cut
	CHR_A	BP_A	SNP_A	CHR_B	BP_B	SNP_B	R2	DP
	1	2245570		rs2843152	1	2245439		rs2643902	0.86985	0.9919	
	1	2245570		rs2843152	1	2245570		rs2843152	1	1	
	1	2245570		rs2843152	1	2245633		rs2843151	0.860156	0.963399	
	1	68719672	rs2149821	1	68719672	rs2149821	1	1	
	1	68719672	rs2149821	1	68719796	rs2772262	0.703127	0.905807	
	1	109821511	rs602633	1	109821307	rs583104	0.959031	0.999107	
	1	109821511	rs602633	1	109821511	rs602633	1	1	
	10	73918058	rs17726488	10	73918058	rs17726488	1	1	
	13	110818102	rs11617955	13	110818102	rs11617955	1	1	
	14	100145710	rs10139550	14	100145710	rs10139550	1	1	
	17	40565926	rs72823056	17	40565916	rs72823055	0.643766	1	
	17	40565926	rs72823056	17	40565926	rs72823056	1	1	
	17	47404628	rs62076439	17	47404628	rs62076439	1	1	
	18	20078962	rs178002	18	20078962	rs178002	1	1	
	19	41877491	rs75041078	19	41877491	rs75041078	1	1	
	19	46190268	rs1964272	19	46190268	rs1964272	1	1	
	2	44073881	rs6544713	2	44073881	rs6544713	1	1	
	2	144159905	rs11898671	2	144159905	rs11898671	1	1	
	3	150042618	rs4301033	3	150042618	rs4301033	1	1	
	6	160863532	rs2048327	6	160863532	rs2048327	1	1	
	7	107259721	rs68170813	7	107259721	rs68170813	1	1	
	9	22124123	rs1333046	9	22124123	rs1333046	1	1	
	9	114927849	rs781622	9	114927849	rs781622	1	1	
  </pre>

Run with dprime parameter and 0.7 treshold. The run with dprime will be constricted to those SNPs with R2 value of 0.2 or greater.

<pre>
	1	2245570		rs2843152	1	2245439		rs2643902	0.86985	0.9919	
	1	2245570		rs2843152	1	2245570		rs2843152	1	1	
	1	2245570		rs2843152	1	2245633		rs2843151	0.860156	0.963399	
	1	68719672	rs2149821	1	68719672	rs2149821	1	1	
	1	68719672	rs2149821	1	68719796	rs2772262	0.703127	0.905807	
	1	109821511	rs602633	1	109821307	rs583104	0.959031	0.999107	
	1	109821511	rs602633	1	109821511	rs602633	1	1	
	10	73918058	rs17726488	10	73918058	rs17726488	1	1	
	13	110818102	rs11617955	13	110818102	rs11617955	1	1	
	14	100145710	rs10139550	14	100145710	rs10139550	1	1	
	17	40565926	rs72823056	17	40565916	rs72823055	0.643766	1	
	17	40565926	rs72823056	17	40565926	rs72823056	1	1	
	17	47404628	rs62076439	17	47404628	rs62076439	1	1	
	18	20078962	rs178002	18	20078962	rs178002	1	1	
	19	41877491	rs75041078	19	41877491	rs75041078	1	1	
	19	46190268	rs1964272	19	46190268	rs1964272	1	1	
	2	44073881	rs6544713	2	44073881	rs6544713	1	1	
	2	144159905	rs11898671	2	144159905	rs11898671	1	1	
	3	150042618	rs4301033	3	150042618	rs4301033	1	1	
	6	160863532	rs2048327	6	160863532	rs2048327	1	1	
	7	107259721	rs68170813	7	107259721	rs68170813	1	1	
	9	22124123	rs1333046	9	22124123	rs1333046	1	1	
	9	114927849	rs781622	9	114927849	rs781622	1	1	
	1	2245570		rs2843152	1	2245439		rs2643902	0.86985	0.9919	
	1	2245570		rs2843152	1	2245570		rs2843152	1	1	
	1	2245570		rs2843152	1	2245633		rs2843151	0.860156	0.963399	
	1	68719672	rs2149821	1	68719672	rs2149821	1	1	
	1	68719672	rs2149821	1	68719796	rs2772262	0.703127	0.905807	
	1	109821511	rs602633	1	109821307	rs583104	0.959031	0.999107	
	1	109821511	rs602633	1	109821511	rs602633	1	1	
	10	73918058	rs17726488	10	73918058	rs17726488	1	1	
	13	110818102	rs11617955	13	110818102	rs11617955	1	1	
	14	100145710	rs10139550	14	100145710	rs10139550	1	1	
	17	40565926	rs72823056	17	40565916	rs72823055	0.643766	1	
	17	40565926	rs72823056	17	40565926	rs72823056	1	1	
	17	47404628	rs62076439	17	47404628	rs62076439	1	1	
	18	20078962	rs178002	18	20078962	rs178002	1	1	
	19	41877491	rs75041078	19	41877491	rs75041078	1	1	
	19	46190268	rs1964272	19	46190268	rs1964272	1	1	
	2	44073881	rs6544713	2	44073881	rs6544713	1	1	
	2	144159905	rs11898671	2	144159905	rs11898671	1	1	
	3	150042618	rs4301033	3	150042618	rs4301033	1	1	
	6	160863532	rs2048327	6	160863532	rs2048327	1	1	
	7	107259721	rs68170813	7	107259721	rs68170813	1	1	
	9	22124123	rs1333046	9	22124123	rs1333046	1	1	
	9	114927849	rs781622	9	114927849	rs781622	1	1	
	1	2245570		rs2843152	1	2245439		rs2643902	0.86985	0.9919	
	1	2245570		rs2843152	1	2245570		rs2843152	1	1	
	1	2245570		rs2843152	1	2245633		rs2843151	0.860156	0.963399	
	1	68719672	rs2149821	1	68719672	rs2149821	1	1	
	1	68719672	rs2149821	1	68719796	rs2772262	0.703127	0.905807	
	1	68719672	rs2149821	1	68719816	rs2149820	0.395981	0.832203	
	1	109821511	rs602633	1	109821307	rs583104	0.959031	0.999107	
	1	109821511	rs602633	1	109821511	rs602633	1	1	
	10	73918058	rs17726488	10	73918058	rs17726488	1	1	
	13	110818102	rs11617955	13	110818102	rs11617955	1	1	
	14	100145710	rs10139550	14	100145710	rs10139550	1	1	
	17	40565926	rs72823056	17	40565916	rs72823055	0.643766	1	
	17	40565926	rs72823056	17	40565926	rs72823056	1	1	
	17	40565926	rs72823056	17	40566240	rs1968866	0.334468	0.957267	
	17	47404628	rs62076439	17	47404628	rs62076439	1	1	
	18	20078962	rs178002	18	20078962	rs178002	1	1	
	19	41877491	rs75041078	19	41877313	rs58351698	0.472226	0.99537	
	19	41877491	rs75041078	19	41877491	rs75041078	1	1	
	19	46190268	rs1964272	19	46190268	rs1964272	1	1	
	2	44073881	rs6544713	2	44073881	rs6544713	1	1	
	2	144159905	rs11898671	2	144159905	rs11898671	1	1	
	3	150042618	rs4301033	3	150042618	rs4301033	1	1	
	6	160863532	rs2048327	6	160863532	rs2048327	1	1	
	7	107259721	rs68170813	7	107259721	rs68170813	1	1	
	9	22124123	rs1333046	9	22124123	rs1333046	1	1	
	9	22124123	rs1333046	9	22124140	rs7857118	0.339367	1	
	9	114927849	rs781622	9	114927535	rs7875332	0.379275	0.996444	
	9	114927849	rs781622	9	114927849	rs781622	1	1	
	9	114927849	rs781622	9	114927942	rs6477883	0.408825	0.998329	
</pre>
