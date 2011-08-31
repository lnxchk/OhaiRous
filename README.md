# Ohai ROUS

Adds the output of an rpm query to the node's ohai data.

## Adding your query

Add your query to the line:

stuff = `rpm -qa YOURQUERYHERE`

Your query can be anything that will legitimately run against your rpm database. 

## Adding this plugin to your Ohai

We're using /etc/ohai/plugins as our custom plugins dir for Ohai.  There's more infos on the chef wiki, in places like

http://wiki.opscode.com/display/chef/Loading+Custom+Ohai+Plugins
http://wiki.opscode.com/display/chef/Ohai

## What does it give you?

Right now, you get this:

{
  "rous": {
    "packages": {
      "jdk-1.6.0_16-fcs": "null"
    }
  }
}

I'll be adding probably install date and maybe some different parsing for the versions eventually

## Running from your command line

Like any Ohai plugin, run rous.rb from the command line with "ohai -f /path/to/rous.rb"

## Querying the node data with knife

knife node show $HOSTNAME -a rous
