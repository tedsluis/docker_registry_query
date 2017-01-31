#!/usr/bin/perl
use strict;
use diagnostics;
use JSON;
use Data::Dumper;
use Getopt::Long;

# https://github.com/TranceMaster86/docker-reg-gc/blob/master/docker-reg-gc.sh

# set defaults
my $DOCKER_REGISTRY="https://<your docker registry url>:5000/v2";
my $ACCEPT_HEADER="Accept: application/vnd.docker.distribution.manifest.v2+json";

# options
my $help;
my $docker_registry;
my $repofilter;
my $tagfilter;
my $verbose;
my $details;
GetOptions(
  "help!"=>\$help,
  "url=s"=>\$docker_registry,
  "repo=s"=>\$repofilter,
  "tag=s"=>\$tagfilter,
  "verbose!"=>\$verbose,
  "details!"=>\$details
);

# help
if ($help) {
  print "\nHELP docker registry query\n
Usage:
  $0 -help                        This help text.
  $0 -verbose                     Display detail logging.
  $0 -details                     Display detail info.
  $0 -url <docker registry url>   An alternative docker registry URL.
  $0 -repo <(part of) repo name>  Filter on repository name. 
  $0 -tag <(part of) tag name>    Filter on tag.\n";
  exit;
}

# Docker registry URL
if ($docker_registry) {
  if ($docker_registry =~ /^https:\/\/([a-z0-9]+[_\-\.\/]?)+$/i) {
    $DOCKER_REGISTRY="$docker_registry:5000/v2";
  } elsif ($docker_registry =~ /^([a-z0-9]+[_\-\.\/]?)+$/i) {
    $DOCKER_REGISTRY="https://$docker_registry:5000/v2";
  }
}

# counters
my $REPOCOUNT=0;
my $TAGCOUNT=0;

# json string to hash reference
sub parse_json(@){
  my $json_string = shift;
  my $json = JSON->new;
  my $data = from_json($json_string);
  #print Dumper($data)."\n";
  return $data;  
}

# get repositories
sub get_repositories {
  my @curl=`curl -Ls GET "${DOCKER_REGISTRY}"/_catalog`;
  foreach my $line (@curl) {
    next unless ($line =~ /repositories":\[/);
    my @repositories = @{ $ { parse_json($line) } { 'repositories' } };
    return @repositories;
  }
}

# get repository tags
sub get_repository_tags(@) {
  my $REPOSITORY=shift;
  my @curl=`curl -Ls GET "${DOCKER_REGISTRY}"/"${REPOSITORY}"/tags/list`;
  foreach my $line (@curl) {
    if ($line =~ /^\{"errors"/) {
       print "   ERROR: '$line'" if ($verbose);
       next;
    } elsif ($line =~ /^\{"name":"([^"]+)","tags":\[([^\]]+)\]}/) {
       my $name = $1;
       my $tags = $2;
       my @tags = @{ $ { parse_json($line) } { 'tags' } };
       my @tmp;
       foreach my $tag (sort @tags) {
         if ($tag eq "latest") { 
           unshift(@tmp,$tag);
           next;
         }
         push(@tmp,$tag);
       }
       return @tmp;
    } else { 
       print "   Undefined line: '$line'" if ($verbose);
    }
  } 
}

# get tag date
sub get_tag_created_date_and_digest(@) {
  my $REPOSITORY=shift;
  my $TAG=shift;
  my $TAGBLOBDIGEST;
  my $DATE;
  my $MANIFEST="";
  my @curl = `curl -Ls --header "${ACCEPT_HEADER}" GET "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}"`;
  #my @curl = `curl -Ls "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}"`;
  my $curl="";
  foreach my $line (@curl) {
    chomp($line);
    $curl.=$line;
    if ($line =~ /"schemaVersion":\s2,/) {
      $MANIFEST = "v2";
    } elsif ($line =~ /"digest":\s"([^\)]+)"/) { 
      $TAGBLOBDIGEST = $1;
    } elsif ($line =~ /"(v1)Compatibility":\s"\{\\"id\\":\\"([0-9a-f]+)\\"/) {
      $MANIFEST = "v1";
      $TAGBLOBDIGEST = $2;
    }
  } 
  $curl =~ s/\n$//g;
  #print "--->>>$curl<<<---\n";
  my $ref = parse_json($curl);
  if (exists $ { $ref } { 'schemaVersion' } ) {
    $MANIFEST = $ { $ref } { 'schemaVersion' };
    #print "schemaVersion ----> ".$ { $ref } { 'schemaVersion' }."\n";
  }
  # schemaVersion 1
  if (exists $ { $ref } { 'fsLayers' } ) {
    my $ref_fslayers = $ { $ref } { 'fsLayers' };
    my @fslayers = @ { $ref_fslayers };
    foreach my $ref_layers (@fslayers) {
      if (exists $ { $ref_layers } { 'blobSum' } ) {
        my $blobSum = $ { $ref_layers } { 'blobSum' };
        print "blobSum---->>>$blobSum\n" if ($details);
      }
    }
  }
  if (exists $ { $ref } { 'history' } ) {
    my $ref_history = $ { $ref } { 'history' };
    my @history = @ { $ref_history };
    foreach my $ref_layer (@history) {
      if (exists $ { $ref_layer } { 'v1Compatibility' } ) {
        my $ref_v1Compatibility = $ { $ref_layer } { 'v1Compatibility' };
        print "      ref_v1Compatibility===>$ref_v1Compatibility\n" if ($details);
        #my $created = $ { $ref_v1Compatibility } { 'created' };
        #print "created------->>>$created\n";
      }
    }
  }

  # schemaVersion 2
  if (exists $ { $ref } { 'config' } ) {
    my $ref_config = $ { $ref } { 'config' };
    if (exists $ { $ref_config } { 'digest' } ) {
      my $SIZE = $ { $ref_config } { 'size' };
      $TAGBLOBDIGEST = $ { $ref_config } { 'digest' };
      print "digest-->$TAGBLOBDIGEST, size-->$SIZE\n" if ($details);
    }
  } 
  if (exists $ { $ref } { 'layers' } ) {
    my $ref_layers = $ { $ref } { 'layers' };
    my @layers = @ { $ref_layers };
    foreach my $ref_layers (@layers) {
      my $SIZE = $ { $ref_layers } { 'size' };
      my $TAGBLOBDIGEST = $ { $ref_layers } { 'digest' };
      print "  +-digest----->$TAGBLOBDIGEST, size---->$SIZE\n" if ($details);
    }  
  }
  # 
  if ((!$TAGBLOBDIGEST) || ($TAGBLOBDIGEST =~ /^\s*$/)) {
    print "   REPO=$REPOSITORY, TAG=$TAG, TAGBLOBDIGEST is empty!\n" if ($details);
    return;
  }
  @curl = `curl -Ls GET "${DOCKER_REGISTRY}"/"${REPOSITORY}"/blobs/"${TAGBLOBDIGEST}"`;
  foreach my $line (@curl) {
    next unless ($line =~ /"created"/);
    if ($line =~ /"created":"(\d{4}-\d{2}-\d{2})T(\d{2}:\d{2}:\d{2}\.\d{2})\d*Z"/) {
      $DATE="$1 $2";
      last;
    }
  }
  @curl = `curl -ILs --header "${ACCEPT_HEADER}" "${DOCKER_REGISTRY}"/"${REPOSITORY}"/manifests/"${TAG}" | grep Docker-Content-Digest`;
  foreach my $line (@curl) {
    if ($line =~ /^\s*Docker-Content-Digest:\s(sha256:[0-9a-f]+)\s*$/) {
      my $TAGDIGEST=$1;
      printf("  %-3s %-20s %-73s %-21s \n", $MANIFEST, $TAG, $TAGDIGEST, $DATE) if ($details);
    }
  }
}

# main
my @repos = get_repositories();
foreach my $repo (sort @repos) {
  next if (($repofilter) && ($repo !~ /$repofilter/));
  $REPOCOUNT++;
  print "$repo\n";
  my @tags = get_repository_tags($repo);
  foreach my $tag (@tags) {
    next if (($tagfilter) && ($repo !~ /$tagfilter/));
    $TAGCOUNT++;
    if ((!$tag) || ($tag =~ /^\s*$/)) {
      print "   REPO $repo, TAG is empty!\n";
      next;
    }
    get_tag_created_date_and_digest($repo,$tag);
  }  
}
print "REPOCOUNT=$REPOCOUNT, TAGCOUNT=$TAGCOUNT\n";
