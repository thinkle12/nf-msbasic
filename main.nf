#!/usr/bin/env nextflow

nextflow.enable.dsl=2

params.files = []  // List of files to process, no default values
params.msfragger_parameters = ''
params.database = ''
params.publishDir = './output'  // Default publish directory
params.publishMode = 'link'  // Set default mode (link or move)

include { parseFileList } from './lib/utils.groovy'
include { runMSconvert } from './workflows/msconvert.nf'
include { runMSFragger } from './workflows/msfragger.nf'
include { runPercolator } from './workflows/percolator.nf'

// Main workflow
workflow {

    // Handle the input files as either a list of files or directory *.raw
    def fileList = params.files instanceof String ? parseFileList(params.files) : params.files

    println fileList

    if (fileList.every { it.endsWith('.raw') }) {
        // All files end in '.raw'
        Channel.from(fileList)
            .set { rawFileChannel }

        runMSconvert(rawFileChannel)
            .set { msConvertChannel }

        // Collate to make sure we run 1 instance of MSFragger per output file from MSconvert
        msConvertChannel.collate( 1, 1 )
            .set { mzMLFileChannel }

    } else if (fileList.every { it.endsWith('.mzML') }) {
        // All files end in '.mzML', skip MSconvert step
        Channel.from(fileList)
            .set { mzMLFileChannel }

    } else {
        throw new IllegalArgumentException("All files must either end in '.raw' or '.mzML'")

    }

    // Run MSFragger
    def resultFilesMsFragger = runMSFragger(mzMLFileChannel, params.msfragger_parameters, params.database).pin

    // Collate to make sure we run 1 instance of Percolator per output file from MSFragger
    resultFilesMsFragger.collate( 1, 1 )
        .set { filteredPinChannelCollated }

    // Run Percolator
    def resultFilesPercolator = runPercolator(filteredPinChannelCollated)

}