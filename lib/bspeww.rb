require 'json'

# class to parse and bspwm state data. mainly to extract
# desktop names and their current open window names.
class Bspeww
  BSPEWW_FOLDER = '~/.bspeww'.freeze
  DESKTOPS_FOLDER = "#{BSPEWW_FOLDER}/desktops".freeze
  BSPWM_DUMP_FILE = "#{BSPEWW_FOLDER}/bspwm-state.json".freeze

  attr_reader :desktop_names

  def initialize
    @desktop_names = []
    @desktop_window_names = {}
    [BSPEWW_FOLDER, DESKTOPS_FOLDER].each do |path|
      FileUtils.mkdir_p(File.expand_path(path))
    end
  end

  def read
    contents = File.read(File.expand_path(BSPWM_DUMP_FILE))
    contents_json = JSON.parse(contents)
    desktops = contents_json['monitors'][0]['desktops'] # TODO
    desktops.each { |d| traverse_and_set(d) }
    @desktop_names = desktops.map { |d| d['name'] }
  end

  def write
    @desktop_window_names.each do |desktop_name, window_names|
      path = File.expand_path("#{DESKTOPS_FOLDER}/#{desktop_name}")
      File.write(path, "#{window_names}\n", mode: 'a+')
    end
  end

  def get_desktop(desktop_name)
    @desktop_window_names[desktop_name] || 'not found'
  end

  private

  def traverse_and_set(desktop)
    @desktop_window_names[desktop['name']] = traverse(desktop['root'])
  end

  def traverse(client)
    return '' if client.nil?
    return client['client']['className'] unless client['client'].nil?

    [traverse(client['firstChild']), traverse(client['secondChild'])].join('; ')
  end
end
