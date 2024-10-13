#!/usr/local/bin/perl

=head1 modify-dns.pl

Change DNS settings for virtual servers

This program updates DNS-related options for one or more servers, selected
using the C<--domain> or C<--all-domains> flags. Or you can select all domains
that don't have their own private IP address with C<--all-nonvirt-domains>.

To enable SPF for a domain, using C<--spf> option, and to turn it off use
C<--no-spf>. By default, the SPF record will be created using the settings
from the DNS section of the domain's server template.

To add allowed hostname, MX domains or IP addresses, use the C<--spf-add-a>,
C<--spf-add-mx>, C<--spf-add-ip4> and C<--spf-add-ip6> options respectively.
Each of which must be followed by a single host, domain or IP address. Or you
can use C<--spf-add-include> followed by a domain name who's SPF policy will
be included in this one.

Similarly, the C<--spf-remove-a>, C<--spf-remove-mx>, C<--spf-remove-ip4>,
C<--spf-remove-ip6> and C<--spf-remove-include> options will remove the
following host, domain or IP address from the allowed list for the specified
domains.

To control how SPF treats senders not in the allowed hosts list, use one of
the C<--spf-all-disallow>, C<--spf-all-discourage>, C<--spf-all-neutral>,
C<--spf-all-allow> or C<--spf-all-default> parameters.

To enable the DMARC DNS record for a domain, use the C<--dmarc> flag - or to
disable it, use C<--no-dmarc>. The DMARC action for other mail servers to
perform can be set with the C<--dmarc-policy> flag, and the percentage of
messages it should be applied to can be set with C<--dmarc-percent>.

You can also set the email address to send DMARC aggregate reports to with
C<--dmarc-rua>, or turn it off with C<--no-dmarc-rua>. Similarly the forensic
report email can be set with C<--dmarc-ruf> and C<--no-dmarc-ruf>.

This command can also be used to add and remove DNS records from all the
selected domains. Adding is done with the C<--add-record> flag, which must
be followed by a single parameter containing the record name, type and value.
Alternately, you can use C<--add-record-with-ttl> followed by the name, type,
TTL and value. If your cloud DNS provider supports proxy records, you can
use the C<--add-proxy-record> with the same parameters as C<--add-record>.

Conversely, deletion is done with the C<--remove-record> flag, followed by a 
single parameter containing the name and type of the record(s) to delete. You
can also optionally include the record values, to disambiguate records with
the same name but different values (like MX records).

You can also update an existing record with the C<--update-record> flag, which
must be followed by five parameters enclosed in quote. First and second are the
current name and type, third, fourth and fifth are the new name, type and
values. The record addition, modification and deletion flags can be given
multiple times.

Similarly, the default TTL for records can be set with the C<--ttl> flag
followed by a number in seconds. Suffixes like h, m and d are also allowed
to specific a TTL in hours, minutes or days. Alternately, the C<--all-ttl>
flag can be used to set the TTL for all records in the domain.

You can also add or remove slave DNS servers for this domain, assuming that
they have already been setup in Webmin's BIND DNS Server module. To add a
specific slave host, use the C<--add-slave> flag followed by a hostname. Or to
add them all, use the C<--add-all-slaves> flag.

To remove a single slave host, use the C<--remove-slave> command followed by a
hostname. Or to remove any slave hosts that are no longer valid (ie. because
they were removed from Webmin), use the C<--sync-all-slaves> flag.

If your system is on an internal network and made available to the Internet
via a router doing NAT, the IP address of a domain in DNS may be different
from it's IP on the actual system. To set this, the C<--dns-ip> flag can
be given, followed by the external IP address to use. To revert to using the
real IP in DNS, use C<--no-dns-ip> instead. In both cases, the actual
DNS records managed by Virtualmin will be updated.

To add TLSA records (for publishing SSL certs) to selected domains, use the 
C<--enable-tlsa> flag. Similarly the C<--disable-tlsa> removes them, and the
C<--sync-tlsa> updates them in domains where they already exist.

If a virtual server is a sub-domain of another server, you can move it's DNS
records out into a separate zone file with the C<--disable-subdomain> flag.
Or if eligible, you can combine the zones with C<--enable-subdomain>.

If this domain has a parent domain also hosted on the same system but not
sharding the same zone file, you can use the C<--add-parent-ds> flags to add
required DNSSEC DS records to the parent. Alternately you can use
C<--remove-parent-ds> to delete them, but this is not recommended as it may
break DNSSEC validation.

If you have Cloud DNS providers setup, you can move the domain to one
with the C<--cloud-dns> flag followed by a provider name like C<cloudflare>
or C<route53>. Alternately the domain can be moved back to local hosting
with the flag C<--cloud-dns local>.

Similarly, the C<--remote-dns> flag followed by a hostname can be used to move
this domain to a remote Webmin DNS server, if one is configured. Or to move it
back to local hosting, use the C<--local-dns> flag.

If DKIM is enabled on your system, you can enable it for this domain with the
C<--enable-dkim> flag, or turn it off with C<--disable-dkim>. Or switch to
the default state for this domain with C<--default-dkim>.

=cut

package virtual_server;

# Params factory
my $usage = [
  {
    req => 1,
    reuse => 1,
    param => "domain",
    value => "name",
    values => [
      {
        param => "all-domains"
      },
      {
	param => "all-nonvirt-domains"
      }
    ]
  },
  {
    param => "spf"
  },
  {
    param => "no-spf"
  },
  {
    param => "spf-add-a",
    reuse => 1,
    value => "hostname"
  },
  {
    param => "spf-add-mx",
    reuse => 1,
    value => "domain"
  },
  {
    param => "spf-add-ip4",
    reuse => 1,
    value => "address"
  },
  {
    param => "spf-add-ip6",
    reuse => 1,
    value => "address"
  },
  {
    param => "spf-remove-a",
    reuse => 1,
    value => "hostname"
  },
  {
    param => "spf-remove-mx",
    reuse => 1,
    value => "domain"
  },
  {
    param => "spf-remove-ip4",
    reuse => 1,
    value => "address"
  },
  {
    param => "spf-remove-ip6",
    reuse => 1,
    value => "address"
  },
  {
    param => "spf-all-disallow"
  },
  {
    param => "spf-all-discourage"
  },
  {
    param => "spf-all-neutral"
  },
  {
    param => "spf-all-allow"
  },
  {
    param => "spf-all-default"
  },
  {
    param => "dmarc"
  },
  {
    param => "no-dmarc"
  },
  {
    param => "dmarc-policy",
    value => "none|quarantine|reject"
  },
  {
    param => "dmarc-percent",
    value => "number"
  },
  {
    param => "dmarc-rua",
    value => "mailto:user\@domain"
  },
  {
    param => "no-dmarc-rua"
  },
  {
    param => "dmarc-ruf",
    value => "mailto:user\@domain"
  },
  {
    param => "no-dmarc-ruf"
  },
  {
    param => "add-record",
    value => "'name type value'"
  },
  {
    param => "add-record-with-ttl",
    value => "'name type TTL value'"
  },
  {
    param => "add-proxy-record",
    value => "'name type value'"
  },
  {
    param => "remove-record",
    value => "'name type value'"
  },
  {
    param => "update-record",
    value => "'oldname oldtype newname newtype newvalue'"
  },
  {
    param => "ttl",
    value => "s|m|h|d"
  },
  {
    param => "all-ttl",
    value => "s|m|h|d"
  },
  {
    param => "increment-soa",
  },
  {
    param => "add-slave",
    reuse => 1,
    value => "hostname"
  },
  {
    param => "add-all-slaves"
  },
  {
    param => "remove-slave",
    reuse => 1,
    value => "hostname"
  },
  {
    param => "sync-all-slaves"
  },
  {
    param => "dns-ip",
    value => "address"
  },
  {
    param => "no-dns-ip"
  },
  {
    param => "enable-dnssec"
  },
  {
    param => "disable-dnssec"
  },
  {
    param => "enable-tlsa"
  },
  {
    param => "disable-tlsa"
  },
  {
    param => "sync-tlsa"
  },
  {
    param => "enable-subdomain"
  },
  {
    param => "disable-subdomain"
  },
  {
    param => "cloud-dns",
    value => "provider|'local'"
  },
  {
    param => "cloud-dns-import"
  },
  {
    param => "remote-dns",
    value => "hostname"
  },
  {
    param => "local-dns"
  },
  {
    param => "add-parent-ds"
  },
  {
    param => "remove-parent-ds"
  },
  {
    param => "enable-dkim"
  },
  {
    param => "disable-dkim"
  },
  {
    param => "default-dkim"
  },
  {
    desc => "Changes DNS settings for one or more domains."
  }
];

if (!$module_name) {
	$main::no_acl_check++;
	$ENV{'WEBMIN_CONFIG'} ||= "/etc/webmin";
	$ENV{'WEBMIN_VAR'} ||= "/var/webmin";
	if ($0 =~ /^(.*)\/[^\/]+$/) {
		chdir($pwd = $1);
		}
	else {
		chop($pwd = `pwd`);
		}
	$0 = "$pwd/modify-dns.pl";
	require './virtual-server-lib.pl';
	$< == 0 || die "modify-dns.pl must be run as root";
	}
&require_bind();
@OLDARGV = @ARGV;
$config{'dns'} ||
	&usage($usage, "The BIND DNS server is not enabled for Virtualmin");
&set_all_text_print();

# Return passed parameters or throw an error
my $flags = &parse_cli_args(\@ARGV, $usage);

# We have the params, see what needs to be done
foreach my $a (keys %{$flags}) {
	if ($a eq "domain") {
		foreach my $dom (@{$flags->{$a}}) {
			push(@dnames, $dom);
			}
		}
	elsif ($a eq "all-domains") {
		$all_doms = 1;
		}
	elsif ($a eq "all-nonvirt-domains") {
		$all_doms = 2;
		}
	elsif ($a eq "spf") {
		$spf = 1;
		}
	elsif ($a eq "no-spf") {
		$spf = 0;
		}
	elsif ($a =~ /^spf-add-(a|mx|ip4|ip6|include)$/) {
		$type = $1;
		foreach my $add (@{$flags->{$a}}) {
			$add =~ /^[a-z0-9\.\-\_:]+$/ ||
			    &usage($usage, "--$a must be followed by a hostname or IP address");
			push(@{$add{$type}}, $add);
			}
		}
	elsif ($a =~ /^spf-remove-(a|mx|ip4|ip6|include)$/) {
		$type = $1;
		foreach my $rem (@{$flags->{$a}}) {
			$rem =~ /^[a-z0-9\.\-\_:]+$/ ||
			    &usage($usage, "--$a must be followed by a hostname or IP address");
			push(@{$rem{$type}}, $rem);
			}
		}
	elsif ($a =~ /^spf-all-(disallow|discourage|neutral|allow|default)$/){
		$spfall = $1 eq "disallow" ? 3 :
			  $1 eq "discourage" ? 2 :
			  $1 eq "neutral" ? 1 :
			  $1 eq "allow" ? 0 : -1;
		}
	elsif ($a eq "dmarc") {
		$dmarc = 1;
		}
	elsif ($a eq "no-dmarc") {
		$dmarc = 0;
		}
	elsif ($a eq "dmarc-policy") {
		$dmarcp = $flags->{$a};
		$dmarcp =~ /^(none|reject|quarantine)$/ ||
			&usage($usage, "--dmarc-policy must be followed by none, ".
			       "reject or quarantine");
		}
	elsif ($a eq "dmarc-percent") {
		$dmarcpct = $flags->{$a};
		$dmarcpct =~ /^\d+$/ && $dmarcpct >= 0 && $dmarcpct <= 100 ||
			&usage($usage, "--dmarc-percent must be followed by an ".
			       "integer between 0 and 100");
		}
	elsif ($a eq "dmarc-rua") {
		$dmarcrua = $flags->{$a};
		$dmarcrua =~ /^mailto:\S+\@\S+$/ ||
			&usage($usage, "--dmarc-rua must be followed by an address ".
			       "formatted like mailto:user\@domain");
		}
	elsif ($a eq "no-dmarc-rua") {
		$dmarcrua = "";
		}
	elsif ($a eq "dmarc-ruf") {
		$dmarcruf = $flags->{$a};
		$dmarcruf =~ /^mailto:\S+\@\S+$/ ||
			&usage($usage, "--dmarc-ruf must be followed by an address ".
			       "formatted like mailto:user\@domain");
		}
	elsif ($a eq "no-dmarc-ruf") {
		$dmarcruf = "";
		}
	elsif ($a eq "dns-ip") {
		$dns_ip = $flags->{$a};
		&check_ipaddress($dns_ip) ||
			&usage($usage, "--dns-ip must be followed by an IP address");
		}
	elsif ($a eq "no-dns-ip") {
		$dns_ip = "";
		}
	elsif ($a eq "add-record") {
		my ($name, $type, @values) = split(/\s+/, $flags->{$a});
		$name && $type && @values ||
			&usage($usage, "--add-record must be followed by the record name, type and values, all in one parameter");
		push(@addrecs, [ $name, $type, undef, \@values, 0 ]);
		}
	elsif ($a eq "add-record-with-ttl") {
		my ($name, $type, $ttl, @values) = split(/\s+/, $flags->{$a});
		$name && $type && $ttl && @values ||
			&usage($usage, "--add-record-with-ttl must be followed by the record name, type, TTL and values, all in one parameter");
		push(@addrecs, [ $name, $type, $ttl, \@values, 0 ]);
		}
	elsif ($a eq "add-proxy-record") {
		my ($name, $type, @values) = split(/\s+/, $flags->{$a});
		$name && $type && @values ||
			&usage($usage, "--add-proxy-record must be followed by the record name, type and values, all in one parameter");
		push(@addrecs, [ $name, $type, undef, \@values, 1 ]);
		}
	elsif ($a eq "remove-record") {
		my ($name, $type, @values) = split(/\s+/, $flags->{$a});
		$name && $type ||
			&usage($usage, "--remove-record must be followed by the record name and type, all in one parameter");
		push(@delrecs, [ $name, $type, @values ]);
		}
	elsif ($a eq "update-record") {
		my ($oldname, $oldtype, $name, $type, @values) =
			split(/\s+/, $flags->{$a});
		$oldname && $oldtype ||
			&usage($usage, "--update-record must be followed by the original record name and type, all in one parameter");
		$name && $type && @values ||
			&usage($usage, "--update-record must be followed by the new record name, type and values, all in one parameter");
		push(@uprecs, [ $oldname, $oldtype, $name, $type, undef, \@values, 0 ]);
		}
	elsif ($a eq "ttl") {
		$ttl = $flags->{$a};
		$ttl =~ /^\d+(s|m|h|d)?$/ ||
			&usage($usage, "--ttl must be followed by a number with a valid suffix");
		}
	elsif ($a eq "all-ttl") {
		$allttl = $flags->{$a};
		$allttl =~ /^\d+(s|m|h|d)?$/ ||
			&usage($usage, "--all-ttl must be followed by a number with a valid suffix");
		$ttl = $allttl;
		}
	elsif ($a eq "increment-soa") {
		$bumpsoa = 1;
		}
	elsif ($a eq "add-slave") {
		foreach my $flag (@{$flags->{$a}}) {
			push(@addslaves, $flag);
			}
		}
	elsif ($a eq "remove-slave") {
		foreach my $flag (@{$flags->{$a}}) {
			push(@delslaves, $flag);
			}
		}
	elsif ($a eq "add-all-slaves") {
		$addallslaves = 1;
		}
	elsif ($a eq "sync-all-slaves") {
		$syncallslaves = 1;
		}
	elsif ($a eq "enable-dnssec") {
		$dnssec = 1;
		}
	elsif ($a eq "disable-dnssec") {
		$dnssec = 0;
		}
	elsif ($a eq "enable-tlsa") {
		$tlsa = 1;
		}
	elsif ($a eq "disable-tlsa") {
		$tlsa = 0;
		}
	elsif ($a eq "sync-tlsa") {
		$tlsa = 2;
		}
	elsif ($a eq "enable-subdomain") {
		$submode = 1;
		}
	elsif ($a eq "disable-subdomain") {
		$submode = 0;
		}
	elsif ($a eq "multiline") {
		$multiline = 1;
		}
	elsif ($a eq "cloud-dns") {
		$clouddns = $flags->{$a};
		}
	elsif ($a eq "cloud-dns-import") {
		$clouddns_import = 1;
		}
	elsif ($a eq "remote-dns") {
		$remotedns = $flags->{$a};
		}
	elsif ($a eq "local-dns") {
		$remotedns = "";
		}
	elsif ($a eq "add-parent-ds") {
		$parentds = 1;
		}
	elsif ($a eq "remove-parent-ds") {
		$parentds = 0;
		}
	elsif ($a eq "enable-dkim") {
		$dkim_enabled = 1;
		}
	elsif ($a eq "disable-dkim") {
		$dkim_enabled = 0;
		}
	elsif ($a eq "default-dkim") {
		$dkim_enabled = 2;
		}
	elsif ($a eq "help") {
		&usage($usage);
		}
	else {
		&usage($usage, "Unknown parameter $a");
		}
	}
@dnames || $all_doms || usage($usage, "No domains specified");
defined($spf) || %add || %rem || defined($spfall) || defined($dns_ip) ||
  @addrecs || @delrecs || @uprecs ||
  @addslaves || @delslaves || $addallslaves || $ttl ||
  defined($dmarc) || $dmarcp || defined($dmarcpct) || defined($dnssec) ||
  defined($dmarcrua) || defined($dmarcruf) ||
  defined($tlsa) || $syncallslaves || defined($submode) || $clouddns ||
  defined($remotedns) || defined($parentds) || defined($clouddns_import) ||
  defined($dkim_enabled) || &usage($usage, "Nothing to do");

# Get domains to update
if ($all_doms == 1) {
	@doms = grep { $_->{'dns'} } &list_domains();
	}
elsif ($all_doms == 2) {
	@doms = grep { $_->{'dns'} && !$_->{'virt'} } &list_domains();
	}
else {
	foreach $n (@dnames) {
		$d = &get_domain_by("dom", $n);
		$d || &usage($usage, "Domain $n does not exist");
		$d->{'dns'} || &usage($usage, "Virtual server $n does not have a DNS domain");
		push(@doms, $d);
		}
	}

# Validate slave args
&require_bind();
if (@addslaves && $addallslaves) {
	&usage($usage, "Both --add-slave and --add-all-slaves cannot be specified at the same time");
	}
@slaveservers = &bind8::list_slave_servers();
if ($addallslaves) {
	@addslaves = map { $_->{'host'} } @slaveservers;
	@addslaves || &usage($usage, "No slave DNS servers have been setup in Webmin's BIND module");
	}
elsif (@addslaves) {
	foreach $s (@addslaves) {
		($ss) = grep { $_->{'host'} eq $s } @slaveservers;
		$ss || &usage($usage, "No slave DNS server with hostname $s exists");
		}
	}
if (@delslaves) {
	foreach $s (@delslaves) {
		($ss) = grep { $_->{'host'} eq $s } @slaveservers;
		$ss || &usage($usage, "No slave DNS server with hostname $s exists");
		}
	}

# Check for remote/cloud conflict
if ($clouddns && defined($remotedns)) {
	&usage($usage, "Remote and Cloud DNS providers cannot be set at the same time");
	}

# Validate the Cloud DNS provider
if ($clouddns) {
	if ($clouddns eq "services") {
		$config{'provision_dns'} ||
			&usage($usage, "Cloudmin Services for DNS is not enabled");
		}
	elsif ($clouddns ne "local") {
		my @cnames = map { $_->{'name'} } &list_dns_clouds();
		&indexof($clouddns, @cnames) >= 0 ||
			&usage($usage, "Valid Cloud DNS providers are : ".
			       join(" ", @cnames));
		}
	}

# Validate remote DNS option
if (defined($remotedns)) {
	defined(&list_remote_dns) ||
		&usage($usage, "Remote DNS servers are not supported");
	my @remote = &list_remote_dns();
	if ($remotedns eq "") {
		($rserver) = grep { $_->{'id'} == 0 } @remote;
		$rserver ||&usage($usage, "This system cannot be used as a DNS server");
		}
	else {
		($rserver) = grep { $_->{'host'} eq $remotedns } @remote;
		$rserver || &usage($usage, "Remote DNS server $remotedns not found");
		}
	$rserver->{'slave'} && &usage($usage, "Remote DNS server $rserver->{'host'} ".
				      "cannot be used for master zones");
	}

# Validate DKIM flag
my $dkim = &get_dkim_config();
if (defined($dkim_enabled)) {
	$dkim && $dkim->{'enabled'} ||
		&usage($usage, "DKIM is not enabled on this system");
	}

# Do it for all domains
foreach $d (@doms) {
	&$first_print("Updating server $d->{'dom'} ..");
	&obtain_lock_dns($d);
	&$indent_print();
	$oldd = { %$d };
	$cloud = &get_domain_dns_cloud($d);

	$currspf = &get_domain_spf($d);
	if (defined($spf)) {
		# Turn SPF on or off
		if ($spf == 1 && !$currspf) {
			# Need to enable, with default settings
			&$first_print($text{'spf_enable'});
			&save_domain_spf($d, $currspf=&default_domain_spf($d));
			&$second_print($text{'setup_done'});
			}
		elsif ($spf == 0 && $currspf) {
			# Need to disable
			&$first_print($text{'spf_disable'});
			&save_domain_spf($d, undef);
			&$second_print($text{'setup_done'});
			$currspf = undef;
			}
		}

	$currdmarc = &get_domain_dmarc($d);
	if (defined($dmarc)) {
		# Turn DMARC on or off
		if ($dmarc == 1 && !$currdmarc) {
			# Need to enable, with default settings
			&$first_print($text{'spf_dmarcenable'});
			$err = &save_domain_dmarc($d,
				$currdmarc = &default_domain_dmarc($d));
			&$second_print($err || $text{'setup_done'});
			}
		elsif ($dmarc == 0 && $currdmarc) {
			# Need to disable
			&$first_print($text{'spf_dmarcdisable'});
			$err = &save_domain_dmarc($d, undef);
			&$second_print($err || $text{'setup_done'});
			$currdmarc = undef;
			}
		}

	if ((%add || %rem || defined($spfall)) && $currspf) {
		# Update a, mx ip4 and ip6 in SPF record
		&$first_print($text{'spf_change'});
		foreach $t (keys %add) {
			foreach $a (@{$add{$t}}) {
				push(@{$currspf->{$t.":"}}, $a);
				}
			$currspf->{$t.":"} = [ &unique(@{$currspf->{$t.":"}}) ];
			}
		foreach $t (keys %rem) {
			foreach $a (@{$rem{$t}}) {
				$currspf->{$t.":"} =
				    [ grep { $_ ne $a } @{$currspf->{$t.":"}} ];
				}
			}
		if (defined($spfall)) {
			if ($spfall < 0) {
				delete($currspf->{'all'});
				}
			else {
				$currspf->{'all'} = $spfall;
				}
			}
		&save_domain_spf($d, $currspf);
		&$second_print($text{'setup_done'});
		}

	if (($dmarcp || defined($dmarcpct) || defined($dmarcrua) ||
	     defined($dmarcruf)) && $currdmarc) {
		# Update current DMARC record
		&$first_print($text{'spf_dmarcchange'});
		if ($dmarcp) {
			$currdmarc->{'p'} = $dmarcp;
			}
		if (defined($dmarcpct)) {
			$currdmarc->{'pct'} = $dmarcpct;
			}
		if (defined($dmarcrua)) {
			$currdmarc->{'rua'} = $dmarcrua;
			}
		if (defined($dmarcruf)) {
			$currdmarc->{'ruf'} = $dmarcruf;
			}
		&save_domain_dmarc($d, $currdmarc);
		&$second_print($text{'setup_done'});
		}

	if (defined($dns_ip)) {
		if ($dns_ip) {
			# Changing IP address for DNS
			$d->{'dns_ip'} = $dns_ip;
			}
		else {
			# Resetting DNS IP address to default
			delete($d->{'dns_ip'});
			}
		&modify_dns($d, $oldd);
		&save_domain($d);
		}

	# Remove records from the domain
	local ($recs, $file);
	local $changed;
	if (@delrecs) {
		&$first_print(&text('spf_delrecs', scalar(@delrecs)));
		if (!$recs) {
			&pre_records_change($d);
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		local @alld;
		foreach my $rn (@delrecs) {
			my ($name, $type, @values) = @$rn;
			if ($name !~ /\.$/) {
				$name .= ".".$d->{'dom'}.".";
				}
			local @d = grep { $_->{'name'} eq $name &&
					 lc($_->{'type'}) eq lc($type) } @$recs;
			if (@values) {
				# Also filter by values
				@d = grep { join(" ", @values) eq
					    join(" ", @{$_->{'values'}}) } @d;
				}
			push(@alld, @d);
			}
		foreach my $r (@alld) {
			&delete_dns_record($recs, $file, $r);
			$changed++;
			}
		&$second_print($text{'setup_done'});
		}

	# Add records to the domain
	if (@addrecs) {
		&$first_print(&text('spf_addrecs', scalar(@addrecs)));
		if (!$recs) {
			&pre_records_change($d);
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		foreach my $rn (@addrecs) {
			my ($name, $type, $ttl, $values, $proxied) = @$rn;
			if ($name !~ /\.$/ && $name ne "\@") {
				$name .= ".".$d->{'dom'}.".";
				}
			my $r = { 'name' => $name,
				  'type' => $type,
				  'ttl' => $ttl,
				  'values' => $values,
				  'proxied' => $proxied };
			my ($clash) = grep { $_->{'name'} eq $name &&
					     &bind8::join_record_values($_) eq
						&bind8::join_record_values($r) } @$recs;
			if ($clash) {
				&$second_print(&text('spf_eaddrecs', $r->{'name'}));
				}
			elsif ($proxied && (!$cloud || !$cloud->{'proxy'})) {
				&$second_print(&text('spf_eaddproxy', $r->{'name'}));
				}
			else {
				&create_dns_record($recs, $file, $r);
				$changed++;
				}
			}
		&$second_print($text{'setup_done'});
		}

	# Update records in the domain
	if (@uprecs) {
		&$first_print(&text('spf_uprecs', scalar(@addrecs)));
		if (!$recs) {
			&pre_records_change($d);
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		foreach my $rn (@uprecs) {
			my ($oldname, $oldtype, $name, $type, $ttl, $values, $proxied) = @$rn;
			if ($oldname !~ /\.$/ && $oldname ne "\@") {
				$oldname .= ".".$d->{'dom'}.".";
				}
			if ($name !~ /\.$/ && $name ne "\@") {
				$name .= ".".$d->{'dom'}.".";
				}
			my ($r) = grep { $_->{'name'} eq $oldname &&
					 $_->{'type'} eq $oldtype } @$recs;
			if (!$r) {
				&$second_print(&text('spf_euprecs', $oldname));
				}
			else {
				$r->{'name'} = $name;
				$r->{'type'} = $type;
				$r->{'ttl'} = $ttl if (defined($ttl));
				$r->{'proxied'} = $proxied
					if (defined($proxied));
				$r->{'values'} = $values;
				&modify_dns_record($recs, $file, $r);
				$changed++;
				}
			}

		&$second_print($text{'setup_done'});
		}

	# Set or modify default TTL
	if ($ttl && &supports_dns_defttl($d)) {
		&$first_print(&text('spf_ttl', $ttl));
		if (!$recs) {
			&pre_records_change($d);
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		($oldttl) = grep { $_->{'defttl'} } @$recs;
		if ($oldttl) {
			$oldttl->{'defttl'} = $ttl;
			&modify_dns_record($recs, $file, $oldttl);
			}
		else {
			&create_dns_record($recs, $file, $ttl);
			}
		$changed++;
		&$second_print($text{'setup_done'});
		}
	elsif ($ttl && !&supports_dns_defttl($d)) {
		&$first_print(&text('spf_ttl', $ttl));
		&$second_print($text{'spf_ettlsupport'});
		}

	# Change the TTL on any records that have one
	if ($allttl) {
		if (!$recs) {
			&pre_records_change($d);
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		foreach my $r (@$recs) {
			if ($r->{'ttl'} && $r->{'type'} ne 'SOA') {
				$r->{'ttl'} = $ttl;
				&modify_dns_record($recs, $file, $r);
				$changed++;
				}
			}
		}

	# Enable or disable DNSSEC
	if (defined($dnssec)) {
		if (&can_domain_dnssec($d)) {
			# DNSSEC is supported for this domain
			&pre_records_change($d);
			$key = &has_domain_dnssec($d, $recs);
			if ($dnssec && !$key) {
				# Enable it
				&$first_print($text{'spf_enablednssec'});
				$err = &enable_domain_dnssec($d);
				&$second_print($err || $text{'setup_done'});
				$changed++;
				}
			elsif (!$dnssec && $key) {
				# Disable it
				&$first_print($text{'spf_disablednssec'});
				$err = &disable_domain_dnssec($d);
				&$second_print($err || $text{'setup_done'});
				$changed++;
				}
			# Records may have changed, so re-read
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		else {
			# Not supported on remote providers
			&$first_print($dnssec ? $text{'spf_enablednssec'}
					      : $text{'spf_disablednssec'});
			&$second_print($text{'spf_ednssecsupport'});
			}
		}

	# Create or remove TLSA records
	if (defined($tlsa)) {
		&pre_records_change($d);
		if ($tlsa == 1) {
			&$first_print($text{'spf_enabletlsa'});
			$err = &check_tlsa_support();
			if ($err) {
				&$second_print(&text('spf_etlsa', $err));
				}
			else {
				&sync_domain_tlsa_records($d, 1);
				&$second_print($text{'setup_done'});
				$changed++;
				}
			}
		elsif ($tlsa == 0) {
			&$first_print($text{'spf_disabletlsa'});
			&sync_domain_tlsa_records($d, 2);
			&$second_print($text{'setup_done'});
			$changed++;
			}
		elsif ($tlsa == 2) {
			&$first_print($text{'spf_synctlsa'});
			my @recs = &get_domain_tlsa_records($d);
			if (@recs) {
				&sync_domain_tlsa_records($d, 1);
				&$second_print($text{'setup_done'});
				}
			else {
				&$first_print($text{'spf_esynctlsa'});
				}
			}
		if ($changed) {
			# Records have changed, so re-read
			($recs, $file) = &get_domain_dns_records_and_file($d);
			}
		}

	# Update DKIM records
	if (defined($dkim_enabled)) {
		my $olddkim = &has_dkim_domain($d, $dkim);
		if ($dkim_enabled == 1) {
			$d->{'dkim_enabled'} = 1;
			}
		elsif ($dkim_enabled == 0) {
			$d->{'dkim_enabled'} = 0;
			}
		else {
			delete($d->{'dkim_enabled'});
			}
		my $newdkim = &has_dkim_domain($d, $dkim);
		if (!$olddkim && $newdkim) {
			&update_dkim_domains($d, 'setup');
			}
		elsif ($olddkim && !$newdkim) {
			&update_dkim_domains($d, 'delete');
			}
		}

	# Move into a DNS sub-domain
	if (defined($submode)) {
		if ($submode == 1) {
			# Turning on sub-domain mode
			&$first_print($text{'spf_enablesub'});
			if ($d->{'dns_submode'}) {
				&$second_print($text{'spf_enablesubalready'});
				}
			elsif ($err = &save_dns_submode($d, 1)) {
				&$second_print(&text('spf_eenablesub', $err));
				}
			else {
				&$second_print($text{'setup_done'});
				}
			}
		else {
			# Turning off sub-domain mode
			&$first_print($text{'spf_disablesub'});
			if (!$d->{'dns_submode'}) {
				&$second_print($text{'spf_enablesubalready'});
				}
			elsif ($err = &save_dns_submode($d, 0)) {
				&$second_print(&text('spf_eenablesub', $err));
				}
			else {
				&$second_print($text{'setup_done'});
				}
			}
		}

	# Add or remove DS records in parent
	if (defined($parentds)) {
		my $err;
		if ($parentds) {
			&$first_print($text{'spf_enableds'});
			$err = &add_parent_dnssec_ds_records($d);
			}
		else {
			&$first_print($text{'spf_disableds'});
			$err = &delete_parent_dnssec_ds_records($d);
			}
		if ($err) {
			&$second_print(&text('spf_eenablesub', $err));
			}
		else {
			&$second_print($text{'setup_done'});
			}
		}

	if ($changed || $bumpsoa) {
		my $err = &post_records_change($d, $recs, $file);
		if ($err) {
			&$second_print(&text('spf_epostchange', $err));
			}
		&reload_bind_records($d);
		}

	# Add to slave DNS servers
	if (@addslaves) {
		&create_zone_on_slaves($d, join(" ", @addslaves));
		}
	if (@delslaves) {
		&delete_zone_on_slaves($d, join(" ", @delslaves));
		}

	# Remove slaves that are no longer valid
	if ($syncallslaves) {
		my @ds = split(/\s+/, $d->{'dns_slave'});
		my %slavenames = map { $_->{'host'}, $_ } @slaveservers;
		@ds = grep { $slavename{$_} } @ds;
		$d->{'dns_slave'} = join(" ", @ds);
		}

	# Change DNS Cloud
	if (defined($clouddns_import)) {
		$d->{'dns_cloud_import'} = $clouddns_import;
		}
	if ($clouddns) {
		if ($clouddns eq "local") {
			&$first_print($text{'spf_dnslocal'});
			}
		else {
			my ($c) = grep { $_->{'name'} eq $clouddns }
				       &list_dns_clouds();
			&$first_print(&text('spf_dnscloud', $c->{'name'}));
			}
		&$indent_print();
		my $err = &modify_dns_cloud($d, $clouddns);
		&$outdent_print();
		if ($err) {
			&$second_print(&text('spf_eclouddns', $err));
			}
		else {
			&$second_print($text{'setup_done'});
			}
		}

	# Change remote DNS server
	if ($rserver) {
		if ($rserver->{'id'} == 0) {
			&$first_print($text{'spf_dnsrlocal'});
			}
		else {
			&$first_print(&text('spf_dnsrhost',$rserver->{'host'}));
			}
		&$indent_print();
		my $err = &modify_dns_cloud($d, "local", $rserver);
		&$outdent_print();
		if ($err) {
			&$second_print(&text('spf_eclouddns', $err));
			}
		else {
			&$second_print($text{'setup_done'});
			}
		}

	&$outdent_print();
	&save_domain($d);
	&release_lock_dns($d);
	&$second_print(".. done");
	}

&run_post_actions();
&virtualmin_api_log(\@OLDARGV);
