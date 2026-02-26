include {FASTQ_DUMP} from './modules/fastq_dump'
include {FASTQC} from './modules/fastqc'
include {TRIMM} from './modules/trimmomatic'
include {TRIMMED_FASTQC} from './modules/trimmed_fastqc'
include {BOWTIE2_INDEX} from './modules/bowtie2_index'

workflow{

    sample_ch = channel.fromPath("$params.sample")
    FASTQ_DUMP(sample_ch)

    reads_ch = channel.fromFilePairs("$params.reads")
    FASTQC(reads_ch)

    TRIMM(reads_ch)

    TRIMMED_FASTQC(TRIMM.out)

    ref_ch = channel.fromPath("$params.reference_genome")
    BOWTIE2_INDEX(ref_ch)
}