require 'nokogiri'
require 'typhoeus'

class TyphoeusTrackerConnector

  def initialize(project_ids = [], tracker_token)
    @hydra = Typhoeus::Hydra.new
    @project_ids = project_ids
    @token = tracker_token
  end

  def details_for(stories)
    stories_qs = stories.join(',')
    requests = []
    projects.each do |id, name|
      request = Typhoeus::Request.new(
          "http://www.pivotaltracker.com/services/v3/projects/#{id}/stories?filter=id:#{stories_qs}&includedone:true",
          headers: {'X-TrackerToken' => @token})

      request.on_complete do |response|
        doc = Nokogiri::XML(response.body)

        {}.tap do |h|
          doc.xpath('//stories/story').map do |e|
            h[e.xpath('id').text] = [name, e.xpath('current_state').text.to_sym]
          end
        end
      end

      requests << request
      @hydra.queue request
    end
    @hydra.run

    requests.inject({}) { |acc, r| acc.merge(r.handled_response) }
  end

  private
  def projects
    request = Typhoeus::Request.new("http://www.pivotaltracker.com/services/v3/projects", headers: {'X-TrackerToken' => @token})
    request.on_complete do |response|
      doc = Nokogiri::XML(response.body)

      {}.tap do |h|
        doc.xpath('//projects/project').map do |e|
          h[e.xpath('id').text.to_i] = e.xpath('name').text
        end
      end
    end
    @hydra.queue request
    @hydra.run

    all_projects = request.handled_response
    all_projects.select { |k,_| @project_ids.include?(k.to_s) } unless @project_ids.empty?
    all_projects
  end

end