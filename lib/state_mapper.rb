require_relative 'renderer'

class StateMapper

  def execute(commit_story)
    Renderer.new.render(map(commit_story))
  end

  def map(story_commit)
    {}.tap do |h|
      fetch(story_commit.keys).each do |story, state|
        h[story_commit[story]] = {'story' => story, 'state' => state}
      end
    end
  end

  def fetch(stories)
    require 'rubygems'
    require 'net/http'
    require 'uri'
    require 'nokogiri'

    request = "http://www.pivotaltracker.com/services/v3/projects/#{ENV['TRACKER_PROJECT_ID']}/stories?filter=id:#{stories.join(',')}&includedone:true"
    resource_uri = URI.parse(request)
    response = Net::HTTP.start(resource_uri.host, resource_uri.port) do |http|
      http.get(resource_uri.to_s, {'X-TrackerToken' => ENV['TRACKER_TOKEN']})
    end

    doc = Nokogiri::XML(response.body)

    {}.tap do |h|
      doc.xpath('//stories/story').map do |e|
        h[e.xpath('id').text] = e.xpath('current_state').text.to_sym
      end
    end
  end

end