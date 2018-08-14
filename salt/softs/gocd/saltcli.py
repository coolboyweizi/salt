#!/usr/bin/env python
#coding:utf-8


import sys


s = {"aasd":{"sss":123,"start_time":0},"skk":{"start_time":122,"kkk":"223"},"kksd":{"start_time":32,"sd":23}}

b = sorted(s.items(),key = lambda x:x[1]['start_time'],reverse=True)

print b