// lib/utils.groovy

import groovy.io.FileType

List<String> parseFileList(String files) {
    if (files.contains(',')) {
        return files.split(',')
    } else {
        def pattern = files
        def dir = new File(pattern).parentFile
        def glob = pattern.substring(pattern.lastIndexOf('/') + 1)
        def fileList = []
        dir.eachFile(groovy.io.FileType.FILES) { file ->
            if (file.name.matches(glob.replace('*', '.*'))) {
                fileList << file.path
            }
        }
        return fileList
    }
}