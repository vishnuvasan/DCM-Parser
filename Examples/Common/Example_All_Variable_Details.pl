use strict;
#use warnings;

#Importing all Function from the DCM_Parser Directory.Import specific Functions if you wish
use DCM_Parser;

#Getting the DCM File Name as a Command Line Variable and Passing it to DCM_File Function
DCM_File($ARGV[0]);

#Setting the Tag Values in the DCM to be Default which means German Tags
Default_Tags(0);

#Declaration of Hash to Get the Values of Variable Details
my ($Details,%All_Variable_Details);

#Function to return a Hash Containing all the Variable Details
$Details=All_Variable_Details();

#DeReferencing the Obtained Hash Reference
%All_Variable_Details=%$Details;

#Print All the Details contained in tha Hash
foreach my $Variable (keys(%All_Variable_Details))
{
	
		print "\n";
		print '+---------------------------------------',"\n";
		print "		VARIABLE		: ",$Variable,"\n";
		print "		DESCRIPTION		: ",$All_Variable_Details{$Variable}{'DESCRIPTION'},"\n";
		print "		FUNCTION		: ",$All_Variable_Details{$Variable}{'FUNCTION'},"\n";
		print "		SIZE			: ",$All_Variable_Details{$Variable}{'SIZE'},"\n";
		print "		X AXIS VARIABLE	: ",$All_Variable_Details{$Variable}{'X-AXIS-VARIABLE'},"\n";
		print "		X SIZE			: ",$All_Variable_Details{$Variable}{'X-SIZE'},"\n";
		print "		X AXIS UNIT		: ",$All_Variable_Details{$Variable}{'X-AXIS-UNIT'},"\n";
		print "		X AXIS VALUE	: ",$All_Variable_Details{$Variable}{'X-AXIS-VALUE'},"\n";
		print "		Y AXIS VARIABLE	: ",$All_Variable_Details{$Variable}{'Y-AXIS-VARIABLE'},"\n";
		print "		Y SIZE			: ",$All_Variable_Details{$Variable}{'Y-SIZE'},"\n";
		print "		Y AXIS UNIT		: ",$All_Variable_Details{$Variable}{'Y-AXIS-UNIT'},"\n";
		print "		Y AXIS VALUE	: ",$All_Variable_Details{$Variable}{'Y-AXIS-VALUE'},"\n";
		print "		UNIT			: ",$All_Variable_Details{$Variable}{'UNIT'},"\n";
		print "		VALUE			: ",$All_Variable_Details{$Variable}{'VALUE'},"\n";
		print '											-------------------------------------------+';
		print "\n\n";
}
