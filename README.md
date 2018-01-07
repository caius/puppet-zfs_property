# caius/puppet-zfs\_property

This module allows you to manage properties on zfs datasets.

A gotcha to watch out for is it only pays attention to properties set on the local dataset - inherited properties behave as if they are absent.

### Usage

Pretty much just define the property & value you want on the dataset. `ensure` is respected for adding/removing the property.

```puppet
zfs_property { 'name.caius.test:enabled':
  dataset => 'tank/storage',
  value => 'on',
}
```

Aaaaand then:

```shell
$ [root@oscar ~]# zfs get name.caius.test:enabled tank/storage
NAME            PROPERTY                  VALUE   SOURCE
tank/storage    name.caius.test:enabled   on      local
```
