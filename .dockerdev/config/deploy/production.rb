
  set :ssh_options, {
  	user: "ludake",
    keys: %w(~/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey)
 }


