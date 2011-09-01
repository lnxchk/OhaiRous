#
# rous.rb
#
# "RPMs of Unusual Significance"
# 
# runs an rpm query and dumps the package output into the node data
# the json key in the node data is "rous" but this method could be forked
# to create different keys for different groups of packages
#
# lnxchk 31 AUG 11


provides "rous"

rous Mash.new


stuff = `rpm -qa YOURQUERYHERE --queryformat "%{NAME},%{RELEASE}-%{VERSION},%{INSTALLTIME}\n"`
# an example
# rpm -qa redhat* --queryformat "%{NAME},%{RELEASE}-%{VERSION},%{INSTALLTIME}\n"`

mystuff = Hash.new
stuff.split("\n").each do |line|

  pieces = line.split(/,/)
  name = pieces[0].dup
  # subbing . for _ because you can't key back into the node data with knife if
  # your package names have .'s in them.  this is a haxxxy solution right now. our
  # custom stuff has some odd naming conventions that use . in the pkg name.
  name.gsub!(/\./, '_')
  realname = pieces[0]
  version = pieces[1]
  date = Time.at(pieces[2].to_i)

  mystuff[:"#{name}"] = { "realname" => realname, "version" => version, "installdate" => date }

end


myrpms = Mash.new
rous[:packages] = myrpms

