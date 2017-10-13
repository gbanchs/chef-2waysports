script "install_erlang" do 
	interpreter "bash"
	user "root"
	cwd "/opt"
	code <<-EOH
		rm -rf /opt/hubbard
		git clone git@github.com:Amplify-Social/hubbard.git
		cd hubbard
		make release
		./rel/hubbard/bin/hubbard stop
		DB_HOST=sqor-again.coj7sdku21ix.us-east-1.rds.amazonaws.com DB_PASSWORD=sqorsqor SQOR_REST_HTTP_PORT=80 ./rel/hubbard/bin/hubbard start
	EOH
end
