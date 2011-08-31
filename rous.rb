#
# rous.rb
#
# "RPMs of Unusual Significance"
# 
# runs an rpm query and dumps the package output into the node data
#


provides "rous"

rous Mash.new


stuff = `rpm -qa YOURQUERYHERE`

myrpms = Mash.new
stuff.split("\n").each do |line|
  print line
        myrpms[line] = "null"
end

rous[:packages] = myrpms

