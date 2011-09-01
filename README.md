# Ohai ROUS

RPMs of Unusual Significance

Adds the output of an rpm query to the node's ohai data.

## Adding your query

Add your query to the line:

stuff = `rpm -qa YOURQUERYHERE --queryformat "%{NAME},%{RELEASE}-%{VERSION},%{INSTALLTIME}\n"

for example:
```
stuff = `rpm -qa redhat* --queryformat "%{NAME},%{RELEASE}-%{VERSION},%{INSTALLTIME}\n"`
```

Your query can be anything that will legitimately run against your rpm database. 

## Adding this plugin to your Ohai

We're using `/etc/ohai/plugins` as our custom plugins dir for Ohai.  There's more infos on the chef wiki, in places like

- http://wiki.opscode.com/display/chef/Loading+Custom+Ohai+Plugins
- http://wiki.opscode.com/display/chef/Ohai

## What does it give you?

Right now, you get this:

```
{
  "rous": {
    "packages": {
      "redhat-menus": {
        "realname": "redhat-menus",
        "version": "3.el5-6.7.8",
        "installdate": "2011-02-04 12:33:02 -0500"
      },
      "redhat-release": {
        "realname": "redhat-release",
        "version": "5.6.0.3-5Server",
        "installdate": "2011-02-04 12:33:03 -0500"
      },
      "redhat-logos": {
        "realname": "redhat-logos",
        "version": "1-4.9.16",
        "installdate": "2011-02-04 12:33:03 -0500"
      },
      "redhat-lsb": {
        "realname": "redhat-lsb",
        "version": "2.1.4.el5-4.0",
        "installdate": "2011-02-04 12:34:03 -0500"
      },
      "redhat-release-notes": {
        "realname": "redhat-release-notes",
        "version": "36-5Server",
        "installdate": "2011-02-04 12:33:06 -0500"
      }
    }
  }
}

```


## Running from your command line

Like any Ohai plugin, run rous.rb from the command line with "ohai -f /path/to/rous.rb"

## Querying the node data with knife

This is where the cool stuff comes in.

`knife node show $HOSTNAME -a rous`

```
rous: 
  packages: 
    redhat-logos:         
      installdate:  2011-02-04 12:33:03 -0500
      realname:     redhat-logos
      version:      1-4.9.16
    redhat-lsb:           
      installdate:  2011-02-04 12:34:03 -0500
      realname:     redhat-lsb
      version:      2.1.4.el5-4.0
    redhat-menus:         
      installdate:  2011-02-04 12:33:02 -0500
      realname:     redhat-menus
      version:      3.el5-6.7.8
    redhat-release:       
      installdate:  2011-02-04 12:33:03 -0500
      realname:     redhat-release
      version:      5.6.0.3-5Server
    redhat-release-notes: 
      installdate:  2011-02-04 12:33:06 -0500
      realname:     redhat-release-notes
      version:      36-5Server
```

Next, knife search for a particular package:

`knife search node "packages:redhat*" -a rous`

```
1 items found

id:         myhost.example.com
rous_test: 
  packages: 
    redhat-logos:         
      installdate:  2011-02-04 12:33:03 -0500
      realname:     redhat-logos
      version:      1-4.9.16
    redhat-lsb:           
      installdate:  2011-02-04 12:34:03 -0500
      realname:     redhat-lsb
      version:      2.1.4.el5-4.0
    redhat-menus:         
      installdate:  2011-02-04 12:33:02 -0500
      realname:     redhat-menus
      version:      3.el5-6.7.8
    redhat-release:       
      installdate:  2011-02-04 12:33:03 -0500
      realname:     redhat-release
      version:      5.6.0.3-5Server
    redhat-release-notes: 
      installdate:  2011-02-04 12:33:06 -0500
      realname:     redhat-release-notes
      version:      36-5Server

```

Now try looking for all hosts with a package installed.  Watch the way the options change on the `-a ATTR` part. You key into the node data using . (period) for each key level.  The current version of this plugin does a substitution on package names that happen to have .'s in them, and makes those into _ (underscore). This behavior is a little unexpected, but using . in package names isn't really common.

```
$ knife search node "packages:redhat*" -a rous.packages.redhat-logos
1 items found

id:                               myhost.example.com
rous.packages.redhat-logos: 
  installdate:  2011-02-04 12:33:03 -0500
  realname:     redhat-logos
  version:      1-4.9.16
```

You can take it all the way down to the bottom leaves in the json, like `rous.packages.redhat-logos.version` for example.

## Future work

Look out for some companion knife plugin :D
