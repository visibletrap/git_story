class TrackerFetchedMapper

  def initialize(renderer)
    @renderer = renderer
  end

  def execute(story_commit)
    @renderer.render(map(story_commit))
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
    require 'typhoeus'

    hydra = Typhoeus::Hydra.new

    projects = ENV['TRACKER_PROJECT_ID'].split(",")
    stories_qs = stories.join(',')

    requests = []
    projects.each do |project_id|
      request = Typhoeus::Request.new(
        "http://www.pivotaltracker.com/services/v3/projects/#{project_id}/stories?filter=id:#{stories_qs}&includedone:true",
        headers: {'X-TrackerToken' => ENV['TRACKER_TOKEN']})

      request.on_complete do |response|
        doc = Nokogiri::XML(response.body)

        {}.tap do |h|
          doc.xpath('//stories/story').map do |e|
            h[e.xpath('id').text] = e.xpath('current_state').text.to_sym
          end
        end        
      end

      requests << request
      hydra.queue request
    end
    hydra.run

    requests.inject({}){|acc, r| acc.merge(r.handled_response) }
  end

end