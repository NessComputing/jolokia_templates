def generate()
  $template = <<-eos
      "attributes": [
        {
          "name": "50thPercentile",
          "graph": {
            "name": "<Title>_50th_Percentile",
            "description": "<Title> 50th Percentile",
            "units": "ms",
            "type": "float"
          }
        },
        {
          "name": "75thPercentile",
          "graph": {
            "name": "<Title>_75th_Percentile",
            "description": "<Title> 75th Percentile",
            "units": "ms",
            "type": "float"
          }
        },
        {
          "name": "95thPercentile",
          "graph": {
            "name": "<Title>_95th_Percentile",
            "description": "<Title> 95th Percentile",
            "units": "ms",
            "type": "float"
          }
        },
        {
          "name": "99thPercentile",
          "graph": {
            "name": "<Title>_99th_Percentile",
            "description": "<Title> 99th Percentile",
            "units": "ms",
            "type": "float"
          }
        },
        {
          "name": "999thPercentile",
          "graph": {
            "name": "<Title>_999th_Percentile",
            "description": "<Title> 999th Percentile",
            "units": "ms",
            "type": "float"
          }
        },
        {
          "name": "Count",
          "graph": {
            "name": "<Title>s_Per_Second",
            "description": "<Title>s Per Second",
            "units": "<Title>s/Sec",
            "type": "uint32",
            "slope": "positive"
          }
        },
        {
          "name": "Max",
          "graph": {
            "name": "<Title>_Max",
            "description": "<Title> Max",
            "units": "ms",
            "type": "float"
          }
        }
      ]
    eos
  filedir = File.expand_path(File.dirname(__FILE__)) + "/"
  Dir.entries(filedir).each do |basename| 
    filename = filedir + basename
    if basename.length > 5 && filename[-5,5] == ".json"
      fullname = File.dirname(filename)
      # puts "basename #{basename} fullname #{fullname}, filename #{filename}"
      previousdir = fullname[0..fullname.rindex("/")]
      outputName = previousdir + basename
      outputFile = File.new(outputName, File::CREAT|File::TRUNC|File::RDWR, 0644)
      File.open(filename).each_line do |line|
        if line.include? "ResponseStatistics"
          title = line.split(" ").last
          temp = $template.gsub("<Title>", title)
          outputFile.puts(temp)
        else
          outputFile.puts(line)
        end
      end
    end
  end
end

generate()
