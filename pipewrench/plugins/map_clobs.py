
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

def map_clobs(columns):
    """
    The map_clobs function will inject the following if there
    are clob data types. --map-column-java col6=String,col8=String
    This is needed as clob columns will not come into Hadoop unless
    we specifically map them.
    """
    hasclobs = False
    clobs = ""
    for c in columns:
        if c.get("datatype").lower() == "clob":
            if not hasclobs:
                hasclobs = True
                clobs = "--map-column-java "
            clobs = clobs + c.get("name") + "=String,"
    return clobs[:-1]
