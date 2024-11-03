require 'net/http'
require 'json'
require 'yaml'
require 'uri'
require 'fileutils'

# Configuration
organization = 'neu-spiral' # Replace with your GitHub organization name
token = ENV['GITHUB_TOKEN'] # GitHub Personal Access Token (optional for higher limits)
# output_file = '../_data/repositories_scrape.yml' # Output YAML file path

potential_path_1 = File.expand_path("../../_data/repositories_scrape.yml", __dir__)
potential_path_2 = File.expand_path("../_data/repositories_scrape.yml", __dir__)

# Determine which path exists
output_file = if File.exist?(File.dirname(potential_path_1))
              potential_path_1
            else
              potential_path_2
            end

# Helper method to make paginated API requests
def fetch_all_data(base_uri, token = nil)
  data = []
  page = 1

  loop do
    uri = URI("#{base_uri}?page=#{page}&per_page=100") # Fetch 100 items per page
    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "token #{token}" if token

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.code.to_i != 200
      puts "Error fetching data: #{response.body}"
      break
    end

    page_data = JSON.parse(response.body)
    data.concat(page_data)

    break if page_data.empty? || page_data.length < 100 # Stop if there's no more data

    page += 1
  end

  data
end

# Fetch all repositories
repos = fetch_all_data("https://api.github.com/orgs/#{organization}/repos", token)

# Fetch all public members (only public members are visible without admin access)
members = fetch_all_data("https://api.github.com/orgs/#{organization}/members", token)

# Prepare YAML structure
data = {
  'github_users' => members.map { |member| member['login'] },
  'github_organizations' => [organization],
  'repo_description_lines_max' => 2,
  'github_repos' => repos.map { |repo| "#{organization}/#{repo['name']}" }
}

# Ensure _data directory exists
FileUtils.mkdir_p(File.join(__dir__, "../_data/"))

# Save YAML to the _data folder
File.open(output_file, 'w') { |file| file.write(data.to_yaml) }

puts "GitHub organization data has been saved to #{output_file}"

# Paths to YAML files

potential_path_1 = File.expand_path("../_data/repositories.yml", __dir__)
potential_path_2 = File.expand_path("../../_data/repositories.yml", __dir__)

file1 = File.exist?(File.dirname(potential_path_1)) ? potential_path_1 : potential_path_2

potential_path_1_scrape = File.expand_path("../_data/repositories_scrape.yml", __dir__)
potential_path_2_scrape = File.expand_path("../../_data/repositories_scrape.yml", __dir__)

file2 = File.exist?(File.dirname(potential_path_1_scrape)) ? potential_path_1_scrape : potential_path_2_scrape

potential_path_1_combined = File.expand_path("../_data/repositories_combined.yml", __dir__)
potential_path_2_combined = File.expand_path("../../_data/repositories_combined.yml", __dir__)

output_file = File.exist?(File.dirname(potential_path_1_combined)) ? potential_path_1_combined : potential_path_2_combined


# Load the YAML files
data1 = File.exist?(file1) ? YAML.load_file(file1) : {}
data2 = File.exist?(file2) ? YAML.load_file(file2) : {}

# Initialize merged data hash
merged_data = {
  'github_users' => [],
  'github_organizations' => [],
  'repo_description_lines_max' => 0,
  'github_repos' => []
}

# Merge the data, ignoring duplicates
merged_data['github_users'] = (data1['github_users'] || []).uniq | (data2['github_users'] || []).uniq
merged_data['github_organizations'] = (data1['github_organizations'] || []).uniq | (data2['github_organizations'] || []).uniq
merged_data['repo_description_lines_max'] = [data1['repo_description_lines_max'], data2['repo_description_lines_max']].compact.max
merged_data['github_repos'] = (data1['github_repos'] || []).uniq | (data2['github_repos'] || []).uniq

# Save the merged data
FileUtils.mkdir_p(File.dirname(output_file))
File.open(output_file, 'w') { |file| file.write(merged_data.to_yaml) }

puts "Merged GitHub data has been saved to #{output_file}"