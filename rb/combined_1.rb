require 'csv'

# Create an array to store the data from each of the CSV files
data = []

# Read data from each of the CSV files
CSV.foreach('../csv/COF.csv', headers: true) do |row|
  date = row['Date']
  stock1_volume = row['Volume'].to_i
  data << [date, stock1_volume]
end

CSV.foreach('../csv/DTST.csv', headers: true) do |row|
  date = row['Date']
  stock2_volume = row['Volume'].to_i
  index = data.index { |d| d[0] == date }
  if index
    data[index] << stock2_volume
  else
    data << [date, nil, stock2_volume]
  end
end

CSV.foreach('../csv/FRD.csv', headers: true) do |row|
  date = row['Date']
  stock3_volume = row['Volume'].to_i
  index = data.index { |d| d[0] == date }
  if index
    data[index] << stock3_volume
  else
    data << [date, nil, nil, stock3_volume]
  end
end

CSV.foreach('../csv/TGB.csv', headers: true) do |row|
  date = row['Date']
  stock4_volume = row['Volume'].to_i
  index = data.index { |d| d[0] == date }
  if index
    data[index] << stock4_volume
  else
    data << [date, nil, nil, nil, stock4_volume]
  end
end

CSV.foreach('../csv/TKR.csv', headers: true) do |row|
  date = row['Date']
  stock4_volume = row['Volume'].to_i
  index = data.index { |d| d[0] == date }
  if index
    data[index] << stock4_volume
  else
    data << [date, nil, nil, nil, nil, stock5_volume]
  end
end

CSV.foreach('../csv/UHS.csv', headers: true) do |row|
  date = row['Date']
  stock5_volume = row['Volume'].to_i
  index = data.index { |d| d[0] == date }
  if index
    data[index] << stock5_volume
  else
    data << [date, nil, nil, nil, nil, nil, stock6_volume]
  end
end


# Write the data to the adj_close CSV file

CSV.open('../csv/volume.csv', 'w', headers: ['Date', 'COF', 'DTST', 'FRD', 'TGB', 'TKR', 'UHS']) do |csv|
  # Write the headers
  csv << csv.headers
  # Write the data rows
  data.each do |row|
    csv << row
  end
end