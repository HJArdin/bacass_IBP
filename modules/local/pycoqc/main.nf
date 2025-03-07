process PYCOQC {
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pycoqc:2.5.2--py_0' :
        'biocontainers/pycoqc:2.5.2--py_0' }"

    input:
    tuple val(meta), path(fast5)

    output:
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.json"), emit: json
    path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args        = task.ext.args ?: ''
    def prefix      = task.ext.prefix ?: "${meta.id}"
    // def run_summary = file("${fast5}/sequencing_summary.txt").exists() ? "cp ${fast5}/sequencing_summary.txt ./sequencing_summary.txt" : "Fast5_to_seq_summary -f $fast5 -t ${task.cpus} -s './sequencing_summary.txt' --verbose_level 2"
    def barcode_me  = file("${fast5}/barcoding_sequencing.txt").exists() ? "-b ${fast5}/barcoding_sequencing.txt" : ''

    """
    # Vérifie la présence de fichiers sequencing_summary*.txt
    summaryFiles=(\$(ls ${fast5}/sequencing_summary*.txt 2>/dev/null))
    if [ \${#summaryFiles[@]} -gt 0 ]; then
        cp \${summaryFiles[0]} ./sequencing_summary.txt
    else
        Fast5_to_seq_summary -f $fast5 -t ${task.cpus} -s './sequencing_summary.txt' --verbose_level 2
    fi
    
    pycoQC \\
        $args \\
        -f "sequencing_summary.txt" \\
        $barcode_me \\
        -o ${prefix}.html \\
        -j ${prefix}.json

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        pycoqc: \$(pycoQC --version 2>&1 | sed 's/^.*pycoQC v//; s/ .*\$//')
    END_VERSIONS
    """
}
