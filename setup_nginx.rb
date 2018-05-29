# Since   : 2018-05-24
# OS      : Ubuntu 16.04

# Defines the update frequency for APT repositories
apt_update 'Update the apt cache daily' do
  # Determines how frequently (in seconds) APT repository updates are made.
  frequency 86_400
  
  # Update the Apt repository at the interval specified by the frequency property.
  action :update
end

# Installs the package.
package 'nginx'

# Manages the state of a service.
service 'nginx' do
  # A list of properties that controls how the chef-client is to attempt to manage a service
  supports status: true

  # Identifies the steps the chef-client will take to bring the node into the desired state
  # Enables a service at boot and then starts the service
  action [:enable, :start]
end

# Declares a directory and the permissions needed on that directory.
# Creates the /var/www/chef directory with 
# User        : www-data 
# Group       : www-data
# Permission  : 0755
directory '/var/www/chef' do
  owner 'www-data'
  group 'www-data'
  mode '0755'
  action :create
end

# Manages files that exist on nodes
# Creates the index.html file on /var/www/chef with the html content
file '/var/www/chef/index.html' do
  content '<html>
  <body>
    <h1>Hello NGINX from Chef</h1>
  </body>
</html>
'
end

# Creates the chef.conf file on /etc/nginx/sites-available with the nginx config
file '/etc/nginx/sites-available/chef.conf' do
  content 'server 
{
  listen      80;
  server_name _;
  root        /var/www/chef;
  index       index.html index.htm;
}
'
end

# Deletes the default nginx config.
file '/etc/nginx/sites-enabled/default' do
  action :delete
end

# Creates a symbolic link. This enables the chef.conf nginx config
link '/etc/nginx/sites-enabled/chef.conf' do
  to '/etc/nginx/sites-available/chef.conf'
  link_type :symbolic
end

# Restarts the nginx service
service 'nginx' do
  action [:restart]
end