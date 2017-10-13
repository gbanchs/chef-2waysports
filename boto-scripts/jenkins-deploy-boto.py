"""
Proof of concept deployment from Jenkins using boto:
http://docs.aws.amazon.com/opsworks/latest/APIReference/API_DeploymentCommand.html

a. You can use a stack level deployment command:  execute_recipes: and an Args
b. You can use deploy command for apps.


Working result will look like this:

In [30]: res = api.create_deployment(stack_id, command, app_id=app_id)

In [31]: res
Out[31]: {u'DeploymentId': u'809381c2-f597-4c9f-b785-caa82b2cd835'}

To deploy to only one instance:

In [37]: api.create_deployment(stack_id, command, app_id=app_id, instance_ids=[instance_id])
Out[37]: {u'DeploymentId': u'ec36bb6f-93bd-4ade-a007-9266f40d5ca7'}


"""

from boto.opsworks.layer1 import OpsWorksConnection

def deploy_erlang_rest_app():

	api = OpsWorksConnection()
	instance_id = "29c92563-e53c-4b24-85bb-8109784b7275"
	app_id = "5597648b-dc7f-437b-a0ed-df8b242bf8ef"
	command = {
    	    "Name": "deploy"
    	}
	stack_id = "55186abb-f9aa-44b3-b0c1-f607747725ab"
	res = api.create_deployment(stack_id, command, app_id=app_id, instance_ids=[instance_id])
	return res


if __name__ == "__main__":
	print(deploy_erlang_rest_app())