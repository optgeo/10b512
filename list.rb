require 'json'
require 'find'

CONFIG = JSON.parse(`parse-hocon global.conf`)

Find.find(CONFIG['SRC_DIR']) {|path|
  next unless /(\d*)\/(\d*)\/(\d*)\.webp$/.match path
  (z, x, y) = [$1, $2, $3].map {|v| v.to_i}
  z512 = z - 1
  next if z512 == -1
  x512 = x / 2
  y512 = y / 2
  print [z512, x512, y512, z, x, y].join(','), "\n"
}
