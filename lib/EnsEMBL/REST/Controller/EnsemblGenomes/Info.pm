
=head1 LICENSE

Copyright [2009-2014] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package EnsEMBL::REST::Controller::EnsemblGenomes::Info;

use Moose;
use namespace::autoclean;
use Bio::EnsEMBL::EGVersion;
use Try::Tiny;
require EnsEMBL::REST;
EnsEMBL::REST->turn_on_config_serialisers(__PACKAGE__);
use Data::Dumper;

BEGIN { extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config( default => 'application/json',
					 map     => { 'text/plain' => ['YAML'], } );

sub ensgen_version : Chained('/') PathPart('info/eg_version') :
  ActionClass('REST') : Args(0) { }

sub ensgen_version_GET {
  my ( $self, $c ) = @_;
  $c->log()->info("Retrieving EG version from registry");
  # lazy load the registry
  $c->model('Registry')->_registry();
  $self->status_ok( $c, entity => { version => eg_version() } );
  return;
}

sub genomes_all : Chained('/') PathPart('info/genomes') :
  ActionClass('REST') : Args(0) { }

sub genomes_all_GET {
  my ( $self, $c ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  my @infos =
	map { $_->to_hash($expand) } @{ $lookup->_adaptor()->fetch_all() };
  $self->status_ok( $c, entity => \@infos );
  return;
}

sub genomes_name : Chained('/') PathPart('info/genomes') :
  ActionClass('REST') : Args(1) { }

sub genomes_name_GET {
  my ( $self, $c, $name ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  $c->log()->info("Retrieving information about all genomes");
  my $info = $lookup->_adaptor()->fetch_by_any_name($name);
  $c->go( 'ReturnError', 'custom', ["Genome $name not found"] )
	unless defined $info;
  $self->status_ok( $c, entity => $info->to_hash($expand) );
  return;
}

sub divisions : Chained('/') PathPart('info/divisions') :
  ActionClass('REST') : Args(0) { }

sub divisions_GET {
  my ( $self, $c, $division ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  $c->log()->info("Retrieving list of divisions");
  my $divs = $lookup->_adaptor()->list_divisions();
  $self->status_ok( $c, entity => $divs );
  return;
}

sub genomes_division : Chained('/') PathPart('info/genomes/division') :
  ActionClass('REST') : Args(1) { }

sub genomes_division_GET {
  my ( $self, $c, $division ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  $c->log()
	->info(
		"Retrieving information about genomes from division $division");
  my @infos = map { $_->to_hash($expand) }
	@{ $lookup->_adaptor()->fetch_all_by_division($division) };
  $self->status_ok( $c, entity => \@infos );
  return;
}

sub genomes_assembly : Chained('/') PathPart('info/genomes/assembly') :
  ActionClass('REST') : Args(1) { }

sub genomes_assembly_GET {
  my ( $self, $c, $acc ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  my $info   = $lookup->_adaptor()->fetch_by_assembly_id($acc);
  $c->go( 'ReturnError', 'custom',
		  ["Genome with assembly accession $acc not found"] )
	unless defined $info;
  $self->status_ok( $c, entity => $info->to_hash($expand) );
  return;
}

sub genomes_accession : Chained('/') PathPart('info/genomes/accession')
  : ActionClass('REST') : Args(1) { }

sub genomes_accession_GET {
  my ( $self, $c, $acc ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  my @infos  = map { $_->to_hash($expand) }
	@{ $lookup->_adaptor()->fetch_all_by_sequence_accession($acc) };
  $self->status_ok( $c, entity => \@infos );
  return;
}

sub genomes_taxonomy : Chained('/') PathPart('info/genomes/taxonomy') :
  ActionClass('REST') : Args(1) { }

sub genomes_taxonomy_GET {
  my ( $self, $c, $taxon ) = @_;
  # lazy load the registry
  $c->model('Registry')->_registry();
  my $lookup = $c->model('Registry')->_lookup();
  my $expand = $c->request->param('expand');
  $c->log()
	->info("Retrieving information about genomes from taxon $taxon");
  my @infos = map { $_->to_hash($expand) }
	@{ $lookup->_adaptor()->fetch_all_by_taxonomy_branch($taxon) };
  $c->log()
	->info( "Found " . scalar(@infos) . " genomes from taxon $taxon" );
  $self->status_ok( $c, entity => \@infos );
  return;
}

__PACKAGE__->meta->make_immutable;

1;
