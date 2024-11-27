require_relative "lib/importer"

importer = Importer.new(
  filename: ARGV[0] || "files/feed.xml",
  batch_size_in_mb: ARGV[1] || 5,
  external_service: nil,
  benchmark_enabled: ARGV[2] == "1"
)

begin
  importer.call
rescue => e
  puts "An error occurred: #{e.message}"
end
