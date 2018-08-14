#!/usr/bin/env python
#coding:utf-8
import json

data = {}
with open('config.json') as json_file:
    data = json.load(json_file)
