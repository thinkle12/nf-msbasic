#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process runPercolator {
    container 'fcyucn/fragpipe:22.0'

    input:
    path pin_file

    output:
    path "${pin_file.simpleName}_combined.pout"

    // Specify dynamic publishDir and mode
    publishDir params.publishDir, mode: params.publishMode

    script:
    """
    /fragpipe_bin/fragPipe-22.0/fragpipe/tools/percolator_3_6_5/linux/percolator ${pin_file} -m "${pin_file.simpleName}_target.pout" -M "${pin_file.simpleName}_decoy.pout" -U
    combine_percolator_output.py -t "${pin_file.simpleName}_target.pout" -d "${pin_file.simpleName}_decoy.pout" -o "${pin_file.simpleName}_combined.pout"
    """
}