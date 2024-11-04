require 'net/http'
require 'json'
require 'yaml'
require 'uri'
require 'fileutils'

# Configuration
organization = 'neu-spiral' # GitHub organization name
team_slug = 'csl'            # Specific team slug
token = ENV['GITHUB_TOKEN']  # GitHub Personal Access Token (optional for higher limits)

# Output file path determination
potential_path_1 = File.expand_path("../../_data/repositories_scrape.yml", __dir__)
potential_path_2 = File.expand_path("../_data/repositories_scrape.yml", __dir__)

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
      puts "Error fetching data from #{uri}: #{response.body}"
      break
    end

    page_data = JSON.parse(response.body)
    data.concat(page_data)

    break if page_data.empty? || page_data.length < 100 # Stop if there's no more data

    page += 1
  end

  data
end

# Fetch all repositories associated with the specified team
team_repos_url = "https://api.github.com/orgs/#{organization}/teams/#{team_slug}/repos"
repos = fetch_all_data(team_repos_url, token)

# Check if any repositories were fetched
if repos.empty?
  puts "No repositories found for the team '#{team_slug}' in the organization '#{organization}'."
else
  puts "#{repos.length} repositories found for the team '#{team_slug}':"
  repos.each { |repo| puts "- #{repo['name']}" }
end

# Fetch all members of the specified team
team_members_url = "https://api.github.com/orgs/#{organization}/teams/#{team_slug}/members"
members = fetch_all_data(team_members_url, token)

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

puts "GitHub team data has been saved to #{output_file}"

# Load the YAML files (if needed, you can keep this part)
# ... [existing code for merging YAML files] ...


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
