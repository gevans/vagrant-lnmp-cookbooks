## Vagrant LNMP Cookbooks

### Usage

Add this repository to your project as a git submodule:

```bash
$ git submodule add git://github.com/gevans/vagrant-lnmp-cookbooks.git cookbooks
```

Copy the `Vagrantfile.sample` to the root of your project as `Vagrantfile`:

```bash
$ cp /path/to/project/cookbooks/Vagrantfile.sample /path/to/project/Vagrantfile
```

Customize your Vagrantfile as needed and when ready, run `vagrant up`. Grow a
beard while waiting for the VM to provision. Once it's finished, access your
project at [http://33.33.33.10/](http://33.33.33.10/).