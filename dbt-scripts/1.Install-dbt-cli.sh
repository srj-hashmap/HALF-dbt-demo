#!/usr/bin/bash

# This script helps in installing dbt cli from the source 
sudo yum update -y 
sudo yum install -y redhat-rpm-config gcc libffi-devel bzip2-devel 
sudo yum install -y python3 python3-devel openssl-devel git python3 gcc make
curl -O https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz 
tar -xzf Python-3.8.1.tgz
pushd Python-3.8.1/
./configure --enable-optimizations
sudo make altinstall     
sudo rm $(which python3) 
sudo ln -s $(which python3.8) /usr/bin/python3 
python3 --version 
popd

sudo mkdir /dbt 
sudo chown -R $(whoami):$(whoami) /dbt
python3 -m venv /dbt
source /dbt/bin/activate
pip install --upgrade pip
pip install --upgrade setuptools
pip install dbt-core dbt-postgres dbt-redshift dbt-snowflake dbt-bigquery
deactivate 
echo 'export PATH="$PATH:/dbt/bin"' >> ~/.bashrc
source ~/.bashrc
dbt --version

# Output
# Core:
#   - installed: 1.1.0
#   - latest:    1.1.0 - Up to date!

# Plugins:
#   - snowflake: 1.1.0 - Up to date!
#   - postgres:  1.1.0 - Up to date!
#   - bigquery:  1.1.0 - Up to date!
#   - redshift:  1.1.0 - Up to date!