#!/usr/bin/env nextflow

nextflow.enable.dsl=2

process runMSFragger {
    container 'quay.io/biocontainers/msfragger:4.0--py312hdfd78af_1'

    input:
    path input_file
    path mfp
    path database

    output:
    path "${input_file.simpleName}.pepXML", emit: pepxml
    path "${input_file.simpleName}.pin", emit: pin

    // Specify dynamic publishDir and mode
    publishDir params.publishDir, mode: params.publishMode

    script:
    """
    fix_msfragger_parameters.py -p ${mfp} -d ${database}
    java -jar /usr/local/share/msfragger-4.0-1/MSFragger-4.0/MSFragger-4.0.jar ${mfp} ${input_file}
    """
}