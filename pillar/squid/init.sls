'''
This file sets the environment that supplies the correct configuration
for the minions.
Changes to the grains can be made here in order to use alternative parameters for
minion selection.
An example of a change would be to use id instead of fqdn which would use the hostname rather than the
full fqdn. This proves useful where the servername contains either its role or environment.
'''
{% if grains['fqdn'].startswith('vag') %}
conf_squid: salt://squid/files/dev/dev-squid.conf
{% elif grains['fqdn'].startswith('prod') %}
conf_squid: salt://squid/files/prod/prod-squid.conf
{% else %}
conf_squid: salt://squid/files/squid.conf
{% endif %}

{% if grains['fqdn'].startswith('vag') %}
conf_whitelist: salt://squid/files/dev/whitelist
{% elif grains['fqdn'].startswith('prod') %}
conf_whitelist: salt://squid/files/prod/whitelist
{% else %}
conf_whitelist: salt://squid/files/whitelist
{% endif %}
