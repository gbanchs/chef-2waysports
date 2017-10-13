#attribute data here

# - make release <ENV>
# - ./rel/APPNAME/bin/APPNAME start
# - ./rel/APPNAME/bin/APPNAME ping

# where ENV is: development, staging, qa, production
# Env specifics configs are in:
#    rel/files/<ENV>/sys.config (app settings)
#    rel/files/<ENV>/vm.args (vm settings)

# Available app settings and default vals:
#   db_db_name - "sqor_again"
#   db_host - "localhost"
#   db_password - "sqor"
#   db_pool - sqor_pool
#   db_pool_size - 10
#   db_port - 3306
#   db_user - "sqor"
#   dist_store_contact_node - localhost
#   sqor_rest_http_listeners - 100
#   sqor_rest_http_port - 8080
#   sqor_rest_loglevel - debug

