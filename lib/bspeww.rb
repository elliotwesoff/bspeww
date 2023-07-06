require 'json'

BSPWM_DUMP_FILE = '~/.bspeww/bspwm-state.json'.freeze

# class to parse and traverse bspwm state data
class Bspeww
  attr_reader :desktop_names

  def initialize
    @desktop_names = []
    @desktop_window_names = {}
  end

  def read
    contents = File.read(File.expand_path(BSPWM_DUMP_FILE))
    contents_json = JSON.parse(contents)
    desktops = contents_json['monitors'][0]['desktops'] # TODO
    desktops.each { |d| traverse_and_set(d) }
    @desktop_names = desktops.map { |d| d['name'] }
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
