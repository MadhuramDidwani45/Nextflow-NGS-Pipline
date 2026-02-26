process FASTQ_DUMP{

    tag "$sample"

    publishDir("$params.reads", mode: 'copy')

    input:
    val(sample)

    output:
    path "*"

    script:
    """
    fastq-dump --split-files --gzip $sample
    """
}