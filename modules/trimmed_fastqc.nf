process TRIMMED_FASTQC{

    tag "$sample"

    publishDir("$params.trimmed_fastqc_result", mode:'copy')

    input:
    tuple val(sample), path(r1), path(r2)

    output:
    path "*_fastqc.{html,zip}"

    script:
    """
    fastqc $r1 $r2
    """
}