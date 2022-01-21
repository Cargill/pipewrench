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
import os
import sys

version = '1.1.1'

def pipewrench_test_suite():
    test_loader = unittest.TestLoader()
    test_suite = test_loader.discover('pipewrench', pattern='*_test.py')
    return test_suite

def gen_data_files(*dirs):
    # If we are building an rpm, generate list of data files to include. Otherwise, return none.
    if '--single-version-externally-managed' in sys.argv:
        results = []
        for src_dir in dirs:
            for root,dirs,files in os.walk(src_dir):
                results.append(('/usr/share/pipewrench/' + root, map(lambda f:root + "/" + f, files)))
        return results
    else:
        return

setup(name='pipewrench',
      version=version,
      description='Framework for building data pipelines',
      author='Cargill Inc',
      url='https://cargill.github.io/',
      install_requires=['jinja2==2.10.1', 'pyyaml>=4.2b1', 'pytest<=3.3.1', 'pylint<=1.8.1'],
      packages=['pipewrench'],
      test_suite='setup.pipewrench_test_suite',
      scripts=['pipewrench-merge'],
      data_files=gen_data_files('templates')
      )

