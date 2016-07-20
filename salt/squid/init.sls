'''
This line sets the jinja template and the mapping context.
'''
{% from "squid/map.jinja" import map with context %}

'''
Check for and install squid
'''
squid:
  pkg.installed:
    - name: {{ pillar['pkgs']['squid'] }}

'''
Start the squid service but only if the package is present. If the squid config
or whitelist change then restart the service.
'''
squid_service:
  service.running:
    - name: {{ map.service }}
    - enable: True
    - require:
      - pkg: {{ pillar['pkgs']['squid'] }}
    - watch:
      - file: squid_config
      - file: whitelist

'''
Here we configure the squid configuration. By using pillar data for the file configuration
we can select the appropriate squid.conf for the environment automatically. The file will also
only be copied after squid is installed which prevents overwrting our changes with defaults.
'''
squid_config:
  file.managed:
    - name: {{ map.conf_dir }}/{{ map.conf_file }}
    - source: {{ pillar['conf_squid'] }}
    - require:
      - pkg: squid

'''
Here we configure the squid whitelist configuration. By using pillar data for the file configuration
we can select the appropriate whitelist for the environment automatically. The file will also
only be copied after squid is installed which prevents overwrting our changes with defaults.
'''
whitelist:
  file.managed:
    - name: {{ map.whitelist_dir }}/{{ map.whitelist_file }}
    - source: {{ pillar['conf_whitelist'] }}
    - require:
      - pkg: squid
