require 'csv'
require 'gruff'

# Read CSV data
data = CSV.read('csv/UHS_daily.csv', headers: true)

# Initialize arrays for x and y data
x_data = []
y_data = []

# Select the first day of data
date = Date.parse(data[0]['Date'])
x_data << date.strftime('%m/%d/%Y')
y_data << data[0]['Adj Close'].to_f

# Select every 7th day thereafter until end of data
data[7..-1].each_with_index do |row, i|
  if i % 7 == 2
    date = Date.parse(row['Date'])
    x_data << date.strftime('%m/%d/%Y')
    y_data << row['Adj Close'].to_f
  end
end

# Create line chart using Gruff gem
graph = Gruff::Line.new
graph.title = 'HRL Daily Adj Close'
graph.x_axis_label = 'Date'
graph.y_axis_label = 'Adj Close'

# Add x and y data to chart
graph.labels = Hash[x_data.each_with_index.map { |date, i| [i, date] }]
graph.data('Adj Close', y_data)

# Write chart to file
graph.write('UHS_line_chart.png')
