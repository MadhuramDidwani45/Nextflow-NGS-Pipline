process FASTQC{

    tag "$sample"

    publishDir("$params.fastqc_result", mode:'copy')

    input:
    tuple val(sample), path(reads)

    output:
    path "*_fastqc.{html,zip}"

    script:
    """
    fastqc $reads
    """
}