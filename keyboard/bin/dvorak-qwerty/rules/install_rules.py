#! /usr/bin/env python3
# MUST BE PYTHON3! Python2 cannot handle non-ascii characters in the xml
# files

# this script installs the usdvq layouts to the base.xml and evdev.xml
# files in /usr/share/X11/xkb/rules

rules_dir = '/usr/share/X11/xkb/rules/'
system_base_xml = rules_dir + 'base.xml'
system_evdev_xml = rules_dir + 'evdev.xml'
#
# using xml.etree is simpler BUT it does not preserve comments :(
# (which includes doctype)
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
import warnings
import sys
import os

# change to rules directory
script_location = os.path.dirname(os.path.abspath(__file__))
os.chdir(script_location)

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


# Add list of variants to base.lst and evdev.lst
dvq_layout_line = '  usdvq           English (Dvorac-Qwerty)\n'
dvq_variant_lines = """
  dvq-simplified  usdvq: English (Dvorak-Qwerty, simplified)
  dvorak-qwerty   usdvq: English (Dvorak Qwerty)
  dvq-intl        usdvq: English (Dvorak-Qwerty, international with dead keys)
  dvq-alt-intl    usdvq: English (Dvorak-Qwerty alternative international no dead keys)
  dvq-classic     usdvq: English (Dvorak-Qwerty, classic)
  dvqp            usdvq: English (Dvorak-Qwerty, programmer)
"""
for filename in [rules_dir + 'base.lst', rules_dir + 'evdev.lst']:
    lines = None
    with open(filename, 'r') as f:
        lines = f.read()

    # verify Dvorak-Qwerty not already installed
    if 'Dvorak-Qwerty' in lines:
        warnings.warn(
            '\n' + filename + ' already has "Dvorak-Qwerty" installed.\n'
        )
        continue

    # Add usdvq layout to list of layouts
    start_layout = lines.find('! layout')
    start_us = lines.find(' us ', start_layout)
    cut = lines.find('\n', start_us)
    lines = lines[:cut + 1] + dvq_layout_line + lines[cut + 1:]

    start_variants = lines.find('! variant')
    last_us_variants = lines.rfind('us: English', start_variants)
    cut = lines.find('\n', last_us_variants)
    lines = lines[:cut + 1] + dvq_variant_lines + lines[cut + 1:]

    with open(filename, 'w') as f:
        f.write(lines)

sys.exit(0)  # notify calling script of success
