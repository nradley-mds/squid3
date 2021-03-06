# This line sets the jinja template and the paramsping context.

{% from "squid/params.jinja" import params with context %}

# Check for and install squid

squid:
  pkg.installed:
    - name: {{ params.pkgs }}

# Start the squid service but only if the package is present. If the squid config
# or whitelist change then restart the service.

squid_service:
  service.running:
    - name: {{ params.service }}
    - enable: True
    - require:
      - pkg: squid
    - watch:
      - file: squid_config
      - file: whitelist

# Here we configure the squid configuration. By using pillar data for the file configuration
# we can select the appropriate squid.conf for the environment automatically. The file will also
# only be copied after squid is installed which prevents overwrting our changes with defaults.

squid_config:
  file.managed:
    - name: {{ params.conf_dir }}/{{ params.conf_file }}
    - source: {{ pillar['conf_squid'] }}
    - require:
      - pkg: squid

# Here we configure the squid whitelist configuration. By using pillar data for the file configuration
# we can select the appropriate whitelist for the environment automatically. The file will also
# only be copied after squid is installed which prevents overwrting our changes with defaults.

whitelist:
  file.managed:
    - name: {{ params.whitelist_dir }}/{{ params.whitelist_file }}
    - source: {{ pillar['conf_whitelist'] }}
    - require:
      - pkg: squid
