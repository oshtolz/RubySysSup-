require 'csv'
require 'gruff'

data = CSV.read('../csv/adj_close.csv', headers: true)

# Initialize arrays to hold the dates and volume values
dates = []
adj = {}

# Loop through each row of the data and extract the relevant columns
data.each do |row|
  date = row['Date'][0..6] # Only keep year and month, remove day
  dates << date

  # Loop through each column of the row and extract the volume value
  row.each do |column, value|
    next if column == 'Date' # Skip the Date column
    adj[column] ||= []
    adj[column] << value.to_f
  end
end

# Create line chart of Volume for each stock
line_chart = Gruff::Line.new
line_chart.marker_font_size = 12
line_chart.title = 'Adj Close comparison'
line_chart.labels = dates
line_chart.label_rotation = -45
adj.each do |stock, values|
  line_chart.data(stock, values)
end

line_chart.write('../output/Adj_line.png')
