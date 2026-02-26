process BOWTIE2_ALIGN {

    tag "$sample"

    publishDir "${params.alignment_dir}", mode: 'copy'

    input:
    tuple val(sample), path(r1), path(r2)
    tuple val(ref_id), path(index_files)

    output:
    tuple val(sample), path("${sample}.sam")

   script:
    """
    bowtie2 \
    --no-unal \
    -p ${task.cpus} \
    -x ${ref_id} \
    -1 ${r1} \
    -2 ${r2} \
    -S ${sample}.sam
    """
}