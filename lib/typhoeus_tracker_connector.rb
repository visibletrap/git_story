require 'nokogiri'
require 'typhoeus'

class TyphoeusTrackerConnector

  def initialize
    @hydra = Typhoeus::Hydra.new
  end

  def projects
    request = Typhoeus::Request.new(
        "http://www.pivotaltracker.com/services/v3/projects",
        headers: {'X-TrackerToken' => ENV['TRACKER_TOKEN']})
    request.on_complete do |response|
      doc = Nokogiri::XML(response.body)

      doc.xpath('//projects/project').map do |e|
        e.xpath('id').text.to_i
      end
    end
    @hydra.queue request
    @hydra.run
    request.handled_response
  end

  def current_state_of(stories, projects)
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
      @hydra.queue request
    end
    @hydra.run

    requests.inject({}) { |acc, r| acc.merge(r.handled_response) }
  end

end