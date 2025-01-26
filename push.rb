# frozen_string_literal: true

require "cr"
require 'octokit'
require_relative "lib/dir"
require_relative "lib/comm"

E = 1
Einit = 21
Epush = 22

def no_large_file
  Cr.each_line("find . -type f -size +50M").empty?
end

def track_large_file
  Cr.run("find . -type f -size +50M -exec git lfs track {} \\;")
  Cr.run("git add .gitattributes")
end

Cr.run("git lfs install")

VER_GDRIVER.each do |ver_sym, url|
  ver = ver_sym.to_s
  filename = "#{ver}.zip"
  user_repo = "initdc/VMAX_doc_#{ver}"

  Cr.run("rm -rf #{OUTPUT_DIR}/#{ver}")
  Cr.run("mkdir -p #{OUTPUT_DIR}/#{ver}")
  Cr.run("unzip -q #{DOWNLOAD_DIR}/#{filename} -d #{OUTPUT_DIR}/#{ver}")

  Dir.chdir("#{OUTPUT_DIR}/#{ver}") do |dir|
    Cr.run("git init")
    Cr.run("git branch -M main")
    track_large_file unless no_large_file

    Cr.run("git add .")
    Cr.run("git commit -m 'chore: auto push VMAX doc #{ver}'")
    Cr.run("git remote add origin git@github.com:#{user_repo}.git")
    Cr.run("git push origin main -f")
  end

  Cr.run("rm -rf #{OUTPUT_DIR}/#{ver}")
end
