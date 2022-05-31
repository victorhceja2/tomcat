#-----------------------------------------------------------------------------
#
#	$Id : File.pm 2.113 2006-03-15 JMG$
#
#	Initial developer: Jean-Marie Gouarne
#	Copyright 2006 by Genicorp, S.A. (www.genicorp.com)
#	License:
#		- Licence Publique Generale Genicorp v1.0
#		- GNU Lesser General Public License v2.1
#
#-----------------------------------------------------------------------------

package	OpenOffice::OODoc::File;
use	5.006_001;
our	$VERSION	= 2.113;
use	Archive::Zip	1.14	qw ( :DEFAULT :CONSTANTS :ERROR_CODES );
use	File::Temp;

#-----------------------------------------------------------------------------
# some defaults

our	$DEFAULT_OFFICE_FORMAT		= 2;	# OpenDocument format
our	$DEFAULT_COMPRESSION_METHOD	= COMPRESSION_DEFLATED;
our	$DEFAULT_COMPRESSION_LEVEL	= COMPRESSION_LEVEL_BEST_COMPRESSION;
our	$DEFAULT_EXPORT_PATH		= './';
our	$WORKING_DIRECTORY		= '.';
our	$TEMPLATE_PATH			= '';
our	$MIMETYPE_BASE			= 'application/vnd.sun.xml.';
our	%OOTYPE				=
		(
		text		=> 'writer',
		spreadsheet	=> 'calc',
		presentation	=> 'impress',
		drawing		=> 'draw',
		);
		
#-----------------------------------------------------------------------------
# returns the mimetype string according to a document class

sub	mime_type
	{
	my $class	= shift;
	return undef unless ($class && $OOTYPE{$class});
	return $MIMETYPE_BASE . $OOTYPE{$class};
	}
		
#-----------------------------------------------------------------------------
# returns the template member list

our	@_archive_members;

sub	_fill_manifest
	{
	push @_archive_members, $File::Find::name;
	}

sub	get_template_manifest
	{
	require File::Find;
	my $path	= shift;
	@_archive_members = ();
	File::Find::find(\&_fill_manifest, $path);
	return @_archive_members;
	}

#-----------------------------------------------------------------------------
# get/set the path for XML templates

sub	templatePath
	{
	my $newpath	= shift;
	$TEMPLATE_PATH = $newpath if defined $newpath;
	return $TEMPLATE_PATH;
	}

sub	ooTemplatePath
	{
	return OpenOffice::OODoc::File::templatePath(@_);
	}
	
#-----------------------------------------------------------------------------
# member storage

sub	store_member
	{
	my $zipfile	= shift;
	my %opt		=
		(
		compress	=> 1,
		@_
		);
	unless ($opt{'member'})
		{
		warn	"[" . __PACKAGE__ . "::store_member] "	.
			"Missing member name\n";
		return undef;
		}
	my $m = undef;
	if	($opt{'string'})
		{
		$m = $zipfile->addString($opt{'string'}, $opt{'member'});
		}
	elsif	($opt{'file'})
		{
		$m = $zipfile->addFileOrDirectory($opt{'file'}, $opt{'member'});
		}
	else
		{
		warn	"[" . __PACKAGE__ . "::store_member] "	.
			"Missing content to store\n";
		return undef;
		}
	unless ($m)
		{
		warn	"[" . __PACKAGE__ . "::store_member] "	.
			"Member storage failure\n[" . $opt{'file'} . "]\n";
		return undef;
		}
	unless ($opt{'compress'})
		{
		$m->desiredCompressionMethod(COMPRESSION_STORED);
		}
	else
		{
		$m->desiredCompressionMethod($DEFAULT_COMPRESSION_METHOD);
		$m->desiredCompressionLevel($DEFAULT_COMPRESSION_LEVEL);
		}
	return $m;
	}

#-----------------------------------------------------------------------------
# file creation from template

sub	ooCreateFile
	{
	my %opt	=
		(
		class		=> 'text',
		template_path	=> $TEMPLATE_PATH,
		work_dir	=> $WORKING_DIRECTORY,
		@_
		);
	
	unless (checkWorkingDirectory($opt{'work_dir'}))
		{
                warn    "[" . __PACKAGE__ . "::ooCreateFile] "          .
			"Write operation not allowed - "        .
			"Working directory missing or non writable\n";
		return undef;
		}

	my $basepath = undef;
	if ($opt{'template_path'})
		{
		$basepath = $opt{'template_path'};
		}
	else
		{
		require File::Basename;
		$basepath = 
			File::Basename::dirname
				($INC{"OpenOffice/OODoc/File.pm"}) .
			'/templates/';
		$basepath .= $opt{'opendocument'} ?
				'opendocument' : 'ooffice';
		}
	$basepath =~ s/\\/\//g;
	my $path	= $basepath . '/' . $opt{'class'};
	unless (-d $path)
		{
                warn    "[" . __PACKAGE__ . "::ooCreateFile] "          .
			"No valid template access path\n";
		return undef;
		}
	delete $opt{'class'};
	my @files = OpenOffice::OODoc::File::get_template_manifest($path);
       	my $zipfile = Archive::Zip->new;
	foreach my $file (@files)
		{
		next unless ($file && -f $file);
		my $member = $file; $member =~ s/\Q$path\///;
		next unless $member;
		store_member
			(
			$zipfile,
			member		=> $member,
			file		=> $file,
			compress	=> ($member eq 'meta.xml') ? 0 : 1
			);
		}
	if ($opt{'filename'})
		{
		unless ($zipfile->writeToFileNamed($filename) == AZ_OK)
			{
                	warn    "[" . __PACKAGE__ . "::createOOFile] "          .
				"Archive initialization error\n";
			return undef;
			}
		return $filename;
		}
	else
		{
		return $zipfile;
		}
	}

#-----------------------------------------------------------------------------
# control & conversion of XML component names of the OO file

sub	CtrlMemberName
	{
	my $self	= shift;
	my $member	= shift;
	
	my $m = lc $member;
	foreach my $n ('content', 'meta', 'styles', 'settings')
		{
		if ($m eq $n)
			{
			$member = $n . '.xml';
			last;
			}
		}

	foreach $m ( @{ $self->{'members'} } )
		{
		return $member if ($member eq $m);
		}

	return	undef;
	}

#-----------------------------------------------------------------------------
# check working directory

sub	checkWorkingDirectory
	{
	my $path	= shift || $WORKING_DIRECTORY;

	if (-d $path)
		{
		if (-w $path)
			{
			return 1;
			}
		else
			{
			warn	"[" . __PACKAGE__ . "] "	.
				"No write permission in $path\n";
			}
		}
	else
		{
		warn	"[" . __PACKAGE__ . "] "	.
			"$path is not a directory\n";
		}
	return undef;
	}

#-----------------------------------------------------------------------------
# unique temporary file name generation

sub	new_temp_file_name
	{
	my $self	= shift;

	return File::Temp::mktemp($self->{'work_dir'} . '/oo_XXXXX');
	}

#-----------------------------------------------------------------------------
# temporary data storage

sub	store_temp_file
	{
	my $self	= shift;
	my $data	= shift;

	my $tmpfile	= $self->new_temp_file_name;
	
	unless (open FH, '>:utf8', $tmpfile)
		{
		warn	"[" . __PACKAGE__ . "::store_temp_file] "	.
			"Unable to create temporary file $tmpfile\n";
		return undef;
		}
	unless (print FH $data)
		{
		warn	"[" . __PACKAGE__ . "::store_temp_file] "	.
			"Write error in temporary file $tmpfile\n";
		return undef;
		}
	unless (close FH)
		{
		warn	"[" . __PACKAGE__ . "::store_temp_file] "	.
			"Unknown error in temporary file $tmpfile\n";
		return undef;
		}
	push @{$self->{'temporary_files'}}, $tmpfile;
	return $tmpfile;
	}

#-----------------------------------------------------------------------------
# temporary member extraction

sub	extract_temp_file
	{
	my $self	= shift;
	my $member	= shift;

	my $m	= ref $member	?
			$member		:
			$self->{'archive'}->memberNamed($member);

	my $tmpfile	= $self->new_temp_file_name;	
	my $result = $m->extractToFileNamed($tmpfile);
	if ($result == AZ_OK)
		{
		push @{$self->{'temporary_files'}}, $tmpfile;
		return $tmpfile;
		}
	else
		{
		return undef;
		}
	}

#-----------------------------------------------------------------------------
# temporary  storage cleanup
# returns the number of deleted files and clears the list of temp files

sub	remove_temp_files
	{
	my $self	= shift;
	my $count	= 0;

	while (@{$self->{'temporary_files'}})
		{
		my $tmpfile	= shift @{$self->{'temporary_files'}};
		my $r		= undef;
		unless ( -d $tmpfile )	{ $r = unlink $tmpfile; }
		else			{ $r = rmdir $tmpfile; }
		unless ($r > 0)
			{
			warn
				"[" . __PACKAGE__ . "::remove_temp_files] " .
				"Temporary file $tmpfile can't be removed\n";
			}
		else
			{
			$count++;
			}
		}
	return $count;
	}

#-----------------------------------------------------------------------------
# constructor; requires an existing regular OO file

sub	new
	{
	my $caller	= shift;
	my $class	= ref($caller) || $caller;
	my $sourcefile	= shift;
	my $self	= 
		{
		'linked'		=> [],
		'work_dir'		=>
				$OpenOffice::OODoc::File::WORKING_DIRECTORY,
		'template_path'		=>
				 $OpenOffice::OODoc::File::TEMPLATE_PATH,
		'temporary_files'	=> [],
		'raw_members'		=> [],
		'to_be_deleted'		=> [],
		@_
		};

	my $od = lc $self->{'opendocument'};
	unless ($od)
		{
		if ($OpenOffice::OODoc::File::DEFAULT_OFFICE_FORMAT == 2)
			{ $self->{'opendocument'} = 1; }
		}
	elsif (($od eq '1') || ($od eq 'on') || ($od eq 'true'))
		{
		$self->{'opendocument'} = 1;
		}
	elsif (($od eq '0') || ($od eq 'off') || ($od eq 'false'))
		{
		delete $self->{'opendocument'};
		}
	else
		{
		warn "[" . __PACKAGE__ . "::new] Wrong 'opendocument' option\n";
		return undef;
		}
		

	$self->{'source_file'}	= $sourcefile;

	unless	($sourcefile)
		{
		warn "[" . __PACKAGE__ . "::new] Missing file name\n";
		return undef;
		}
	
	unless ($self->{'create'})
		{
		unless	( -e $sourcefile && -f $sourcefile && -r $sourcefile )
			{
			warn	"[" . __PACKAGE__ . "::new] "	.
				"File $sourcefile unavailable\n";
			return undef;
			}
		$self->{'archive'} = Archive::Zip->new;
		if ($self->{'archive'}->read($self->{'source_file'}) != AZ_OK)
			{
			delete $self->{'archive'};
			warn "[" . __PACKAGE__ . "::new] Read error\n";
			return undef;
			}
		}
	else
		{
		$self->{'archive'} = ooCreateFile
				(
				class		=> $self->{'create'},
				work_dir	=> $self->{'work_dir'},
				template_path	=> $self->{'template_path'},
				opendocument	=> $self->{'opendocument'}
				);
		unless ($self->{'archive'} && ref $self->{'archive'})
			{
			delete $self->{'archive'};
			warn	"[" . __PACKAGE__ . "::new] "	.
				"File creation failure\n";
			return undef;
			}
		}
	$self->{'members'} = [ $self->{'archive'}->memberNames ];
	return bless $self, $class;
	}

#-----------------------------------------------------------------------------
# individual zip XML member extraction/uncompression

sub	extract
	{
	my $self	= shift;
	my $member	= $self->CtrlMemberName(shift);

	unless ($member)
		{
		warn "[" . __PACKAGE__ . "::extract] Unknown member\n";
		return undef;
		}

	unless ($self->{'archive'})
		{
		warn "[" . __PACKAGE__ . "::extract] No archive\n";
		return undef;
		}

	return	$self->{'archive'}->contents($member);
	}

#-----------------------------------------------------------------------------
# individual zip member raw export (see Archive::Zip::extractMember)

sub	raw_export
	{
	my $self	= shift;

	unless ($self->{'archive'})
		{
		warn "[" . __PACKAGE__ . "::raw_export] No archive\n";
		return undef;
		}

	my $source	= shift;
	my $target	= shift;
	if (defined $target)
		{
		unless ($target =~ /\//)
			{
			$target = $DEFAULT_EXPORT_PATH . $target;
			}
		unshift @_, $target;
		}
	unshift @_, $source;

	if ($self->{'archive'}->extractMember(@_) == AZ_OK)
		{
		return	$target	? $target : $source;
		}
	else
		{
		warn "[" . __PACKAGE__ . "::raw_export] File output error\n";
		return undef;
		}
	}

#-----------------------------------------------------------------------------
# individual zip member raw import
# file to be imported is only registered here; real import by save()

sub	raw_import
	{
	my $self	= shift;
	my $membername	= shift;
	my $filename	= shift;
	$filename	= $membername	unless $filename;
	my %new_member	= ('file' => $filename, 'member' => $membername);

	push @{$self->{'raw_members'}}, \%new_member;
	return %new_member;
	}

#-----------------------------------------------------------------------------
# individual zip member removing (real deletion committed by save)
# WARNING: removing a member doesn't automatically update "manifest.xml"

sub	raw_delete
	{
	my $self	= shift;
	my $member	= $self->CtrlMemberName(shift)
		or return undef;

	my $mbcount	= scalar @{$self->{'members'}};
	for (my $i = 0 ; $i < $mbcount ; $i++)
		{
		if ($self->{'members'}[$i] eq $member)
			{
			splice(@{$self->{'members'}}, $i, 1);
			push @{$self->{'to_be_deleted'}}, $member;
			return 1;
			}
		}
	return undef;
	}

#-----------------------------------------------------------------------------
# archive list

sub	getMemberList
	{
	my $self	= shift;

	return @{$self->{'members'}};
	}

#-----------------------------------------------------------------------------
# connects the current OODoc::File instance to a client OODoc::XPath object
# and extracts the corresponding XML member (to be transparently invoked
# by the constructor of OODoc::XPath when activated with a 'file' parameter)

sub	link
	{
	my $self	= shift;
	my $ooobject	= shift;

	push @{$self->{'linked'}}, $ooobject;
	return $self->extract($ooobject->{'member'});
	}

#-----------------------------------------------------------------------------
# copy an individual member from the current OODoc::File instance($self)
# to an external Archive::Zip object ($archive), using a temporary flat file

sub	copyMember
	{
	my $self	= shift;
	my $archive	= shift;
	my $member	= shift;

	my $m		= $self->{'archive'}->memberNamed($member);
	unless ($m)
		{
		warn	"[" . __PACKAGE__ .
			"::copyMember] Unknown source member\n";
		return undef;
		}
	my $tmpfile	= $self->extract_temp_file($m);
	unless ($tmpfile)
		{
		warn	"[" . __PACKAGE__ .
			"::copyMember] File extraction error\n";
		return undef;
		}
		
	store_member
		(
		$archive,
		member		=> $member,
		file		=> $tmpfile,
		compress	=> ($member eq 'meta.xml') ? 0 : 1
		);
	}

#-----------------------------------------------------------------------------
# inserts $data as a new member in an external Archive::Zip object

sub	addNewMember
	{
	my $self			= shift;
	my ($archive, $member, $data)	= @_;
	
	unless ($archive && $member && $data)
		{
		warn	"[" . __PACKAGE__ .
			"::addNewMember] Missing argument(s)\n";
		return undef;
		}

				# temporary file creation --------------------

	my $tmpfile = $self->store_temp_file($data);
	unless ($tmpfile)
		{
		warn	"[" . __PACKAGE__ . "::addNewMember] "	.
			"Temporary file error\n";
		return undef;
		}
				
				# member insertion/compression ---------------

	return	store_member
			(
			$archive,
			member		=> $member,
			file		=> $tmpfile,
			compress	=> ($member eq 'meta.xml') ? 0 : 1
			);
	}

#-----------------------------------------------------------------------------
# update mimetype

sub	change_mimetype
	{
	my $self	= shift;
	my $class	= shift;
	my $mimetype	= mime_type($class);
	my $ootool	= $OOTYPE{$class};
	
	return undef unless $mimetype;
	my $tmpfile = $self->store_temp_file($mimetype);
	$self->raw_delete('mimetype');
	$self->raw_import('mimetype', $tmpfile); 
	return 1;
	}

#-----------------------------------------------------------------------------
# creates a new OO file, copying unchanged members & updating
# modified ones (by default, the new OO file replaces the old one)

sub	save
	{
	my $self		= shift;
	my $targetfile		= shift;

	unless
		(
		OpenOffice::OODoc::File::checkWorkingDirectory
			($self->{'work_dir'})
		)
		{
		warn	"[" . __PACKAGE__ . "::save] "		.
			"Write operation not allowed - "	.
			"Working directory missing or non writable\n";
		return undef;
		}

	my %newmembers		= ();
	foreach my $nm (@{$self->{'linked'}})
		{
		my $ro = $nm->{'read_only'};
		next if $ro &&
			(($ro eq '1') || ($ro eq 'on') || ($ro eq 'true'));
		$newmembers{$nm->{'member'}} = $nm->getXMLContent;
		}

	my $outfile	= undef;
	my $tmpfile	= undef;

				# target file check --------------------------

	$targetfile	= $self->{'source_file'}	unless $targetfile;
	if ( -e $targetfile )
		{
		unless ( -f $targetfile )
			{
			warn 	"[" . __PACKAGE__ . "::save] "	.
				"$targetfile is not a regular file\n";
			return undef;
			}
		unless ( -w $targetfile )
			{
			warn 	"[" . __PACKAGE__ . "::save "	.
				"$targetfile is read only\n";
			return undef;
			}
		}
		
				# output to temporary file if target eq source

	if ($targetfile eq $self->{'source_file'})
		{
		$outfile = $self->new_temp_file_name;
		}
	else
		{
		$outfile = $targetfile;
		}

				# discriminate replaced/added members --------

	my %replacedmembertable	= ();
	my @addedmemberlist	= ();
	foreach my $nmn (keys %newmembers)
		{
		my $tmn	= $self->CtrlMemberName($nmn);
		if ($tmn)
			{
			$replacedmembertable{$tmn}	= $nmn;	
			}
		else
			{
			push @addedmemberlist, $nmn;
			}
		}
		
				# target archive operation -------------------

	$self->{'archive'}->writeToFileNamed($outfile);
	my $archive	= Archive::Zip->new;
	my $status	= $archive->read($outfile);
	unless ($status == AZ_OK)
		{
		warn "[" . __PACKAGE__ . "::save] Archive write error\n";
		return undef;
		}
	
	foreach my $oldmember (@{$self->{'members'}})
		{
		my $k	= $replacedmembertable{$oldmember};
		if ($k)				# (replaced member)
			{
			$archive->removeMember($oldmember);
			$self->addNewMember
				($archive, $oldmember, $newmembers{$k});
			}
		}
	foreach my $name (@addedmemberlist)	# (added member)
		{
		$self->addNewMember($archive, $name, $newmembers{$name});
		}
	
	foreach my $raw_member (@{$self->{'raw_members'}}) # optional raw data
		{
		$archive->removeMember($raw_member->{'member'});
		store_member
			(
			$archive,
			member		=> $raw_member->{'member'},
			file		=> $raw_member->{'file'},
			compress	=> 1
			)
		}
		
	foreach my $member_to_be_deleted (@{$self->{'to_be_deleted'}})
		{
		$archive->removeMember($member_to_be_deleted);
		}

	$status = $archive->overwrite();

				# post write control & cleanup ---------------
	if ($status == AZ_OK)
		{
		unless ($outfile eq $targetfile)
			{
			require File::Copy;

			unlink $targetfile;
			File::Copy::move($outfile, $targetfile);
			}
		$self->remove_temp_files;
		return 1;
		}
	else
		{
		warn "[" . __PACKAGE__ . "::save] Archive write error\n";
		return undef;
		}
	}

#-----------------------------------------------------------------------------
1;
