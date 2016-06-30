cwlVersion: draft-3
class: CommandLineTool

hints:
  - class: DockerRequirement
    dockerPull: biodckr/bwa
requirements:
  - class: InlineJavascriptRequirement

baseCommand: [bwa, mem]

arguments:
  - {prefix: "-t", valueFrom: $(runtime.cores)}
  - {prefix: "-R", valueFrom: "@RG\tID:$(inputs.group_id)\tPL:$(inputs.PL)\tSM:$(inputs.sample_id)"}

inputs:
  - id: reference
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.path.match(/(.*)\.[^.]+$/)[1])
    secondaryFiles:
      - ^.ann
      - ^.amb
      - ^.pac
      - ^.sa
  - id: reads
    type:
      type: array
      items: File
    inputBinding:
      position: 2
  - id: group_id
    type: string
  - id: sample_id
    type: string
  - id: PL
    type: string

stdout: $(inputs.reads[0].path.match(/\/([^/]+)\.[^/.]+$/)[1] + ".sam")

outputs:
  - id: aligned_sam
    type: File
    outputBinding:
      glob: $(inputs.reads[0].path.match(/\/([^/]+)\.[^/.]+$/)[1] + ".sam")
