process MARK_DUPLICATES {

    tag "$sample"

    publishDir "${params.alignment_dir}", mode: 'copy'

    input:
    tuple val(sample), path(bam), path(bai)
    path reference

    output:
    tuple val(sample), path("${sample}.markdup.bam"), path("${sample}.markdup.bam.bai")
    path "${sample}.metrics.txt"

    script:
    """
    gatk MarkDuplicates \
        -I ${bam} \
        -R ${reference} \
        -M ${sample}.metrics.txt \
        -O ${sample}.markdup.bam

    samtools index ${sample}.markdup.bam
    """
}