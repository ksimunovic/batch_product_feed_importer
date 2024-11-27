def capture_stdout(&block)
  original_stdout = $stdout
  $stdout = StringIO.new
  block.call
  $stdout.string
ensure
  $stdout = original_stdout
end
