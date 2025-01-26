# frozen_string_literal: true

require "cr"
require_relative "lib/dir"
require_relative "lib/comm"

def wget(url, filename)
  return unless Cr.system?("wget -cq -O #{WGET_TEMP_DIR}/#{filename}.wgettemp '#{url}'")

  Cr.run("mv #{WGET_TEMP_DIR}/#{filename}.wgettemp #{DOWNLOAD_DIR}/#{filename}")
end

def gdown(url, filename)
  return unless Cr.system?("gdown -c -O #{GDOWN_TEMP_DIR}/#{filename}.gdowntemp '#{url}'")

  Cr.run("mv #{GDOWN_TEMP_DIR}/#{filename}.gdowntemp #{DOWNLOAD_DIR}/#{filename}")
end

# main
Cr.run("mkdir -p #{WORK_DIR} #{WGET_TEMP_DIR} #{GDOWN_TEMP_DIR} #{DOWNLOAD_DIR} #{OUTPUT_DIR}")

VER_GDRIVER.each do |ver_sym, url|
  ver = ver_sym.to_s
  filename = "#{ver}.zip"
  gdown(url, filename)
  sleep(10)
end
