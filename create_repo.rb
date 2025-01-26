# frozen_string_literal: true

require "cr"
require "octokit"
require_relative "lib/comm"

personal_access_token =  ENV['GHP']
user_name = "initdc"

client = Octokit::Client.new(:access_token => personal_access_token)
user = client.user user_name

VER_GDRIVER.each do |ver_sym, url|
  ver = ver_sym.to_s
  repo_name = "VMAX_doc_#{ver}"
  client.create_repo(repo_name, private: false)
end
