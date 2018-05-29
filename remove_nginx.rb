# Since   : 2018-05-24
# OS      : Ubuntu 16.04

# Uninstalls the nginx packages.
package 'nginx' do
  action :purge
end

package 'nginx-common' do
  action :purge
end

package 'nginx-core' do
  action :purge
end