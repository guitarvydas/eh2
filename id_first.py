#!/usr/bin/env python3
import sys
from lxml import etree

def reorder_id_first(root):
    for el in root.iter():
        if 'id' in el.attrib:
            attribs = dict(el.attrib)
            el.attrib.clear()
            el.set('id', attribs.pop('id'))
            for k, v in attribs.items():
                el.set(k, v)
    return root

data = sys.stdin.buffer.read()
root = etree.fromstring(data)
reorder_id_first(root)
sys.stdout.buffer.write(etree.tostring(root, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
