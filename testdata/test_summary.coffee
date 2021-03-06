SummaryReport  = require '../app/summary_report'
data = require './data/summary.json'
fs = require 'fs'

data.params =
  since: '2013-04-29'
  until: '2013-05-05'
  subgrouping: 'time_entries'
  grouping: 'projects'
  tag_names: 'Master, Productive, nobill'
  task_names: 'Top-secret, Trip to Tokio'

data.duration_format = 'decimal'

report = new SummaryReport(data)
report.output(fs.createWriteStream('summary.pdf'))
