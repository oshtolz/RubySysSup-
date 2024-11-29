require 'csv'
require 'gruff'

# Get the input file name from the command line argument
input_file = ARGV[0]

# Load data from CSV file
data = []
csv_path = File.expand_path("../csv/#{input_file}", __dir__)
CSV.foreach(csv_path, headers: true) do |row|
  data << [row['Date'], row['Close']]
end

# Filter data
data = data.select { |row| row[0].start_with?('2022', '2023', '2024') && row[1] != 'null' }

# Line chart 
g = Gruff::Line.new
g.title = "#{input_file.chomp('.csv').upcase} Stock Price in 2022 - 2024"
g.legend_font_size = 12

# Set data for chart
g.data('Close', data.map { |row| row[1].to_f })

# Labels for X-axis
labels = {}
data.each_with_index do |row, i|
  labels[i] = row[0][2..9]
end
g.labels = labels
g.label_rotation = -45
# Generate the output folder and file names
output_folder = File.expand_path("../output/#{input_file.chomp('.csv').upcase}", __dir__)
output_file = "#{output_folder}/#{input_file.chomp('.csv').upcase}_Close_2022-2024.png"

# Create the output folder if it doesn't exist
Dir.mkdir(output_folder) unless File.exist?(output_folder)

# Chart to file
g.theme_pastel
g.write(output_file)

puts "Chart saved to #{output_file}"