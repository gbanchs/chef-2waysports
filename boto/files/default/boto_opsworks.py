#! /usr/bin/env python

from boto.opsworks.layer1 import OpsWorksConnection
from collections import namedtuple
import argparse
import json
import sys


__version__ = '0.0.1'


def list_instance(api, resource):
    if not resource.layer:
        raise Exception('Layer resource required for listing instances')

    if not resource.stack:
        raise Exception('Stack resource required for listing instances')

    stack_id = get_stack_id(api, resource.stack)
    if not stack_id:
        raise Exception('No stack by that name: %s' % resource.stack)

    layer_id = get_layer_id(api, stack_id, resource.layer)
    if not layer_id:
        raise Exception('No layer by that name: %s' % resource.layer)

    return get_instance_data(api, layer_id, resource.instance)


def connect():
    return OpsWorksConnection()


def parse_resource(resource):
    parts = []
    if resource:
        parts.extend(resource.split(':'))

    result = []
    for i in range(0, 3):
        if len(parts) > 0:
            part = parts.pop(0).lower() or None
            result.append(part)
        else:
            result.append(None)
    Resource = namedtuple('Resource', ['stack', 'layer', 'instance'])
    return Resource(result[0], result[1], result[2])


def get_instance_data(api, layer_id, instance_name=None):
    instances = api.describe_instances(layer_id=layer_id)
    if instance_name:
        for i in instances['Instances']:
            if instance_name.lower() == i['Name'].lower():
                return i
        return None
    return instances['Instances']


def get_instance_ids(api, layer_id):
    instances = api.describe_instances(layer_id=layer_id)
    instance_ids = []
    for i in instances['Instances']:
        instance_ids.append(str(i['InstanceId']))

    return instance_ids


def get_instance_id(api, layer_id, name):
    instances = api.describe_instances(layer_id=layer_id)
    for i in instances['Instances']:
        if name.lower() == i['Name'].lower():
            return str(i['IstanceId'])
    return None


def get_layer_ids(api, stack_id):
    layers = api.describe_layers(stack_id)
    layer_ids = []
    for l in layers['Layers']:
        layer_ids.append(str(l['LayerId']))

    return layer_ids


def get_layer_id(api, stack_id, name):
    layers = api.describe_layers(stack_id)
    for l in layers['Layers']:
        if name.lower() == l['Name'].lower():
            return str(l['LayerId'])
    return None


def get_stack_id(api, name):
    stacks = api.describe_stacks()
    for s in stacks['Stacks']:
        if name.lower() == s['Name'].lower():
            return str(s['StackId'])
    return None


def get_app_id(api, stack_id, name):
    apps = api.describe_apps(stack_id)
    for a in apps['Apps']:
        if name.lower() == a['Name'].lower():
            return str(a['AppId'])
    return None


action_map = {
    'list_instance': list_instance
}


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fetch data from aws '
                                     'opsworks')
    parser.add_argument('--version', action='version',
                        version='%(prog)s ' + __version__)
    parser.add_argument('object', metavar='OBJECT',
                        choices=['stack', 'layer', 'instance'],
                        help='stack|layer|instance')
    parser.add_argument('action', metavar='ACTION', choices=['list'],
                        help='list')
    parser.add_argument('resource', metavar='RESOURCE', type=str, nargs='?',
                        help="""A resource is meta data to help locate the
                        requested object. stack:layer:instance.
                        stack|
                        stack:layer|
                        stack:layer:instance
                        """)

    try:
        args = parser.parse_args()
        api = connect()
        resource = parse_resource(args.resource)
        action = '_'.join([args.action, args.object])
        print(json.dumps(action_map[action](api, resource)))
    except Exception as e:
        sys.exit('ERROR: %s' % e)
