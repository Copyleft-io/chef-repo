The chef-repo
===============
All installations require a central workspace known as the chef-repo. This is a place where primitive objects--cookbooks, roles, environments, data bags, and chef-repo configuration files--are stored and managed.

The chef-repo should be kept under version control, such as [git](http://git-scm.org), and then managed as if it were source code.

Knife Configuration
-------------------
Knife is the [command line interface](https://docs.chef.io/knife.html) for Chef. The chef-repo contains a .chef directory (which is a hidden directory by default) in which the Knife configuration file (knife.rb) is located. This file contains configuration settings for the chef-repo.

The knife.rb file is automatically created by the starter kit. This file can be customized to support configuration settings used by [cloud provider options](https://docs.chef.io/plugin_knife.html) and custom [knife plugins](https://docs.chef.io/plugin_knife_custom.html).

Also located inside the .chef directory are .pem files, which contain private keys used to authenticate requests made to the Chef server. The USERNAME.pem file contains a private key unique to the user (and should never be shared with anyone). The ORGANIZATION-validator.pem file contains a private key that is global to the entire organization (and is used by all nodes and workstations that send requests to the Chef server).

More information about knife.rb configuration options can be found in [the documentation for knife](https://docs.chef.io/config_rb_knife.html).

Cookbooks
---------
A cookbook is the fundamental unit of configuration and policy distribution. A sample cookbook can be found in `cookbooks/starter`. After making changes to any cookbook, you must upload it to the Chef server using knife:

    $ knife upload cookbooks/starter

For more information about cookbooks, see the example files in the `starter` cookbook.

Roles
-----
Roles provide logical grouping of cookbooks and other roles. A sample role can be found at `roles/starter.rb`.

Getting Started
-------------------------
Now that you have the chef-repo ready to go, check out [Learn Chef](https://learn.chef.io/) to proceed with your workstation setup. If you have any questions about Chef you can always ask [our support team](https://www.chef.io/support/) for a helping hand.


The Copyleft chef-repo
=======================

Copyleft generally defaults to using Ubuntu (currently v14.04) or CentOS (currently v7) as our base Linux OS.

Ubuntu is a bit less conservative with a shorter release cycle, so new software will almost certainly land in the Ubuntu repos before CentOS users get it.

CentOS (RHEL) is fairly conservative when it comes to upgrading software, privileging consistency and security over being on the cutting edge.

copyleft-patterns
-----------------------
(Simple vs. Easy)
We believe in keeping things simple.
Here are a few things that we have learned during our time managing chef in the wild...

- Keep Role Assignment Simple... one role per node
- Keep Attributes Simple... by Cookbook (default) and by Environment (default)
- Keep Versioning Simple... version Cookbooks and manage their deployment by Environment
- ...more to come


copyleft cookbooks
-----------------------

    cookbooks/copyleft-base
    # This is our base cookbook that we use to bootstrap a node and layer additional cookbooks and roles
    # - install default packages
    # - configure security
    # - configure directory as a service (jumpcloud)
    # - configure zeus... our base user account for managing applications / services
    #   (if you are going to try and rule the clouds, you might as well invite the god of thunder)

    cookbooks/copyleft-burton
    # burton is our hubot (a.k.a. Jack Burton)

    cookbooks/copyleft-elkstack
    # base install of elk stack
    # - elastic
    # - logstash
    # - kibana
    # - beats (filebeats / topbeats)

    cookbooks/copyleft-java     
    # base install of java

    cookbooks/copyleft-nginx
    # base install of nginx

    cookbooks/copyleft-nodejs
    # base install of nodejs, npm, and pm2

    cookbooks/copyleft-postgres
    # base install and configuration of postgresql database

    cookbooks/copyleft-ruby
    # base install and configuration of ruby, rvm, ruby-gems and bundler

    cookbooks/copyleft-tomcat
    # base install and configuration of tomcat
