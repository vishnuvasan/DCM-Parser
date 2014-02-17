use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Map and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Map Details
my ($Details,%Maps_Details);

#Function to return a Hash Containing all the Map Details
$Details=Maps_Details();

#DeReferencing the Obtained Hash Reference
%Maps_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Map (keys(%Maps_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		MAP				: ",$Map,"\n";
		print "		X SIZE			: ",$Maps_Details{$Map}{'X-SIZE'},"\n";
		print "		Y SIZE			: ",$Maps_Details{$Map}{'Y-SIZE'},"\n";
		print "		DESCRIPTION		: ",$Maps_Details{$Map}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Maps_Details{$Map}{'FUNCTION'},"\n";
		print "		X AXIS VARIABLE	: ",$Maps_Details{$Map}{'X-AXIS-VARIABLE'},"\n";
		print "		X AXIS UNIT		: ",$Maps_Details{$Map}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VALUE	: ",$Maps_Details{$Map}{'X-AXIS-VALUE'},"\n";
		print "		Y AXIS VARIABLE	: ",$Maps_Details{$Map}{'Y-AXIS-VARIABLE'},"\n";
		print "		Y AXIS VALUE	: ",$Maps_Details{$Map}{'Y-AXIS-VALUE'},"\n";
		print "		Y AXIS UNIT		: ",$Maps_Details{$Map}{'Y-AXIS-UNIT'},"\n";
		print "		UNIT			: ",$Maps_Details{$Map}{'UNIT'},"\n";
		print "		VALUE			: ",$Maps_Details{$Map}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
}
