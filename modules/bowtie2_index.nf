process BOWTIE2_INDEX {

    tag "${fasta.simpleName}"

    publishDir "${params.index_dir}", mode: 'copy'
    
    input:
    path fasta

    output:
    tuple val(fasta.simpleName),
          path("${fasta.simpleName}*.bt2")

    script:
    """
    bowtie2-build ${fasta} ${fasta.simpleName}
    """
}