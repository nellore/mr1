#!usr/bin/env bash
# This script takes one command-line parameter, the path to
# Snaptron's qs tool from commit e1f039726799aad943af45985c289c1d4d900d15
# of https://github.com/ChristopherWilks/snaptron-experiments .
QS=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# We ran 
mysql -h genome-mysql.cse.ucsc.edu -A -u genome -D hg38 -e 'select * from refGene where name="NM_001531"\G'
# to observe that the distinguishing exon-exon junctions of
# the MR1 transcript NM_001531 are
# chr1+;181050287-181052234 and chr1+;181052511-181053572
# in 1-based inclusive coordinates.
# We ran
mysql -h genome-mysql.cse.ucsc.edu -A -u genome -D hg38 -e 'select * from refGene where name="NM_001195000"\G'
# to observe that the distinguishing exon-exon junction of
# the MR1 transcript NM_001195000 is
# chr1+;181050287-181053572
# in 1-based inclusive coordinates; this reflects a skipped exon 5
# from NM_001531 .
# We would like to rank the junction inclusion ratio (defined in the Snaptron)
# paper https://academic.oup.com/bioinformatics/article/34/1/114/4101942)
# between NM_001531 and NM_001195000 across GTEx. To this end, we refer to the
# Snaptron manual and use the command-line tool qs from commit
# e1f039726799aad943af45985c289c1d4d900d15 of https://github.com/ChristopherWilks/snaptron-experiments
# as follows.
$QS --query-file $DIR/jir_query.tsv --function jir --datasrc gtex >gtex_output.tsv
# Recompute JIR using normalized coverage values; this matters because the JIR Snaptron computes has a small
# correction \epsilon in the denominator, and it needs to be in units of normalized coverage but is not
# when JIR is computed using raw coverage as Snaptron does; use sed to dodge awk's sensitivity to %'s'
sed 's/%/\x1d/g' gtex_output.tsv | awk -F "\t" 'NR == 1 {$2 = "MR1:NM_001195000 normalized count"; $3 = "MR1:NM_001531 normalized count"; for (i=1; i<NF; i++) {printf $i "\t"}; print $NF} NR > 1 {$2 = $2 / $312 * 4000000000; $3 = $3 / $312 * 4000000000; $1 = ($3 - $2) / ($3 + $2 + 1); for (i=1; i<NF; i++) {printf $i "\t"}; print $NF}' | sed 's/\x1d/%/g' | sort -k1,1g >ranked_gtex_output.tsv
