#! /usr/bin/env python

# this script installs the usdvq layouts to the base.xml and evdev.xml
# files in /usr/share/X11/xkb/rules

# this worked but left out the top two comments on document which specified
# it's type.

rules_dir = '/usr/share/X11/xkb/rules/'
system_base_xml = rules_dir + 'base.xml'
system_evdev_xml = rules_dir + 'evdev.xml'
#
# using xml.etree is simpler BUT it does not preserve comments :(
# 
# from xml.etree import ElementTree as ET
# 
# partial_xml = ET.parse('base.xml')
# dvorak_qwerty_layout = partial_xml.getroot()
# 
# base_tree = ET.parse(base_xml)
# root = base_tree.getroot()
# 
# layout = root.find('.//layoutList')
# layout.insert(1, dvorak_qwerty_layout)
# base_tree.write('base.xml2')

from xml.dom import minidom

insert_file = 'base.xml'
edit_file = system_base_xml
dv = minidom.parse(insert_file)
dvorak_qwerty_layout = dv.childNodes[1]

base_tree = minidom.parse(edit_file)
layout_list = base_tree.getElementsByTagName('layoutList')[0]

if 'Dvorak-Qwerty' not in layout_list.toxml():
    layout_list.appendChild(dvorak_qwerty_layout)
    with open(edit_file, 'w') as xml_file:
        base_tree.writexml(xml_file)


# repeat the same thing for evdev.xml
insert_file = 'evdev.xml'
edit_file = system_evdev_xml
dv = minidom.parse(insert_file)
dvorak_qwerty_layout = dv.childNodes[1]

base_tree = minidom.parse(edit_file)
layout_list = base_tree.getElementsByTagName('layoutList')[0]

if 'Dvorak-Qwerty' not in layout_list.toxml():
    layout_list.appendChild(dvorak_qwerty_layout)
    with open(edit_file, 'w') as xml_file:
        base_tree.writexml(xml_file)


# now add list of variants to base.lst and evdev.lst
