require 'json'
require 'find'

CONFIG = JSON.parse(`parse-hocon global.conf`)

task :nodata do
  sh "ppmmake '#0186a0' 256 256 > #{CONFIG['TMP_DIR']}/nodata.ppm"
end

task :produce do
  sh [
    "ruby list.rb |",
    #"head -n 100 |",
    "sort |",
    "ruby merge.rb"
  ].join(' ')
end

task :host do
  sh "budo -d docs"
end

task :style do
  sh "parse-hocon style.conf > docs/style.json"
  sh "gl-style-validate docs/style.json"
end

