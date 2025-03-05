process CANSNPER2 {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'library://hjardin/bact_typing/cansnper2': null }"

    input:
    tuple val(meta), file(scaffolds)

    output:
    tuple val(meta), path('*_snps.txt')       , emit: snps
    tuple val(meta), path('*_not_called.txt') , emit: not_called
    tuple val(meta), path('*_tree.pdf')       , emit: tree
    path  'version.yml'                     , emit: versions

    script:
    fasta_name = scaffolds.getName().replace(".gz", "")
    def db          = params.path_db ? "${params.path_db}" : "${projectDir}/references/database/francisella_tularensis.db"
    def reference   = params.can_ref ? "${params.can_ref}" : "${projectDir}/references/can_ref/"
    """
    gunzip -c -d $scaffolds > $fasta_name
    CanSNPer2 \\
        $fasta_name \\
        --database ${db} \\
        --refdir ${reference} \\
        -o ./ \\
        --tmpdir ./tmp \\
        --summary

    cat <<-END_VERSIONS > version.yml
    "${task.process}":
        CanSNPer2: \$(echo \$(CanSNPer2 --version 2>&1) | sed 's/.*version \\([0-9.]\\+\\).*/\\1/')
    END_VERSIONS
    """
}