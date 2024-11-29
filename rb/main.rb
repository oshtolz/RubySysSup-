require 'csv'
require 'terminal-table'
require 'gruff'

# Get the name of the CSV file from the command line arguments
input_file = ARGV[0]

# Read in the CSV data
csv_path = File.expand_path("../csv/#{input_file}", __dir__)
data = CSV.read(csv_path, headers: true)

# Initialize an empty array to hold the rows of the table
rows = []
dates = []
diffs = []

# Loop through each row of the data and extract the relevant columns
data.each do |row|
  date = row['Date'][0..6] # Only keep year and month, remove day
  open = row['Open'].to_f.round(2)
  close = row['Close'].to_f.round(2)
  diff = (close - open).round(2)
  rows << [date, open, close, diff]
  dates << date
  diffs << diff
end

# Create the table with the headers and rows
table = Terminal::Table.new(
  headings: ['Date', 'Open', 'Close', 'Open to Close Difference'],
  rows: rows
)

# Output the table to the console
puts table

# Create line chart of Open to Close Differences
line_chart = Gruff::Line.new
line_chart.title = 'Open to Close Differences 2022 - 2024'
line_chart.labels = dates
line_chart.label_rotation = -45
line_chart.data('Difference', diffs)

# Create bar chart of Open to Close Differences
bar_chart = Gruff::Bar.new
bar_chart.title = 'Open to Close Differences 2022 - 2024'
bar_chart.labels = dates
bar_chart.label_rotation = -45
bar_chart.data('Difference', diffs)

# Create directory for output files based on the CSV file name
output_folder = File.expand_path("../output/#{input_file.chomp('.csv').upcase}", __dir__)
output_line_file = "#{output_folder}/#{input_file.chomp('.csv').upcase}_Open_to_Close_line.png"
output_bar_file = "#{output_folder}/#{input_file.chomp('.csv').upcase}_Open_to_Close_bar.png"
Dir.mkdir(output_folder) unless File.exist?(output_folder)

# Save charts to output directory
line_chart.write(output_line_file)
bar_chart.write(output_bar_file)