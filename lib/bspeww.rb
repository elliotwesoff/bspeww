require 'json'

# class to parse and bspwm state data. mainly to extract
# desktop names and their current open window names.
class Bspeww
  BSPEWW_FOLDER = '~/tmp/bspeww'.freeze
  DESKTOPS_FOLDER = "#{BSPEWW_FOLDER}/desktops".freeze

  def initialize
    @desktops = {}
    [BSPEWW_FOLDER, DESKTOPS_FOLDER].each do |path|
      FileUtils.mkdir_p(File.expand_path(path))
    end
  end

  def receive(bspc_data)
    process_bspc_data(bspc_data)
  end

  def write
    data_path = File.expand_path("#{DESKTOPS_FOLDER}/data")
    File.write(data_path, "#{output_data}\n", mode: 'a+')
  end

  private

  def process_bspc_data(bspc_data)
    desktops = bspc_data['monitors'][0]['desktops'] # TODO
    desktops.each { |d| traverse_and_set(d) }
  end

  def traverse_and_set(desktop)
    @desktops[desktop['name']] = traverse(desktop['root'])
  end

  # recursively traverse the child nodes of the bspwm node tree.
  def traverse(client)
    return '' if client.nil? # should only be when root is null - no open windows

    # it appears that bspwm maintains a *full* binary tree. since you probs
    # won't remember in the future, that means that a node has exactly 0 or
    # 2 children. the 'client' property contains the information regarding
    # a window, so if 'client' is not null, then it must not have any children
    # and we can stop recursing.
    return client['client']['instanceName'] unless client['client'].nil?

    # client is null, so there must be two children associated with this node.
    # traverse both of them and combine the window names into the result string.
    [traverse(client['firstChild']), traverse(client['secondChild'])].join('; ')
  end

  def selected_desktop
    `wmctrl -d | grep -F '*' | rev | cut -d ' ' -f 1 | rev`.strip
  end

  def output_data
    @desktops.merge(selected: selected_desktop).to_json
  end
end
