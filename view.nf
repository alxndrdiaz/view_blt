// Runs blobtools view from a bash script

nextflow.enable.dsl = 2

process test {
   
  container 'genomehubs/blobtoolkit:4.0.7'

  publishDir = [
    path: { "${params.outdir}" },
    mode: params.publish_dir_mode
  ]

  debug true
  input:
  path blobdir
  val  args

  script:
  """
  view.sh ${blobdir} "${blobdir}" "TRUE" "$args"
  """
}

workflow {

  test (
    "${params.dir}",
    "${params.args}"
  )

}
