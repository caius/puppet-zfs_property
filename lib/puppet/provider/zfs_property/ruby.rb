Puppet::Type.type(:zfs_property).provide(:ruby) do
  desc "Provider to manage a zfs dataset property"

  commands :zfs => 'zfs'

  # @public
  def exists?
    zfs_get(resource[:dataset], resource[:name]) != nil
  end

  # @public
  def create
    set_value(resource[:value])
  end

  # @public
  def destroy
    zfs(:inherit, resource[:name], resource[:dataset])
  end

  # @public
  def value
    result = zfs_get(resource[:dataset], resource[:name])
    result.value if result && result.set?
  end

  # @public
  def value=(value)
    set_value(value)
  end

  # @private sets the value via zfs command
  def set_value(value)
    zfs(:set, "#{resource[:name]}=#{value}", resource[:dataset])
  end

  # @private
  class PropertyResult
    attr_accessor :dataset, :name, :value, :source

    def self.from_output(line)
      new(*line.split(/\s+/, 4))
    end

    def initialize(dataset, name, value, source)
      @dataset = dataset
      @name = name
      @value = value
      @source = source
    end

    def set?
      source != "-"
    end
  end

  # @private
  # @returns PropertyResult
  def get_value(dataset, name)
    output = zfs(:get, "-H", name, dataset)
    PropertyResult.from_output(output)
  rescue Puppet::ExecutionFailure => e
    Puppet.debug("Error getting zfs property #{name.inspect} from #{dataset.inspect}: #{e.inspect}")
    return
  end
end
