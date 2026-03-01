include {FASTQ_DUMP} from './modules/fastq_dump'
include {FASTQC} from './modules/fastqc'
include {TRIMM} from './modules/trimmomatic'
include {TRIMMED_FASTQC} from './modules/trimmed_fastqc'
include {BOWTIE2_INDEX} from './modules/bowtie2_index'
include {BOWTIE2_ALIGN} from './modules/bowtie2_align'
include {SAMTOOLS} from './modules/samtools'
include {ADD_READ_GROUPS} from './modules/gatk_add_read_groups'
include {MARK_DUPLICATES} from './modules/gatk_markduplicates'
include {BQSR} from './modules/gatk_bqsr'
include {APPLY_BQSR} from './modules/gatk_applybqsr'
include {HAPLOTYPECALLER} from './modules/gatk_haplotypecaller'
include {VARIANT_FILTRATION} from './modules/gatk_variantfiltration'
include {VARIANT_ANNOTATOR} from './modules/gatk_variantannotator'
include {PREPARE_REFERENCE} from './modules/prepare_reference'

workflow {

    // 1.Create channel from sample input 
    sample_ch  = channel.fromPath(params.sample)

    // 2.Download FASTQ reads
    reads_ch   = FASTQ_DUMP(sample_ch)

    // 3.Run quality control on raw FASTQ reads
    FASTQC(reads_ch)

    // 4️.Trim adapters and low-quality bases
    trimmed_ch = TRIMM(reads_ch)

    // 5️.QC after trimming to confirm improvement
    TRIMMED_FASTQC(trimmed_ch)

    // 6️.Create channel for reference genome file
    ref_file     = channel.value(file(params.reference_genome))

    // 7️.Prepare reference (fasta index, dict, etc.)
    prepared_ref = PREPARE_REFERENCE(ref_file)

    // 8️.Known sites VCF for BQSR
    ks_file  = channel.value(file(params.known_sites))

    // 9️.Index file of known sites VCF
    ksi_file = channel.value(file(params.known_sites_index))

    // 10.Build Bowtie2 index
    index_ch = BOWTIE2_INDEX(ref_file)

    // 1️1.Align trimmed reads to reference genome
    align_ch = BOWTIE2_ALIGN(trimmed_ch, index_ch)

    // 1️2.Convert SAM to sorted/indexed BAM
    bam_ch = SAMTOOLS(align_ch)

    // 13.Add read group information
    rg_ch = ADD_READ_GROUPS(bam_ch)

    // 14.Mark duplicates
    (md_ch, metrics_ch) = MARK_DUPLICATES(rg_ch, ref_file)

    // 15.BaseRecalibration
    bqsr_ch = BQSR(md_ch, prepared_ref, ks_file, ksi_file)

    // 16. APPLY BaseRecalibration
    recal_bam_ch = APPLY_BQSR(bqsr_ch, prepared_ref)

    // 17. HAPLOTYPECALLER
    vcf_ch      = HAPLOTYPECALLER(recal_bam_ch, prepared_ref)

    // 18. VARIANT FILTRATION
    filtered_ch = VARIANT_FILTRATION(vcf_ch, prepared_ref)

    // 19. VARIANT ANNOTATOR
    annotated_ch = VARIANT_ANNOTATOR(
    filtered_ch.join(recal_bam_ch),
    prepared_ref
)
}