#!/bin/bash
#PBS -l nodes=1:ppn=8
#PBS -l walltime=06:00:00
#PBS -l mem=150gb
#PBS -S /bin/bash
#PBS -N cell_states
#PBS -o /beegfs/work/hd_wh241/MI_revisions/analysis/jobs/get_dfuncs_cardio.out
#PBS -e /beegfs/work/hd_wh241/MI_revisions/analysis/jobs/get_dfuncs_cardio.err
#PBS -q smp
#PBS -m bea
#PBS -M roramirezf@uni-heidelberg.de

source ~/.bashrc;
conda activate sc_analysis;
cd /beegfs/work/hd_wh241/MI_revisions;

mkdir ./results/ct_data/cardiomyocyte;

$CONDA_PREFIX/bin/Rscript ./analysis/3_functional_characterization/add_funcomics_largedata.R \
        --data_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_states.rds" \
        --out_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_states.rds" \
        --group_class "opt_state" \
        --gene_set_collection "not";    

$CONDA_PREFIX/bin/Rscript ./analysis/3_functional_characterization/estimate_dea.R \
        --data_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_states.rds" \
        --out_df "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_dea.rds" \
        --test_assays "RNA,progeny,dorothea" \
        --group_class "opt_state" \
        --lfc "0.20" \
        --only_pos "yes";

$CONDA_PREFIX/bin/Rscript ./analysis/3_functional_characterization/plot_funcomics.R \
        --data_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_states.rds" \
        --dea_data_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte_dea.rds" \
        --nfeats 10 \
        --ngenes_ORA 10 \
        --pvalue_ORA 0.15 \
        --pvalue 0.001 \
        --lfc 0.5 \
        --test_assays "RNA,progeny,dorothea" \
        --group_class "opt_state" \
        --out_path "/beegfs/work/hd_wh241/MI_revisions/results/ct_data/cardiomyocyte/cardiomyocyte";
