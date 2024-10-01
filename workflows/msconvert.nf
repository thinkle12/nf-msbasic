#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process runMSconvert {
    container 'chambm/pwiz-skyline-i-agree-to-the-vendor-licenses'

    input:
    path raw_file

    output:
    path "${raw_file.simpleName}.mzML", emit: mzml

    // Specify dynamic publishDir and mode
    publishDir params.publishDir, mode: params.publishMode

    script:
    println(raw_file)
    // Set the volume mount dynamically in the Docker command
    """
    wine msconvert ${raw_file}
    """
}