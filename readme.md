This is a quick re-tasking of an existing workflow to identify and download the nextclade dataset for sars-cov-2.  This allows users to update their datasets without using the "nextclade datasets get" command, bypassing certificate errors in environments behind a proxy.

The code was re-wrapped to be consistent with the existing "prepare_nextclade" rule in nextstrain, but it can also be used outside of the Nextstrain workflow.

#Usage:
```
update_nextclade_datasets.sh -n [dataset] -o [output directory]
  -n  Name of dataset (exampe: sars-cov-2)
  -o  Path to output files
```

Example custom rule to replace "prepare_datasets" command in nextstrain main_workflw.smk
```rule custom_prepare_nextclade:
    message:
        """
        Downloading reference files for nextclade (used for alignment and qc).
        """
    output:
        nextclade_dataset = directory("data/sars-cov-2-nextclade-defaults"),
    params:
        name = "sars-cov-2",
    conda: config["conda_environment"]
    shell:
        """
        workflow/snakemake_rules/update_nextclade_dataset.sh -n {params.name} -o {output.nextclade_dataset}
        """
```

Usage note: If you still have certificate errors, you can add the path to your cert file to the curl command in the update_nextclade_dataset.sh script
