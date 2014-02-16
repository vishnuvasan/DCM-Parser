use strict;
use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Parameter and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Group Curve Details
my ($Details,%Group_Curve_Details);

#Function to return a Hash Containing all the Group Curve Details
$Details=Group_Curves_Details();

#DeReferencing the Obtained Hash Reference
%Group_Curve_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Group_Curve (keys(%Group_Curve_Details))	
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		GROUP CURVE		: ",$Group_Curve,"\n";
		print "		SIZE			: ",$Group_Curve_Details{$Group_Curve}{'SIZE'},"\n";
		print "		DESCRIPTION		: ",$Group_Curve_Details{$Group_Curve}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$Group_Curve_Details{$Group_Curve}{'FUNCTION'},"\n";
		print "		X AXIS UNIT		: ",$Group_Curve_Details{$Group_Curve}{'X-AXIS-UNIT'},"\n";
		print "		VARIABLE		: ",$Group_Curve_Details{$Group_Curve}{'X-AXIS-VARIABLE'},"\n";
		print "		X AXIS VALUE	: ",$Group_Curve_Details{$Group_Curve}{'X-AXIS-VALUE'},"\n";
		print "		UNIT			: ",$Group_Curve_Details{$Group_Curve}{'UNIT'},"\n";
		print "		VALUE			: ",$Group_Curve_Details{$Group_Curve}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
}

