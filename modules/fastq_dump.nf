process FASTQ_DUMP{

    tag "$sample"

    publishDir("$params.reads", mode: 'copy')

    input:
    val(sample)

    output:
    tuple val("${sample.baseName.minus('.sra')}"), path("*_{1,2}.fastq.gz")

    script:
    """
    fastq-dump --split-files --gzip $sample
    """
}