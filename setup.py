#!/usr/bin/env python

#    Copyright 2017 Cargill Incorporated
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

from setuptools import setup
import unittest
version = '0.1.0'

def pipewrench_test_suite():
    test_loader = unittest.TestLoader()
    test_suite = test_loader.discover('pipewrench', pattern='*_test.py')
    return test_suite

setup(name='pipewrench',
      version=version,
      description='Framework for building data pipelines',
      author='Cargill Inc',
      url='https://cargill-inc.github.io/',
      install_requires=['jinja2', 'pyyaml', 'sdctool', 'pytest'],
      packages=['pipewrench'],
      test_suite='setup.pipewrench_test_suite',
      scripts=['pipewrench-merge']
      )
