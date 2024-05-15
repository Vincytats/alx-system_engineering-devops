# Increase the ULIMIT of the default file
exec { 'fix--for-nginx':
  command => 'sed -i "s/15/4096/" /etc/default/nginx',
  path    => ['/usr/local/bin', '/bin', '/usr/bin'],
  onlyif  => 'grep -q "ULIMIT=15" /etc/default/nginx',  # Ensure the change is needed
} ->

# Restart Nginx using systemd
exec { 'nginx-restart':
  command     => '/bin/systemctl restart nginx',
  path        => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
  refreshonly => true,
  subscribe   => Exec['fix--for-nginx'],
}
