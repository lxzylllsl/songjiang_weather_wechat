# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "./log/cron_log.log"
# set :job_template, "/usr/bin/timeout 1800 /bin/bash -l -c ':job'"
job_type :runner,  "cd :path && timeout :timeout bin/rails runner -e :environment ':task' :output"

every 5.minutes do
  runner 'Radar.process', timeout: 50
end
