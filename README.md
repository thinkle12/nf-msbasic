# MSBasic Nextflow Pipeline

This repository is a pipeline for processing raw or mzML files through msconvert, msfragger, and percolator.

The workflow has the following logic
1. If raw files are provided as input, will process these files using msconvert converting them to mzML files
2. The mzML files are processed with MSFragger utilizing an input parameter file and fasta database
3. The pin output files are processed with Percolator and target/decoy PSM files are combined
4. The result is a pepXML file per input file and a pout file (Percolator output file) per input file as well

Some caveats
1. If raw files are provided the files are converted to mzML with msconvert
2. If mzML files are provided this step is skipped and mzML files are immediately processed with MSFragger
3. Input can be a comma separated string of files I.e. "file1.raw,file2.raw,file3.raw"
4. Or input can be a directory containing .raw or .mzML files like "/path/to/files/*.raw"
