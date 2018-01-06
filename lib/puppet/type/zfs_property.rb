Puppet::Type.newtype(:zfs_property) do
  @doc = %{Manage properties on ZFS datasets.

    Autorequires Zfs resources for the dataset if present.

    Example:

        zfs { 'tank/storage':
          ensure      => 'present',
          compression => 'lz4',
        }

        zfs_property { 'org.custom.magic_feature':
          dataset => 'tank/storage',
          value   => 'on',
        }

    }

  ensurable

  newparam(:name) do
    desc "Property to manage"
  end

  newparam(:dataset) do
    desc "Dataset to manage property on"
  end

  newproperty(:value) do
    desc "Expected value for property"
  end

  autorequire(:zfs) do
    self[:dataset]
  end
end
