class thrift( $version="0.9.1", $executable="/usr/local/bin/thrift" )
{
	$yum_pkgs = [ "boost-devel",
		"boost-test",
		"boost-program-options",
		"libevent-devel",
		"automake",
		"libtool",
		"flex",
		"bison",
		"pkgconfig",
		"gcc-c++",
		"openssl-devel",
	]
	$apt_pkgs = [ "libboost-dev",
		"libboost-test-dev",
		"libboost-program-options-dev",
		"libevent-dev",
		"automake",
		"libtool",
		"flex",
		"bison",
		"pkg-config",
		"g++",
		"libssl-dev",
	]
	$digest_type = "md5"
	$thrift_url = "http://archive.apache.org/dist/thrift/${version}/thrift-${version}.tar.gz"
	$digest_url = "http://archive.apache.org/dist/thrift/${version}/thrift-${version}.tar.gz.${digest_type}"
	$archive_dir = "/usr/src"
	$thrift_dir = "/usr/local/lib"

	if $::osfamily == "RedHat"
	{
		$pkgs = $yum_pkgs
	}
	elsif $::operatingsystem == "Amazon"
	{
		$pkgs = $yum_pkgs
	}
	else
	{
		$pkgs = $apt_pkgs
	}

	package { $pkgs :
		ensure => present,
	}

	# $pkgs2 = [ 'curl', 'unzip', 'tar', ]
	# package { $pkgs2 :
	# ensure => present,
	# }

	# include "archive::prerequisites"

	package { ['unzip','tar'] :
		ensure => present
	}

	archive { "thrift-${version}" :
		ensure => present,
		url => $thrift_url,
		digest_url => $digest_url,
		digest_type => $digest_type,
		allow_insecure => true,
		src_target => $archive_dir,
		target => $thrift_dir,
		dependency_class => Package[ 'unzip', 'tar' ]
	}
	->
	exec{ "./configure --without-cpp --without-python --without-php_extension && make && make install && make clean" :
		provider => shell,
		cwd      => "${thrift_dir}/thrift-${version}",
		onlyif   => "test `find /usr/local/bin/ -name thrift | wc -l` = 0",
		timeout  => 0,
		require  => Package[ $pkgs ]
	}
}
