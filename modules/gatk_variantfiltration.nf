process VARIANT_FILTRATION {

    tag "$sample"

    publishDir "${params.alignment_dir}", mode: 'copy'

    input:
    tuple val(sample), path(vcf)
    tuple path(reference), path(ref_fai), path(ref_dict)

    output:
    tuple val(sample), path("${sample}.filtered.vcf")

    script:
    """
    gatk VariantFiltration \\
        -R ${reference} \\
        -V ${vcf} \\
        -O ${sample}.filtered.vcf \\
        --filter-expression "QD < 2.0" \\
        --filter-name "LowQD" \\
        --filter-expression "FS > 60.0" \\
        --filter-name "HighFS"
    """
}