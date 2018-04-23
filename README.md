# MR1
This repository contains scripts that reproduce a plot of the distributions of _MR1_ exon 4 inclusion-to-skip ratios across GTEx tissues starting [Snaptron](https://academic.oup.com/bioinformatics/article/34/1/114/4101942) queries. Refer to `query_and_generate_table.sh` for how the queries were generated. The _MR1_ transcript NM_001531 includes exon 4 and is distinguished by two junctions, the average of whose coverages we call A; NM_001195000 excludes exon 4 and is distinguished by one junction, whose coverage we call B. `query_and_generate_table.sh` outputs `isoform_ratio_table.tsv`, which lists for each GTEx sample our proxy `A / B` for the isoform ratio as well as corresponding tissue labels. The notebook `plots.nb` generates the final plot `histogramDensityPlot.pdf` from `isoform_ratio_table.tsv`. We ran it with Mathematica 10.4.1 and saved a PDF transcript as `plots.pdf`.
