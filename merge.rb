require 'json'
require 'rake'

CONFIG = JSON.parse(`parse-hocon global.conf`)

$dst = false
$srcs = []

def path(z, x, y)
  s = "#{CONFIG['SRC_DIR']}/#{z}/#{x}/#{y}.webp"
  if File.exist?(s)
    t = "#{CONFIG['TMP_DIR']}/#{z}-#{x}-#{y}.ppm"
    sh [
      "dwebp -ppm",
      s,
      "-o #{t}"
    ].join(' ')
    t
  else
    "#{CONFIG['TMP_DIR']}/nodata.ppm"
  end
end

def merge
  (z, x, y) = $dst
  dst_path = "#{CONFIG['DST_DIR']}/#{z}/#{x}/#{y}.webp"
  z = z + 1
  x = 2 * x
  y = 2 * y
  sh [
    "pnmcat",
    "-leftright",
    path(z, x, y),
    path(z, x + 1, y),
    "> #{CONFIG['TMP_DIR']}/top.ppm"
  ].join(' ')
  sh [
    "pnmcat",
    "-leftright",
    path(z, x, y + 1),
    path(z, x + 1, y + 1),
    "> #{CONFIG['TMP_DIR']}/bottom.ppm"
  ].join(' ')
  sh [
    "pnmcat",
    "-topbottom",
    "#{CONFIG['TMP_DIR']}/top.ppm",
    "#{CONFIG['TMP_DIR']}/bottom.ppm",
    "> #{CONFIG['TMP_DIR']}/all.ppm"
  ].join(' ')
  sh [
    "mkdir -p",
    File.dirname(dst_path)
  ].join(' ')
  sh [
    "cwebp -lossless -z 7",
    "#{CONFIG['TMP_DIR']}/all.ppm",
    "-o #{dst_path}"
  ].join(' ')
  sh "rm #{CONFIG['TMP_DIR']}/*-*-*.ppm"
end

while gets
  r = $_.strip.split(',').map {|v| v.to_i }
  merge if $dst && $dst != r[0..2]
  $srcs << r[3..5]
  $dst = r[0..2]
end

