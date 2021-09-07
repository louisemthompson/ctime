#!/usr/bin/env ruby

def matchLine line
  # Matches the line and extracts relevant data.
  # Returns a list of name and time, nil if invalid match.

  name = /\w{3,8}/  # matches name

  day = /Mon|Tue|Wed|Thu|Fri|Sat|Sun/ # matches day of week
  month = /Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec/   # matches month
  day_num = /\d|\d\d/ # matches day
  date = /#{day}\s#{month}\s*#{day_num}/  # full date match

  time = /\d\d:\d\d/  # matches 4 digit time
  finish_time = /#{time}|down/  # matches the finish time in range for vaild matches
  time_interval = /#{time}\s-\s#{finish_time}/ # matches time interval

  extra_day = /\d\+/  # matches extra day in elapsed time
  elapsed = /#{extra_day}?#{time}/ # matches elapsed time

  # full line match
  line_match = /(#{name})\s.*#{date}\s*#{time_interval}\s*\((#{elapsed})\)\s*/

  m

  # match for invalid names
  invalid_name = /(student|reboot)\w*/

  # returns nil if no match or reboot
  if match == nil or invalid_name.match(match[1]) != nil then
    return nil
  end

  # returns [name, elapsed time]
  return [match[1], match[2]]
end

def getTime times_list
  # Converts time list to total elapsed time

  days = 0
  hours = 0
  minutes = 0

  # match for time string
  time = /(\d?)\+?(\d\d):(\d\d)/

  for t in times_list
    match = time.match(t)

    # if exits a day, add day
    if match[1] != "" then
      days += match[1].to_i
    end

    # add hours and minutes
    hours += match[2].to_i
    minutes += match[3].to_i
  end

  # adjust hours and minutes
  hours += minutes / 60
  minutes = minutes % 60

  days += hours / 24
  hours = hours % 24

  # construct time string for total elapsed time
  time = ""
  if days != 0 then
    time += days.to_s + "+"
  end

  hr_str = "0"+hours.to_s
  min_str = "0"+minutes.to_s

  time += hr_str[-2..-1] + ":" + min_str[-2..-1]

  return time

end

# read all lines
lines = STDIN.readlines.map {|v| v.chomp}
data = {}   # relevant later
for line in lines
  dat_option = matchLine line

  if dat_option then
    name, time = dat_option

    if data[name] == nil  # add name to hash if does not already exist
      data[name] = [time]
    else
      data[name].concat([time]) # otherwise add time to time list
    end
  end
end

# gather all names and sort alphabetically
names = data.keys
names.sort!

# for each name get total time and modify output string
for n in names
  str_time = getTime data[n]
  str_name = n + " " * 12
  str_end = 12-(str_time.length - 7)
  print (str_name[0...str_end] + str_time + "\n")
end

# end of file
