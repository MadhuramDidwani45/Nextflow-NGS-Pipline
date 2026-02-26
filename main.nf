include {FASTQ_DUMP} from './modules/fastq_dump'
include {FASTQC} from './modules/fastqc'
include {TRIMM} from './modules/trimmomatic'
include {TRIMMED_FASTQC} from './modules/trimmed_fastqc'
include {BOWTIE2_INDEX} from './modules/bowtie2_index'
include { BOWTIE2_ALIGN } from './modules/bowtie2_align'

workflow {

    sample_ch = channel.fromPath(params.sample)

    reads_ch = FASTQ_DUMP(sample_ch)

    FASTQC(reads_ch)

    trimmed_ch = TRIMM(reads_ch)

    TRIMMED_FASTQC(trimmed_ch)

    ref_ch = channel.fromPath(params.reference_genome)

    index_ch = BOWTIE2_INDEX(ref_ch)

    BOWTIE2_ALIGN(trimmed_ch, index_ch)
}